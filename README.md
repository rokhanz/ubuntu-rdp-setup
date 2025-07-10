---
# Ubuntu RDP Setup - XFCE + Chrome + Conky + Wallpaper

---

![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
![Ubuntu](https://img.shields.io/badge/Ubuntu-22.04-orange?logo=ubuntu)
![RDP](https://img.shields.io/badge/RDP-Enabled-brightgreen)
![XFCE](https://img.shields.io/badge/Desktop-XFCE-blue)
![Badge](https://img.shields.io/badge/RDP-AutoInstall-blue)
![Badge](https://img.shields.io/badge/Maintainer-rokhanz-green)
![Badge](https://img.shields.io/badge/Desktop-XFCE-lightgrey)

> 📦 **Versi Terbaru:** `v1.4`
> 🕓 **Tanggal Rilis:** `10 Juli 2025`

---

## 🎯 Tujuan

Script ini akan mengubah VPS Ubuntu 22.04 kamu menjadi **desktop GUI via xRDP**, lengkap dengan fitur:

* ✅ Auto-login ke XRDP
* 🎨 Wallpaper branding dari GitHub
* 🖥️ XFCE Desktop Environment
* 🌐 Google Chrome (full GUI browser)
* 📊 Conky System Monitor (menampilkan status RAM, CPU, disk)
* 🔐 Auto-lock session setelah idle 1 jam
* 🪧 Splash screen sebelum masuk desktop

---

## 🧪 Tested On

* ✅ Ubuntu 22.04 (DigitalOcean / Oracle / local VPS)
* ✅ XFCE + xRDP

---

## 🛠️ Cara Install (Langkah Praktis)

### 1. Clone Repository

```bash
git clone https://github.com/rokhanz/ubuntu-rdp-setup.git
cd ubuntu-rdp-setup
```

### 2. Jalankan Script Instalasi

```bash
chmod +x setup.sh
./setup.sh
```

> ⚠️ Kamu akan diminta memasukkan username dan password. Username tidak boleh `root` dan password minimal 6 karakter.

---

## 📸 Tampilan Desktop

---
![contoh gambar](https://github.com/rokhanz/ubuntu-rdp-setup/blob/main/img/contoh%20walpaper%20rokhanz.png)
---

---

## 📂 Struktur Paket yang Terinstall

* `xfce4`, `xrdp`, `x11-xserver-utils` — GUI & RDP
* `conky-all` — sistem monitor
* `zenity` — splash screen GUI
* `google-chrome-stable` — browser
* `flameshot`, `xfce4-screenshooter`, `ristretto`, `gnome-software` — utilitas GUI

---

## 💬 Catatan Tambahan

* File wallpaper diambil dari: `https://github.com/rokhanz/myimg`
* Conky autostart ditunda 5 detik agar tidak tertutup wallpaper
* Splash screen menampilkan ucapan: `SELAMAT DATANG DI XRDP`
* Jika ingin kustomisasi lebih lanjut, edit bagian `.xsession`, `.conkyrc`, dan `.config/autostart/`

---

## 📞 Kontak & Laporan Masalah

Jika kamu menemukan error atau ingin menambahkan fitur:

* Kunjungi: [github.com/rokhanz](https://github.com/rokhanz)
* Atau buka [Issues](https://github.com/rokhanz/ubuntu-rdp-setup/issues)

---

## 🔐 Tentang Autentikasi "Default Keyring"

Jika muncul pop-up "Enter password for default keyring", masukkan **password yang sama dengan akun RDP kamu (rdpuser)**. Ini hanya muncul satu kali saat awal Chrome atau aplikasi GUI butuh penyimpanan rahasia (seperti login MetaMask, dll).

---

## ✅ Final Check

1. Reboot the VPS: `sudo reboot`
2. Connect via RDP using your VPS IP, username: `rdpuser`, password: yourpassword
3. Anda akan melihat desktop lengkap dengan Chrome, terminal, video player, screenshot tools, dan Conky system info

## 🙌 Support Me

**Saweria**: [https://saweria.co/rokhanz](https://saweria.co/rokhanz)\
**Binance ID**: `114501136`\
**OKX UID**: `647414010530652202`\
**ETH Wallet**: `0x6c850ac516a7dcffa51e573bcf0736b72621b3e4`

## 📚 Referensi

- [DigitalOcean: How To Enable Remote Desktop Protocol Using xrdp on Ubuntu 22.04](https://www.digitalocean.com/community/tutorials/how-to-enable-remote-desktop-protocol-using-xrdp-on-ubuntu-22-04)
---
## 📌 Lisensi

Script ini open source. Gunakan dengan bijak dan jangan disalahgunakan.
---

✨ Penutup

Terima kasih sudah mengikuti panduan ini dengan penuh kesabaran dan semangat belajar! 🙏
Jika panduan ini membantu, jangan sungkan untuk memberikan ⭐ bintang di repositori ini, karena dukungan kamu sangat berarti untuk kami terus berbagi ilmu dan memperbaiki panduan ini.

Selamat mencoba, semoga sukses dan lancar selalu dalam menjalankan xrdp di VPS kamu! Jangan ragu bertanya jika ada kendala, kami siap membantu.

Salam hangat dan semangat coding! 💻🌟
