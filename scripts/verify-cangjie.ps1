param(
    [Parameter(Mandatory=$true)][string]$SdkHome,
    [string]$OutputRoot,
    [string]$Runner = 'PowerShell caller (operator not inferred)',
    [string]$MaterialVersion = '1.2.0'
)
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
if (-not $OutputRoot) { $OutputRoot = Join-Path $root 'validation' }
if (-not [IO.Path]::IsPathRooted($OutputRoot)) { $OutputRoot = Join-Path $root $OutputRoot }
$setup = Join-Path $SdkHome 'envsetup.ps1'
if (-not (Test-Path $setup)) { throw 'SdkHome must contain envsetup.ps1 and bin/cjc.exe.' }
. $setup
$localFix = Join-Path $SdkHome 'LOCAL-RUNTIME-FIX.json'
$label = if (Test-Path $localFix) { 'cangjie-localfix' } else { 'cangjie-normal' }
$folder = Join-Path $OutputRoot $label
$build = Join-Path $root 'cangjie/build'
New-Item -ItemType Directory -Force $folder, $build | Out-Null
if (Test-Path $localFix) { Copy-Item -LiteralPath $localFix -Destination "$folder/LOCAL-RUNTIME-FIX.json" -Force }
Get-FileHash (Join-Path $SdkHome 'runtime/lib/windows_x86_64_cjnative/libcangjie-runtime.dll') -Algorithm SHA256 | Format-List | Out-String | Set-Content "$folder/runtime-checksum.txt" -Encoding utf8
$files = @(Get-ChildItem (Join-Path $root 'cangjie/src/*.cj') | ForEach-Object FullName)
$exe = Join-Path $build 'starter-tests.exe'
& cjc --version 2>&1 | Set-Content "$folder/environment.txt" -Encoding utf8
"Time: $([DateTimeOffset]::Now.ToString('o'))`nRunner: $Runner`nMaterial version: $MaterialVersion`nCommand: cjc <all src/*.cj files> --test -o build/starter-tests.exe; build/starter-tests.exe`nSDK: $SdkHome`nFiles: $($files -join ', ')" | Set-Content "$folder/invocation.txt" -Encoding utf8
$hashes = @($files | ForEach-Object { [PSCustomObject]@{path=$_.Substring($root.Length + 1).Replace('\','/'); sha256=(Get-FileHash -LiteralPath $_ -Algorithm SHA256).Hash.ToLowerInvariant()} })
$hashes | ConvertTo-Json -Depth 4 | Set-Content "$folder/source-sha256.json" -Encoding utf8
'' | Set-Content "$folder/compile.log" -Encoding utf8
& cjc @files --test -o $exe 2>&1 | Tee-Object -FilePath "$folder/compile.log" | Out-Host
$code = $LASTEXITCODE
$code | Set-Content "$folder/compile-exit-code.txt"
if ($code -ne 0) { throw "Cangjie compilation failed: $code" }
& $exe 2>&1 | Tee-Object -FilePath "$folder/test.log" | Out-Host
$code = $LASTEXITCODE
$code | Set-Content "$folder/test-exit-code.txt"
if ($code -ne 0) { throw "Cangjie test execution failed: $code" }
