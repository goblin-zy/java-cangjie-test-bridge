param([Parameter(Mandatory=$true)][string]$SdkHome)
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
. (Join-Path $SdkHome 'envsetup.ps1')
$folder = Join-Path $root 'validation/cangjie-source'
$build = Join-Path $root 'cangjie/build'
New-Item -ItemType Directory -Force $folder, $build | Out-Null
$files = @(Get-ChildItem (Join-Path $root 'cangjie/src/*.cj') | Where-Object Name -NotLike '*_test.cj' | ForEach-Object FullName)
& cjc --version 2>&1 | Set-Content "$folder/environment.txt" -Encoding utf8
"Time: $([DateTimeOffset]::Now.ToString('o'))`nCommand: cjc <business .cj files> --output-type staticlib -o build/starter.a`nFiles: $($files -join ', ')" | Set-Content "$folder/invocation.txt" -Encoding utf8
'' | Set-Content "$folder/compile.log" -Encoding utf8
& cjc @files --output-type staticlib -o (Join-Path $build 'starter.a') 2>&1 | Tee-Object -FilePath "$folder/compile.log" | Out-Host
$code = $LASTEXITCODE
$code | Set-Content "$folder/exit-code.txt"
if ($code -ne 0) { throw "Business-source compilation failed: $code" }
Write-Output 'Business source compiled. This does not confirm execution or test compilation.'
