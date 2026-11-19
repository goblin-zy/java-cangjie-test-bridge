param(
    [Parameter(Mandatory=$true)][string]$InputPath,
    [Parameter(Mandatory=$true)][string]$OutputDirectory,
    [string]$JavaHome
)
$ErrorActionPreference = 'Stop'
$shared = Join-Path (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent) 'environment-config'
$jdk = if ($JavaHome) { $JavaHome } else { Join-Path $shared 'tools\jdk-17' }
$javac = Join-Path $jdk 'bin\javac.exe'
$java = Join-Path $jdk 'bin\java.exe'
if (-not (Test-Path -LiteralPath $javac)) { throw "JDK missing: $jdk" }
$inputFull = (Resolve-Path -LiteralPath $InputPath).Path
$outputFull = [IO.Path]::GetFullPath($OutputDirectory)
$source = Join-Path $PSScriptRoot 'src\JavaTestSkeletonExtractor.java'
$classes = Join-Path $PSScriptRoot 'build'
New-Item -ItemType Directory -Force -Path $classes | Out-Null
& $javac -encoding UTF-8 --add-modules jdk.compiler -d $classes $source
if ($LASTEXITCODE -ne 0) { throw 'Extractor compilation failed.' }
& $java '-Dfile.encoding=UTF-8' --add-modules jdk.compiler -cp $classes JavaTestSkeletonExtractor --input $inputFull --output $outputFull
if ($LASTEXITCODE -ne 0) { throw 'Extraction reported errors. Inspect members.json diagnostics when present.' }
