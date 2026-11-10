param([string]$PythonExecutable, [switch]$CheckOnly)
$ErrorActionPreference = 'Stop'
& (Join-Path $PSScriptRoot '主体/scripts/start_gui.ps1') -PythonExecutable $PythonExecutable -CheckOnly:$CheckOnly
exit $LASTEXITCODE
