\#!/bin/bash

# Ubuntu RDP Setup Script (XFCE + Chrome + Conky + Wallpaper + AutoLock + Splash + Secure User Input + Uninstall)

# Author: ROKHANZ - [https://github.com/rokhanz](https://github.com/rokhanz)

set -e
trap 'echo "\n🚨 Terjadi error! Setup dihentikan."; exit 1' ERR

# === \[ Mode UNINSTALL ] ===

if \[\[ "\$1" == "--remove" ]]; then
echo "🗑️ Menghapus XRDP GUI setup..."
read -p "Masukkan username yang ingin dihapus: " XRDP\_USER
sudo systemctl stop xrdp || true
sudo deluser --remove-home "\$XRDP\_USER" || true
sudo apt purge -y xfce4 xfce4-goodies xrdp conky-all xscreensaver google-chrome-stable zenity ristretto flameshot xfce4-screenshooter gnome-software || true
sudo apt autoremove -y
echo "✅ Semua komponen berhasil dihapus."
exit 0
fi

# === 1. Update System ===

echo "🔄 Updating system packages..."
sudo apt update && sudo apt upgrade -y

# === 2. Install XFCE & xRDP ===

echo "🖥️ Installing XFCE and xRDP..."
sudo apt install -y xfce4 xfce4-goodies xorg dbus-x11 x11-xserver-utils xrdp zenity

# === 3. Create User (Interactive) ===

echo "👤 Tambahkan user untuk login di XRDP:"
read -p "   ➤ Username: " XRDP\_USER

if \[\[ -z "\$XRDP\_USER" ]]; then
echo "❌ Username tidak boleh kosong."
exit 1
fi

if \[\[ "\$XRDP\_USER" == "root" ]]; then
echo "❌ Tidak boleh menggunakan username 'root'."
exit 1
fi

echo "🔒 Tambahkan password untuk \$XRDP\_USER (minimal 6 karakter):"
read -s XRDP\_PASS
echo
read -s -p "🔁 Ulangi password: " XRDP\_PASS\_CONFIRM
echo

