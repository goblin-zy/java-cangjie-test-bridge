param([string]$PythonExecutable, [switch]$CheckOnly)
$ErrorActionPreference = 'Stop'
$projectRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '../..'))
$guiFile = Join-Path $projectRoot '主体/src/gui.py'

function Find-Interpreter([string]$candidate) {
    $command = Get-Command $candidate -ErrorAction SilentlyContinue
    if (-not $command -or $command.Source -like '*WindowsApps*') { return $null }
    $prefix = @()
    if ($candidate -eq 'py') { $prefix = @('-3') }
    try {
        $probe = 'import sys,tkinter; assert sys.version_info >= (3,10); print(sys.executable)'
        $result = & $command.Source @prefix -c $probe 2>$null
        if ($LASTEXITCODE -eq 0 -and $result) { return [string]($result | Select-Object -Last 1) }
    } catch { return $null }
    return $null
}

$resolvedPython = $null
$candidates = @()
if ($PythonExecutable) { $candidates += $PythonExecutable }
if ($env:PREPROCESS_PYTHON) { $candidates += $env:PREPROCESS_PYTHON }
$candidates += @('python', 'python3', 'py')
foreach ($candidate in $candidates) {
    $resolvedPython = Find-Interpreter $candidate
    if ($resolvedPython) { break }
}
if (-not $resolvedPython -and -not $CheckOnly) {
    Add-Type -AssemblyName System.Windows.Forms
    $answer = [System.Windows.Forms.MessageBox]::Show('需要Python 3.10以上及Tkinter。若已经安装，请点击“是”选择python.exe；尚未安装请点击“否”阅读详细说明。', '选择Python环境', 'YesNo')
    if ($answer -eq 'Yes') {
        $picker = New-Object System.Windows.Forms.OpenFileDialog
        $picker.Title = '选择已安装的Python解释器 python.exe'
        $picker.Filter = 'Python executable (*.exe)|*.exe'
        if ($picker.ShowDialog() -eq 'OK') { $resolvedPython = Find-Interpreter $picker.FileName }
    } else {
        Start-Process (Join-Path $projectRoot '说明文档/使用说明.md')
        exit 1
    }
}
if (-not $resolvedPython) { throw '未找到带Tkinter的Python3.10以上解释器。请按详细说明安装，或显式指定解释器。' }
if ($CheckOnly) {
    [pscustomobject]@{ status='LAUNCHER_CHECK_PASSED'; python=$resolvedPython; gui=$guiFile } | ConvertTo-Json
    exit 0
}
$pythonw = Join-Path (Split-Path -Parent $resolvedPython) 'pythonw.exe'
if (-not (Test-Path -LiteralPath $pythonw)) { $pythonw = $resolvedPython }
# This is the explicitly requested interactive desktop window; pythonw avoids a console window.
Start-Process -FilePath $pythonw -ArgumentList @('-X', 'utf8', ('"'+$guiFile+'"')) -WorkingDirectory $projectRoot -WindowStyle Normal | Out-Null
exit 0
