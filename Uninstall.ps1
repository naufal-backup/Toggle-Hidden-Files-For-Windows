$installDir = Join-Path $env:USERPROFILE "Togglehidden"

Write-Host "Menghentikan Listener..."
Get-WmiObject Win32_Process | Where-Object { $_.CommandLine -match "Listener.ps1" } | ForEach-Object { 
    Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue 
}

Write-Host "Menghapus Startup Shortcut..."
$startupPath = [Environment]::GetFolderPath('Startup')
$startupShortcut = Join-Path $startupPath "ToggleHiddenListener.lnk"
if (Test-Path -Path $startupShortcut) {
    Remove-Item -Path $startupShortcut -Force
}

# Remove directory
if (Test-Path -Path $installDir) {
    Remove-Item -Path $installDir -Recurse -Force
    Write-Host "Menghapus folder $installDir..."
}

Write-Host ""
Write-Host "Uninstall selesai! Semua file terkait dan background process telah dihapus."