if \[\[ \${#XRDP\_PASS} -lt 6 ]]; then
echo "❌ Password terlalu pendek. Minimal 6 karakter."
exit 1
fi

if \[\[ "\$XRDP\_PASS" != "\$XRDP\_PASS\_CONFIRM" ]]; then
echo "❌ Password tidak cocok."
exit 1
fi

sudo adduser --disabled-password --gecos "" "\$XRDP\_USER"
echo "\$XRDP\_USER:\$XRDP\_PASS" | sudo chpasswd
sudo usermod -aG sudo "\$XRDP\_USER"

# === 4. Set Splash + XFCE Session ===

echo "🚀 Setting splash screen and XFCE session..."
cat <\<EOF | sudo tee /home/\$XRDP\_USER/.xsession > /dev/null
\#!/bin/bash
zenity --info&#x20;
\--title="SELAMAT DATANG DI XRDP"&#x20;
\--width=400&#x20;
\--height=220&#x20;
\--text="Fitur ini masih dalam tahap pengembangan.\nJika ada permintaan fitur atau error lainnya,\nsilakan hubungi kontak yang tertera di README."&#x20;
\--timeout=7
(
echo "10"
sleep 1
echo "30"
sleep 1
echo "70"
sleep 1
echo "100"
) | zenity --progress&#x20;
\--title="Menyiapkan Lingkungan Desktop"&#x20;
\--text="Harap tunggu..."&#x20;
\--percentage=0&#x20;
\--width=300&#x20;
\--auto-close
exec startxfce4
EOF

sudo chmod +x /home/\$XRDP\_USER/.xsession
sudo chown \$XRDP\_USER:\$XRDP\_USER /home/\$XRDP\_USER/.xsession

# === 5. Enable Auto Login ===

echo "🔓 Enabling auto login for \$XRDP\_USER..."
sudo mkdir -p /etc/lightdm/lightdm.conf.d
cat <\<EOF | sudo tee /etc/lightdm/lightdm.conf.d/50-autologin.conf
\[Seat:\*]
autologin-user=\$XRDP\_USER
autologin-user-timeout=0
user-session=xfce
greeter-session=lightdm-gtk-greeter
EOF

# === 6. Install Google Chrome ===

echo "🌐 Installing Google Chrome..."
wget -O /tmp/chrome.deb "[https://dl.google.com/linux/direct/google-chrome-stable\_current\_amd64.deb](https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb)"
sudo apt install -y /tmp/chrome.deb

# === 7. Add Desktop Shortcuts ===

echo "📁 Adding shortcuts to Desktop..."
sudo -u \$XRDP\_USER mkdir -p /home/\$XRDP\_USER/Desktop
sudo cp /usr/share/applications/google-chrome.desktop /home/\$XRDP\_USER/Desktop/
sudo cp /usr/share/applications/xfce4-terminal.desktop /home/\$XRDP\_USER/Desktop/
sudo cp /usr/share/applications/parole.desktop /home/\$XRDP\_USER/Desktop/ || echo "\[!] Parole shortcut not found."
sudo chmod +x /home/\$XRDP\_USER/Desktop/\*.desktop
sudo chown -R \$XRDP\_USER:\$XRDP\_USER /home/\$XRDP\_USER/Desktop

# === 8. Install Conky ===

echo "📊 Installing Conky..."
sudo apt install -y conky-all

# === 9. Create Conky Config ===

echo "⚙️ Creating Conky config..."
cat <\<EOF | sudo tee /home/\$XRDP\_USER/.conkyrc > /dev/null
conky.config = {
alignment = 'top\_right',
background = true,
update\_interval = 2.0,
double\_buffer = true,
no\_buffers = true,
own\_window = true,
own\_window\_type = 'normal',
own\_window\_hints = 'undecorated,below,sticky,skip\_taskbar,skip\_pager',
own\_window\_argb\_visual = true,
own\_window\_argb\_value = 0,
gap\_x = 20,
gap\_y = 50,
minimum\_width = 200,
default\_color = 'white',
font = 'sans 10'
};

conky.text = \[\[
ROKHANZ XRDP STATUS

RAM     : \$mem / \$memmax
CPU     : \${cpu cpu0}% @ \${freq\_g} MHz
DISK    : \${fs\_used /} / \${fs\_size /}
UPTIME  : \$uptime
OS      : \${exec lsb\_release -d | cut -f2}
]];
EOF
sudo chown \$XRDP\_USER:\$XRDP\_USER /home/\$XRDP\_USER/.conkyrc

# === 10. Autostart Conky (delay 5s) ===

echo "⚡ Setting Conky autostart (delay 5s)..."
sudo -u \$XRDP\_USER mkdir -p /home/\$XRDP\_USER/.config/autostart
cat <\<EOF | sudo tee /home/\$XRDP\_USER/.config/autostart/conky.desktop > /dev/null
\[Desktop Entry]
Type=Application
Exec=sh -c "sleep 5 && conky"
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Conky System Monitor
Comment=Start conky after 5s
EOF

# === 11. Set Wallpaper from GitHub ===

echo "🖼️ Setting wallpaper from GitHub..."
sudo -u \$XRDP\_USER mkdir -p /home/\$XRDP\_USER/Pictures
sudo -u \$XRDP\_USER wget -qO /home/\$XRDP\_USER/Pictures/wallpaper.png "[https://raw.githubusercontent.com/rokhanz/myimg/main/assets/image/chips\_rokhanz.png](https://raw.githubusercontent.com/rokhanz/myimg/main/assets/image/chips_rokhanz.png)"
sudo -u \$XRDP\_USER xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/image-path -s /home/\$XRDP\_USER/Pictures/wallpaper.png
sudo -u \$XRDP\_USER xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/image-style -s 3

# === 12. Auto-Lock After 1 Hour ===

echo "🔐 Setting auto-lock after 1 hour idle..."
sudo apt install -y xscreensaver
cat <\<EOF | sudo tee /home/\$XRDP\_USER/.xscreensaver > /dev/null
timeout:        3600
lock:           True
lockTimeout:    0
passwdTimeout:  0
visualID:       default
captureStderr:  True
nice:           10
fade:           False
unfade:         False
fadeSeconds:    0
fadeTicks:      0
EOF
cat <\<EOF | sudo tee /home/\$XRDP\_USER/.config/autostart/xscreensaver.desktop > /dev/null
\[Desktop Entry]
Type=Application
Exec=sh -c "sleep 10 && xscreensaver -no-splash"
Hidden=false
X-GNOME-Autostart-enabled=true
Name=Screen Locker
Comment=Auto-lock after 1 hour idle
EOF
sudo chown -R \$XRDP\_USER:\$XRDP\_USER /home/\$XRDP\_USER/.xscreensaver /home/\$XRDP\_USER/.config/autostart

# === 13. Prevent Screen Blank (System Level) ===

echo "💡 Disabling DPMS and screen blanking..."
echo "xset s off && xset -dpms && xset s noblank" | sudo tee -a /home/\$XRDP\_USER/.xprofile
sudo chown \$XRDP\_USER:\$XRDP\_USER /home/\$XRDP\_USER/.xprofile

# === 14. Install Screenshot & GUI Tools ===

echo "🖼️ Installing screenshot and GUI tools..."
sudo apt install -y flameshot xfce4-screenshooter ristretto gnome-software

# === 15. Add xrdp to ssl-cert Group ===

echo "🔒 Adding user xrdp to ssl-cert group..."
sudo adduser xrdp ssl-cert

# === 16. Final ===

echo -e "\n✅ Setup complete! Silakan reboot VPS sebelum login pertama via RDP:"
echo "   👉 Username: \$XRDP\_USER"
echo "   🔁 Perintah reboot: sudo reboot"
