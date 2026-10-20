param(
    [string]$JavaHome = $env:JAVA_HOME,
    [string]$Maven = 'mvn',
    [string]$OutputRoot,
    [string]$Runner = 'PowerShell caller (operator not inferred)',
    [string]$MaterialVersion = '1.2.0'
)
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
if (-not $OutputRoot) { $OutputRoot = Join-Path $root 'validation' }
if (-not [IO.Path]::IsPathRooted($OutputRoot)) { $OutputRoot = Join-Path $root $OutputRoot }
New-Item -ItemType Directory -Force $OutputRoot | Out-Null
if ($JavaHome) { $env:JAVA_HOME = $JavaHome; $env:Path = "$JavaHome\bin;$env:Path" }
$source = Join-Path $root 'java/src/main/java/study/translation/Account.java'
$original = [IO.File]::ReadAllText($source)
if (-not $original.Contains('balance -= amount;')) { throw 'Expected original withdrawal statement was not found.' }
# 执行一个阶段并保存完整输出、测试报告和该阶段源码哈希。
function Run-Phase([string]$name) {
    $folder = Join-Path $OutputRoot $name
    New-Item -ItemType Directory -Force $folder | Out-Null
    "Time: $([DateTimeOffset]::Now.ToString('o'))`nRunner: $Runner`nMaterial version: $MaterialVersion`nCommand: $Maven -B -ntp clean test`nWorking directory: $root/java" | Set-Content "$folder/invocation.txt" -Encoding utf8
    $hashes = @(Get-ChildItem (Join-Path $root 'java/src') -Recurse -File -Filter '*.java' | Sort-Object FullName | ForEach-Object { [PSCustomObject]@{path=$_.FullName.Substring($root.Length + 1).Replace('\','/'); sha256=(Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash.ToLowerInvariant()} })
    $hashes | ConvertTo-Json -Depth 4 | Set-Content "$folder/source-sha256.json" -Encoding utf8
    & $Maven -version 2>&1 | Set-Content "$folder/environment.txt" -Encoding utf8
    & $Maven -B -ntp clean test 2>&1 | Tee-Object -FilePath "$folder/console.log" | Out-Host
    $code = $LASTEXITCODE
    $code | Set-Content "$folder/exit-code.txt"
    $reports = Join-Path $root 'java/target/surefire-reports'
    if (Test-Path $reports) {
        New-Item -ItemType Directory -Force "$folder/reports" | Out-Null
        # 复制报告文件本身，避免重复运行时套出reports/surefire-reports子目录。
        Get-ChildItem -LiteralPath $reports -File | Copy-Item -Destination "$folder/reports" -Force
    }
    return $code
}
Push-Location (Join-Path $root 'java')
try {
    $normal = Run-Phase 'java-normal'
    if ($normal -ne 0) { throw 'Normal Java tests failed.' }
    try {
        [IO.File]::WriteAllText($source, $original.Replace('balance -= amount;', 'balance += amount;'), [Text.UTF8Encoding]::new($false))
        "Account.withdraw: balance -= amount; -> balance += amount; (withdrawal incorrectly increases balance)" | Set-Content (Join-Path $OutputRoot 'mutation.txt') -Encoding utf8
        $mutant = Run-Phase 'java-mutant'
    } finally {
        [IO.File]::WriteAllText($source, $original, [Text.UTF8Encoding]::new($false))
    }
    $restored = Run-Phase 'java-restored'
    if ($restored -ne 0) { throw 'Restored Java tests failed.' }
    if ($mutant -eq 0) { throw 'Mutation was not detected.' }
    $suites = @(Get-ChildItem (Join-Path $OutputRoot 'java-mutant/reports') -Filter 'TEST-*.xml' | ForEach-Object { ([xml](Get-Content -LiteralPath $_.FullName -Raw)).testsuite })
    $failureCount = ($suites | Measure-Object -Property failures -Sum).Sum
    $errorCount = ($suites | Measure-Object -Property errors -Sum).Sum
    if ($failureCount -ne 4 -or $errorCount -ne 0) { throw 'Mutation did not produce the four expected assertion failures; inspect reports.' }
    if ([IO.File]::ReadAllText($source) -ne $original) { throw 'Source restoration did not match original.' }
    Write-Output 'Verified: normal passed, mutant failed, restored passed. Inspect failure assertions in the reports.'
} finally { Pop-Location }
