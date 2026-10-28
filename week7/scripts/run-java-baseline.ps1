param([string]$JavaHome=$env:JAVA_HOME,[string]$OutputDirectory,[switch]$Offline)
$ErrorActionPreference='Stop'
$root=Split-Path -Parent $PSScriptRoot
if (-not $JavaHome) { throw 'Pass a full JDK17+ directory with -JavaHome.' }
if (-not $OutputDirectory) { $OutputDirectory=Join-Path $root ('validation/java-'+(Get-Date -Format 'yyyyMMdd-HHmmssfff')) }
$OutputDirectory=[IO.Path]::GetFullPath($OutputDirectory)
if ((Test-Path -LiteralPath $OutputDirectory) -and (Get-ChildItem -LiteralPath $OutputDirectory -Force | Select-Object -First 1)) { throw 'Use a new or empty output directory.' }
New-Item -ItemType Directory -Force $OutputDirectory | Out-Null
$env:JAVA_HOME=$JavaHome;$env:Path="$JavaHome\bin;$env:Path"
$env:MAVEN_OPTS="$env:MAVEN_OPTS -Dfile.encoding=UTF-8"
$mavenArgs=@('-B','-ntp');if($Offline){$mavenArgs+= '-o'};$mavenArgs+=@('clean','test')
$project=Join-Path $root 'examples/week6/java'
"Time: $([DateTimeOffset]::Now.ToString('o'))`nRunner: week7 automated baseline validation`nDirectory: $project`nCommand: mvn $($mavenArgs -join ' ')`nMAVEN_OPTS adds -Dfile.encoding=UTF-8" | Set-Content "$OutputDirectory/invocation.txt" -Encoding utf8
& mvn -version 2>&1 | Set-Content "$OutputDirectory/environment.txt" -Encoding utf8
Push-Location $project
try {
    & mvn @mavenArgs 2>&1 | Tee-Object -FilePath "$OutputDirectory/console.log" | Out-Host
    $code=$LASTEXITCODE;$code | Set-Content "$OutputDirectory/exit-code.txt"
    New-Item -ItemType Directory -Force "$OutputDirectory/reports" | Out-Null
    Get-ChildItem -LiteralPath (Join-Path $project 'target/surefire-reports') -File | Copy-Item -Destination "$OutputDirectory/reports"
    if($code -ne 0){throw "Java baseline failed: $code"}
} finally { Pop-Location }
