---
# Ubuntu RDP Setup - XFCE + Chrome + Conky + Wallpaper

---

![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
![Ubuntu](https://img.shields.io/badge/Ubuntu-22.04-orange?logo=ubuntu)
![RDP](https://img.shields.io/badge/RDP-Enabled-brightgreen)
![XFCE](https://img.shields.io/badge/Desktop-XFCE-blue)
![Badge](https://img.shields.io/badge/RDP-AutoInstall-blue)
![Badge](https://img.shields.io/badge/Maintainer-rokhanz-green)
![Badge](https://img.shields.io/badge/RDP-AutoInstall-blue)
![Badge](https://img.shields.io/badge/Maintainer-rokhanz-green)

> 📦 **Versi Terbaru:** `v1.5`
> 🕓 **Tanggal Rilis:** `10 Juli 2025`

---

## 🎯 Tujuan

Script ini akan mengubah VPS Ubuntu 22.04 kamu menjadi **desktop GUI via xRDP**, lengkap dengan fitur:

* ✅ Auto-login ke XRDP (non-root user)
* 🔐 Auto-lock setelah idle 1 jam
* 🖥️ XFCE Desktop Environment
* 🎨 Wallpaper branding otomatis (dari GitHub)
* 🌐 Google Chrome (full GUI browser)
* 📊 Conky System Monitor
* 🪧 Splash screen selamat datang
* 🔁 Mode uninstall (`--remove`)
* 🛑 Error handling jika install gagal

---

## 🧪 Tested On

* ✅ Ubuntu 22.04 (DigitalOcean / Oracle / Local VPS)
* ✅ XFCE + xRDP Desktop via Remote

---

## 🚀 Cara Install

### 1. Clone Repository

```bash
git clone https://github.com/rokhanz/ubuntu-rdp-setup.git
cd ubuntu-rdp-setup
chmod +x setup.sh
./setup.sh
```

> 🛡️ Akan diminta input username & password:
>
> * Username tidak boleh `root`
> * Password minimal 6 karakter

---

## 🔁 Mode Uninstall (Hapus RDP Desktop)

```bash
./setup.sh --remove
```

Fungsi ini akan menghapus:

* User yang kamu buat saat setup
* Paket XFCE, xRDP, Conky, Chrome, dll
* Wallpaper & konfigurasi tambahan

---

## 📸 Tampilan Desktop


---
![contoh gambar](https://github.com/rokhanz/ubuntu-rdp-setup/blob/main/img/contoh%20walpaper%20rokhanz.png)
---
---

## 🧩 Komponen yang Diinstall

* `xfce4`, `xrdp`, `x11-xserver-utils` — GUI & remote
* `google-chrome-stable` — browser
* `conky-all` — monitor status sistem
* `xscreensaver` — auto-lock screen
* `zenity` — splash screen sebelum desktop
* `ristretto`, `flameshot`, `gnome-software` — utilitas GUI

---

## 🔧 Fitur Tambahan

| Fitur             | Keterangan                                   |
| ----------------- | -------------------------------------------- |
| 👤 User login     | Interaktif, non-root, validasi input         |
| 🎨 Wallpaper      | Diunduh otomatis dari GitHub kamu            |
| 🪧 Splash screen  | "SELAMAT DATANG DI XRDP" + info support      |
| 🔐 Auto-lock      | Lock otomatis jika idle 1 jam                |
| ⚠️ Error handling | Jika gagal setup, proses dihentikan otomatis |
| 🗑️ Hapus setup   | Mode `--remove` untuk bersih total           |

---

## 🔐 Tentang Autentikasi "Default Keyring"

Jika muncul pop-up "Enter password for default keyring", masukkan **password yang sama dengan akun RDP kamu (rdpuser)**. Ini hanya muncul satu kali saat awal Chrome atau aplikasi GUI butuh penyimpanan rahasia (seperti login MetaMask, dll).

---

## ✅ Final Check

1. Reboot the VPS: `sudo reboot`
2. Connect via RDP using your VPS IP, username: `rdpuser`, password: yourpassword
3. Anda akan melihat desktop lengkap dengan Chrome, terminal, video player, screenshot tools, dan Conky system info


## 📞 Kontak & Laporan Masalah

Jika kamu menemukan bug atau ingin request fitur:

* 💬 [github.com/rokhanz](https://github.com/rokhanz)
* 📥 [Issues](https://github.com/rokhanz/ubuntu-rdp-setup/issues)

---

## 📌 Lisensi

Script ini open-source. Gunakan dengan bijak.

---


## 🙌 Support Me

**Saweria**: [https://saweria.co/rokhanz](https://saweria.co/rokhanz)\
**Binance ID**: `114501136`\
**OKX UID**: `647414010530652202`\
**ETH Wallet**: `0x6c850ac516a7dcffa51e573bcf0736b72621b3e4`

## 📚 Referensi

- [DigitalOcean: How To Enable Remote Desktop Protocol Using xrdp on Ubuntu 22.04](https://www.digitalocean.com/community/tutorials/how-to-enable-remote-desktop-protocol-using-xrdp-on-ubuntu-22-04)
---
## 📝 Catatan Developer

* Jika wallpaper tidak muncul, jalankan ulang xfce4-desktop config di sesi RDP.
* Untuk mengedit splash atau autostart: lihat `.xsession`, `.xprofile`, dan `~/.config/autostart/`
* Uji kompatibilitas via `Oracle VPS`, `DigitalOcean`, atau VPS lokal lainnya.

---

> 🛠️ Versi ini membawa stabilitas dan opsi aman uninstall. Versi selanjutnya akan menambahkan opsi advanced seperti koneksi SSH, monitoring uptime, dan multiuser switch.
