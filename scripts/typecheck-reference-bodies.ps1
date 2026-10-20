param([Parameter(Mandatory=$true)][string]$SdkHome)
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
. (Join-Path $SdkHome 'envsetup.ps1')
$temp = Join-Path $root 'cangjie/build/typecheck'
$log = Join-Path $root 'validation/cangjie-typecheck'
New-Item -ItemType Directory -Force $temp, $log | Out-Null
foreach ($file in Get-ChildItem (Join-Path $root 'cangjie/src/*.cj')) {
    $text = [IO.File]::ReadAllText($file.FullName)
    $text = $text.Replace('import std.unittest.*','').Replace('import std.unittest.testmacro.*','').Replace('@TestCase','').Replace('@Test','').Replace('@Expect(', 'check(').Replace('@Assert(', 'check(')
    [IO.File]::WriteAllText((Join-Path $temp $file.Name), $text, [Text.UTF8Encoding]::new($false))
}
$checks = @'
package starter
func check(a: Int64, b: Int64): Unit { if (a != b) { throw Exception("different integer") } }
func check(a: Bool, b: Bool): Unit { if (a != b) { throw Exception("different boolean") } }
func check(a: String, b: String): Unit { if (a != b) { throw Exception("different string") } }
'@
[IO.File]::WriteAllText((Join-Path $temp 'checks.cj'), $checks, [Text.UTF8Encoding]::new($false))
$files = @(Get-ChildItem "$temp/*.cj" | ForEach-Object FullName)
& cjc --version 2>&1 | Set-Content "$log/environment.txt" -Encoding utf8
"Time: $([DateTimeOffset]::Now.ToString('o'))`nDiagnostic only: replace test macros with ordinary typed comparison functions; compile as staticlib. No execution and no official macro validation." | Set-Content "$log/invocation.txt" -Encoding utf8
'' | Set-Content "$log/compile.log" -Encoding utf8
& cjc @files --output-type staticlib -o (Join-Path $temp 'checked.a') 2>&1 | Tee-Object -FilePath "$log/compile.log" | Out-Host
$code = $LASTEXITCODE
$code | Set-Content "$log/exit-code.txt"
if ($code -ne 0) { throw "Reference-body type check failed: $code" }
Write-Output 'Reference method bodies type-checked; official test macros and runtime remain unverified.'
