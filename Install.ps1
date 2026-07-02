$installDir = Join-Path $env:USERPROFILE "Togglehidden"

Write-Host "Menghentikan listener lama jika ada..."
Get-WmiObject Win32_Process | Where-Object { $_.CommandLine -match "Listener.ps1" } | ForEach-Object { 
    Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue 
}

if (-not (Test-Path -Path $installDir)) {
    New-Item -ItemType Directory -Path $installDir | Out-Null
}

Write-Host "Menyalin file instalasi..."
$sourceDir = $PSScriptRoot
Copy-Item -Path (Join-Path $sourceDir "ToggleHidden.ps1") -Destination $installDir -Force
Copy-Item -Path (Join-Path $sourceDir "Listener.ps1") -Destination $installDir -Force
Copy-Item -Path (Join-Path $sourceDir "StartListener.vbs") -Destination $installDir -Force

# Hapus shortcut lama di Desktop jika ada
$desktopPath = [Environment]::GetFolderPath('Desktop')
$desktopShortcut = Join-Path $desktopPath "Toggle Hidden Files.lnk"
if (Test-Path $desktopShortcut) { Remove-Item $desktopShortcut -Force }

Write-Host "Memasang Listener ke Startup Windows (Otomatis menyala)..."
$startupPath = [Environment]::GetFolderPath('Startup')
$startupShortcut = Join-Path $startupPath "ToggleHiddenListener.lnk"

$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($startupShortcut)
$Shortcut.TargetPath = "wscript.exe"
$Shortcut.Arguments = "`"$installDir\StartListener.vbs`""
$Shortcut.WindowStyle = 7
$Shortcut.Save()

Write-Host "Menjalankan Listener sekarang..."
Start-Process -FilePath "wscript.exe" -ArgumentList "`"$installDir\StartListener.vbs`""

Write-Host ""
Write-Host "Instalasi selesai sukses!"
Write-Host "Fitur Hide/Unhide sekarang akan selalu aktif di latar belakang."
Write-Host "Cukup tekan Ctrl + H (tanpa Alt) kapan saja untuk mencobanya."
