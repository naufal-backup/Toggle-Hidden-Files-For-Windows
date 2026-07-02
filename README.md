# Toggle Hidden Files (Listener Version)

Proyek ini menghadirkan fitur **saklar (toggle) instan** untuk menampilkan atau menyembunyikan file tersembunyi (Hidden Files/Folders) di Windows, tanpa menggunakan *shortcut file* (.lnk) di Desktop sama sekali!

Metode ini bekerja layaknya aplikasi profesional (seperti Tabby, Discord, dll):
- Menjalankan program "Pendengar" (Listener) super ringan di latar belakang.
- Bebas dari layar Command Prompt / PowerShell yang mengganggu.
- Aktif secara otomatis setiap kali komputer dinyalakan (via Folder Startup *On Logon*).
- Otomatis me-refresh semua jendela Explorer tanpa menekan F5.

## Cara Instalasi

1. Unduh atau *clone* repository ini.
2. Klik kanan pada file **`Install.ps1`**, lalu pilih **"Run with PowerShell"**.
   - Script akan menyalin file instalasi ke `C:\Users\{NamaUserAnda}\Togglehidden`.
   - Script akan membuat jadwal Folder Startup bernama `ToggleHiddenListener` yang akan langsung hidup saat itu juga dan otomatis menyala setiap komputer di-restart.
3. Selesai! Tidak ada shortcut yang berantakan di Desktop.

Mulai sekarang, Anda hanya perlu menekan **`Ctrl + H`** (ya, murni Ctrl + H tanpa Alt) di mana saja untuk mengaktifkan fungsi Hide/Unhide secara instan!

## Cara Uninstall

1. Klik kanan pada file **`Uninstall.ps1`**, lalu pilih **"Run with PowerShell"**.
2. Listener di latar belakang akan dimatikan.
3. Folder Startup akan dicabut.
4. Folder instalasi akan dibersihkan seluruhnya.

## Penjelasan Teknis
- **ToggleHidden.ps1:** Script PowerShell utama yang memodifikasi nilai `Hidden` di Registry dan memaksa File Explorer untuk melakukan refresh.
- **Listener.ps1:** Script Windows Forms (tersembunyi) yang membajak sistem Windows API `RegisterHotKey` untuk mendeteksi penekanan tombol `Ctrl + H` secara global.
- **StartListener.vbs:** Script VBS yang dipanggil oleh Folder Startup untuk memastikan `Listener.ps1` terbuka 100% tanpa wujud (silently).
