param(
    [Parameter(Mandatory=$true)][string]$InputPath,
    [Parameter(Mandatory=$true)][string]$OutputDirectory,
    [string]$JavaHome = $env:JAVA_HOME
)
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
if (-not $JavaHome) { throw 'Set JAVA_HOME to a full JDK17+ installation or pass -JavaHome.' }
$javac = Join-Path $JavaHome 'bin/javac.exe'
$java = Join-Path $JavaHome 'bin/java.exe'
if (-not (Test-Path -LiteralPath $javac)) { throw 'A full JDK with javac.exe is required.' }
$classes = Join-Path $root 'build/extractor'
New-Item -ItemType Directory -Force $classes | Out-Null
# 提取器仅使用JDK自带模块，不需要Maven或额外下载解析库。
& $javac -encoding UTF-8 --add-modules jdk.compiler -d $classes (Join-Path $root 'src/main/java/JavaTestSkeletonExtractor.java')
if ($LASTEXITCODE -ne 0) { throw 'Extractor compilation failed.' }
& $java '-Dfile.encoding=UTF-8' --add-modules jdk.compiler -cp $classes JavaTestSkeletonExtractor --input (Resolve-Path -LiteralPath $InputPath).Path --output ([IO.Path]::GetFullPath($OutputDirectory))
if ($LASTEXITCODE -ne 0) { throw 'Extraction reported errors. Inspect members.json diagnostics when present.' }
