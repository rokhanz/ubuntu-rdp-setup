# 🚀 Ubuntu RDP Setup Guide (XFCE Desktop + Chrome + Conky)

A complete guide to create a **Remote Desktop Environment (RDP)** on an Ubuntu VPS (22.04), with GUI (XFCE), Chrome browser, file manager, and lightweight system monitor using Conky.

---

![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
![Ubuntu](https://img.shields.io/badge/Ubuntu-22.04-orange?logo=ubuntu)
![RDP](https://img.shields.io/badge/RDP-Enabled-brightgreen)
![XFCE](https://img.shields.io/badge/Desktop-XFCE-blue)

---

## 📦 Features

- XFCE Desktop environment
- Remote access via RDP (xRDP)
- Google Chrome installed
- Conky system monitor (auto-start)
- File Manager & Terminal GUI
- Parole video player
- Screenshot tools
- RDP works like a real desktop system

---

## 🧰 Requirements

- VPS (DigitalOcean, Vultr, etc.) with Ubuntu 22.04
- 2 vCPU+, 2 GB RAM minimum recommended
- RDP client (Remote Desktop Connection on Windows)

---

## 🧱 Installation Steps

### 🔄 Quick Setup via Git Clone

If you're familiar with Git, you can clone and run setup script directly:

```bash
git clone https://github.com/rokhanz/ubuntu-rdp-setup.git
cd ubuntu-rdp-setup
chmod +x setup.sh
./setup.sh
```

---

### 1. Update and Install XFCE + xRDP

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y xfce4 xfce4-goodies xorg dbus-x11 x11-xserver-utils xrdp
```

### 2. Add RDP User and Set Password

```bash
sudo adduser rdpuser
sudo usermod -aG sudo rdpuser
```

> Replace `rdpuser` with your desired username.

### 3. Set XFCE Session for xRDP

```bash
echo "xfce4-session" > ~/.xsession
sudo systemctl restart xrdp
```

### 4. Install Chrome Browser

```bash
wget -O ~/chrome.deb "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
sudo apt install -y ./chrome.deb
```

### 5. Add Desktop Shortcuts (Chrome, Terminal, Parole)

```bash
cp /usr/share/applications/google-chrome.desktop ~/Desktop/
cp /usr/share/applications/xfce4-terminal.desktop ~/Desktop/
cp /usr/share/applications/parole.desktop ~/Desktop/
chmod +x ~/Desktop/*.desktop
```

---

## 📊 Install Conky (System Info)

### 6. Install Conky

```bash
sudo apt install conky-all -y
```

### 7. Create Config File

```bash
nano ~/.conkyrc
```

Paste:

```lua
conky.config = {
    alignment = 'top_right',
    background = true,
    update_interval = 2.0,
    double_buffer = true,
    no_buffers = true,
    own_window = true,
    own_window_type = 'desktop',
    own_window_argb_visual = true,
    own_window_argb_value = 150,
    gap_x = 20,
    gap_y = 50,
    minimum_width = 200,
    default_color = 'white',
    font = 'sans 10'
};

conky.text = [[
ROKHANZ VPS STATUS

RAM     : $mem / $memmax
CPU     : ${cpu cpu0}% @ ${freq_g} MHz
DISK    : ${fs_used /} / ${fs_size /}
UPTIME  : $uptime
OS      : ${exec lsb_release -d | cut -f2}
]];
```

### 8. Autostart Conky on Login

```bash
mkdir -p ~/.config/autostart
nano ~/.config/autostart/conky.desktop
```

Paste:

```ini
[Desktop Entry]
Type=Application
Exec=conky
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Conky System Monitor
Comment=Start conky on login
```

---

## 📸 Install Screenshot Tools

### 9. Install Flameshot and XFCE Screenshooter

```bash
sudo apt install -y flameshot xfce4-screenshooter
```

Shortcut-nya bisa ditambahkan ke Desktop seperti langkah sebelumnya.

---

## 🖼️ Install Optional GUI Tools

### 10. Install Image Viewer & Gnome Software Center

```bash
sudo apt install -y ristretto gnome-software
```

> Setelah install `gnome-software`, jalankan: `gnome-software &` dari terminal GUI untuk membuka App Store

---

## 🔐 Tentang Autentikasi "Default Keyring"

Jika muncul pop-up "Enter password for default keyring", masukkan **password yang sama dengan akun RDP kamu (rdpuser)**. Ini hanya muncul satu kali saat awal Chrome atau aplikasi GUI butuh penyimpanan rahasia (seperti login MetaMask, dll).

---

## ✅ Final Check

1. Reboot the VPS: `sudo reboot`
2. Connect via RDP using your VPS IP, username: `rdpuser`, password: yourpassword
3. Anda akan melihat desktop lengkap dengan Chrome, terminal, video player, screenshot tools, dan Conky system info

---

## 🙌 Support Me

**Saweria**: [https://saweria.co/rokhanz](https://saweria.co/rokhanz)\
**Binance ID**: `114501136`\
**OKX UID**: `647414010530652202`\
**ETH Wallet**: `0x6c850ac516a7dcffa51e573bcf0736b72621b3e4`

---

> 💬 *“Teknologi bukan soal alatnya, tapi soal bagaimana kita membuatnya memberdayakan kita.”*  
> — ROKHANZ
