$path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
$current = (Get-ItemProperty -Path $path -Name Hidden).Hidden
if ($current -eq 1) {
    Set-ItemProperty -Path $path -Name Hidden -Value 2
} else {
    Set-ItemProperty -Path $path -Name Hidden -Value 1
}

# Method 1: Broadcast change to all Windows
$signature = @'
[DllImport("shell32.dll")]
public static extern void SHChangeNotify(uint wEventId, uint uFlags, IntPtr dwItem1, IntPtr dwItem2);
'@
try {
    $type = Add-Type -MemberDefinition $signature -Name "Win32SHChangeNotify" -Namespace Win32Functions -PassThru
    $type::SHChangeNotify(0x08000000, 0x0000, [IntPtr]::Zero, [IntPtr]::Zero)
} catch {}

# Method 2: Directly refresh all open Explorer windows and Desktop
try {
    $app = New-Object -ComObject Shell.Application
    foreach ($window in $app.Windows()) {
        if ($window.Name -match "File Explorer|Windows Explorer") {
            $window.Refresh()
        }
    }
    # Refresh Desktop
    $app.NameSpace(0).Items() | Out-Null
} catch {}
