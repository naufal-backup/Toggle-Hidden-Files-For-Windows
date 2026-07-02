Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$code = @"
using System;
using System.Runtime.InteropServices;
using System.Windows.Forms;

public class HotKeyForm : Form {
    [DllImport("user32.dll")]
    public static extern bool RegisterHotKey(IntPtr hWnd, int id, uint fsModifiers, uint vk);
    
    [DllImport("user32.dll")]
    public static extern bool UnregisterHotKey(IntPtr hWnd, int id);

    private int hotKeyId = 1;

    public HotKeyForm() {
        // Register Ctrl+H. 
        // 0x0002 = Ctrl. 0x48 = H key.
        RegisterHotKey(this.Handle, hotKeyId, 0x0002, 0x48);
    }

    protected override void WndProc(ref Message m) {
        if (m.Msg == 0x0312 && m.WParam.ToInt32() == hotKeyId) {
            OnHotKeyPressed();
        }
        base.WndProc(ref m);
    }

    public Action HotKeyPressedAction;

    private void OnHotKeyPressed() {
        if (HotKeyPressedAction != null) {
            HotKeyPressedAction();
        }
    }

    protected override void OnFormClosing(FormClosingEventArgs e) {
        UnregisterHotKey(this.Handle, hotKeyId);
        base.OnFormClosing(e);
    }
    
    protected override void SetVisibleCore(bool value) {
        base.SetVisibleCore(false); // Keeps the form completely hidden
    }
}
"@

Add-Type -TypeDefinition $code -ReferencedAssemblies System.Windows.Forms, System.Drawing

$form = New-Object HotKeyForm
$form.HotKeyPressedAction = {
    # Call the toggle script
    $toggleScript = Join-Path -Path $PSScriptRoot -ChildPath "ToggleHidden.ps1"
    Start-Process -FilePath "powershell.exe" -ArgumentList "-ExecutionPolicy Bypass -WindowStyle Hidden -File ""$toggleScript""" -WindowStyle Hidden
}

[System.Windows.Forms.Application]::Run($form)
