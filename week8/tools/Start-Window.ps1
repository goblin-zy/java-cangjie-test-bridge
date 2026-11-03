# 仅查找本机Python并打开窗口，不安装软件、不改全局设置、不处理工程。
Add-Type -AssemblyName System.Windows.Forms
$entry = Join-Path $PSScriptRoot 'preprocess_gui.pyw'
$candidate = Get-Command pythonw.exe -ErrorAction SilentlyContinue
if ($candidate) { & $candidate.Source $entry; exit }
$candidate = Get-Command python.exe -ErrorAction SilentlyContinue
if ($candidate -and $candidate.Source -notlike '*WindowsApps*') { & $candidate.Source $entry; exit }
$candidate = Get-Command py.exe -ErrorAction SilentlyContinue
if ($candidate) { & $candidate.Source -3 $entry; exit }
$localRuntime = Join-Path $env:USERPROFILE '.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe'
if (Test-Path -LiteralPath $localRuntime) { & $localRuntime $entry; exit }
[System.Windows.Forms.MessageBox]::Show('未找到Python。请安装带Tkinter的Python 3.10以上版本后重试；本工具不会自动安装。','无法启动') | Out-Null
