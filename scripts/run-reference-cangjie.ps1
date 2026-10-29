param(
    [Parameter(Mandatory=$true)][string]$SdkHome,
    [string]$ImplementationDirectory,
    [string]$TestsDirectory,
    [string]$OutputDirectory,
    [ValidateNotNullOrEmpty()][string]$TestFilter = '*'
)
$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [Text.UTF8Encoding]::new($false)
$OutputEncoding = [Console]::OutputEncoding
$root = Split-Path -Parent $PSScriptRoot
$allExpected = @((Get-Content -LiteralPath (Join-Path $root 'reference/cases.json') -Raw -Encoding UTF8 | ConvertFrom-Json).cases)
$expected = @($allExpected | Where-Object { "$($_.suite).$($_.method)" -clike $TestFilter })
if ($expected.Count -eq 0) { throw 'No matching reference test. Use ClassName.methodName, for example AccountTest.testWithdraw, or RectangleTest.*.' }
if (-not $ImplementationDirectory) { $ImplementationDirectory = Join-Path $root 'reference/cangjie/implementation' }
if (-not $TestsDirectory) { $TestsDirectory = Join-Path $root 'reference/cangjie/tests' }
if (-not $OutputDirectory) { $OutputDirectory = Join-Path $root ('validation/reference-' + (Get-Date -Format 'yyyyMMdd-HHmmssfff')) }
$OutputDirectory = [IO.Path]::GetFullPath($OutputDirectory)
if ((Test-Path -LiteralPath $OutputDirectory) -and (Get-ChildItem -LiteralPath $OutputDirectory -Force | Select-Object -First 1)) { throw 'Use a new or empty output directory.' }
New-Item -ItemType Directory -Force $OutputDirectory | Out-Null
if (-not (Test-Path -LiteralPath (Join-Path $SdkHome 'envsetup.ps1'))) { throw 'SDK root must contain envsetup.ps1.' }
. (Join-Path $SdkHome 'envsetup.ps1')
$files = @(Get-ChildItem -LiteralPath $ImplementationDirectory -Recurse -File -Filter '*.cj' | Sort-Object FullName | ForEach-Object FullName)
$files += @(Get-ChildItem -LiteralPath $TestsDirectory -Recurse -File -Filter '*.cj' | Sort-Object FullName | ForEach-Object FullName)
if ($files.Count -eq 0) { throw 'No Cangjie source files found.' }
$exe = Join-Path $OutputDirectory 'reference-tests.exe'
& cjc --version 2>&1 | Set-Content "$OutputDirectory/environment.txt" -Encoding utf8
$runtime = Join-Path $SdkHome 'runtime/lib/windows_x86_64_cjnative/libcangjie-runtime.dll'
$runtimeHash = (Get-FileHash -LiteralPath $runtime -Algorithm SHA256).Hash.ToLowerInvariant()
$localFixFile = Join-Path $SdkHome 'LOCAL-RUNTIME-FIX.json'
$runtimeLabel = if (Test-Path -LiteralPath $localFixFile) { 'localfix (nonofficial experimental runtime)' } else { 'SDK runtime; no localfix marker' }
if (Test-Path -LiteralPath $localFixFile) { Copy-Item -LiteralPath $localFixFile -Destination "$OutputDirectory/LOCAL-RUNTIME-FIX.json" }
$runArgs = @('--no-color','--no-progress')
if ($TestFilter -ne '*') { $runArgs += "--filter=$TestFilter" }
"Time: $([DateTimeOffset]::Now.ToString('o'))`nRunner: week7 automated reference validation`nRuntime: $runtimeLabel`nRuntime SHA256: $runtimeHash`nSelected filter: $TestFilter`nSelected expected tests: $($expected.Count)`nCommand: cjc $($files -join ' ') --test -o $exe`nThen: $exe $($runArgs -join ' ')`nSDK installation path omitted; runtime identity recorded above." | Set-Content "$OutputDirectory/invocation.txt" -Encoding utf8
@($files | ForEach-Object { [PSCustomObject]@{file=$_;sha256=(Get-FileHash -LiteralPath $_ -Algorithm SHA256).Hash.ToLowerInvariant()} }) | ConvertTo-Json -Depth 4 | Set-Content "$OutputDirectory/source-sha256.json" -Encoding utf8
'' | Set-Content "$OutputDirectory/compile.log" -Encoding utf8
& cjc @files --test -o $exe 2>&1 | Tee-Object -FilePath "$OutputDirectory/compile.log" | Out-Host
$compileCode = $LASTEXITCODE
$compileCode | Set-Content "$OutputDirectory/compile-exit-code.txt"
if ($compileCode -ne 0) { throw "Reference compilation failed: $compileCode" }
& $exe @runArgs 2>&1 | Tee-Object -FilePath "$OutputDirectory/test.log" | Out-Host
$runCode = $LASTEXITCODE
$runCode | Set-Content "$OutputDirectory/test-exit-code.txt"
$clean = [regex]::Replace([IO.File]::ReadAllText("$OutputDirectory/test.log"), '\x1B\[[0-?]*[ -/]*[@-~]', '')
$found = @{}; $suite = ''
foreach ($line in ($clean -split "`n")) {
    if ($line -match 'TCS:\s*(\w+)') { $suite=$Matches[1] }
    if ($line -match '\[\s*(PASSED|FAILED|ERROR|SKIPPED)\s*\]\s*CASE:\s*([^\s(]+)') { $found["${suite}::$($Matches[2])"]=$Matches[1].ToLowerInvariant() }
}
$rows = @($expected | ForEach-Object { $key="$($_.suite)::$($_.method)"; [PSCustomObject]@{id=$_.id;suite=$_.suite;method=$_.method;status=if($found.ContainsKey($key)){$found[$key]}else{'not_executed'}} })
$result = [PSCustomObject]@{runtime_label=$runtimeLabel;runtime_sha256=$runtimeHash;compile_exit=$compileCode;run_exit=$runCode;filter=$TestFilter;total_defined_tests=$allExpected.Count;filter_excluded=$allExpected.Count-$expected.Count;expected=$expected.Count;discovered_in_final_report=$found.Count;passed=@($rows | Where-Object status -eq 'passed').Count;failed=@($rows | Where-Object status -eq 'failed').Count;error=@($rows | Where-Object status -eq 'error').Count;skipped=@($rows | Where-Object status -eq 'skipped').Count;not_executed=@($rows | Where-Object status -eq 'not_executed').Count;cases=$rows}
$result | ConvertTo-Json -Depth 6 | Set-Content "$OutputDirectory/results.json" -Encoding utf8
Write-Output "Reference results: $OutputDirectory/results.json"
if ($result.expected -ne $result.discovered_in_final_report -or $result.not_executed -ne 0) { throw 'Reference test discovery/execution mismatch.' }
if ($result.skipped -ne 0) { throw 'A selected reference test was skipped instead of executed.' }
if ($runCode -ne 0) { exit $runCode }
