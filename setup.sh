#!/bin/bash

# Ubuntu RDP Setup Script (XFCE + Chrome + Conky + Wallpaper + AutoLock + Splash + Secure User Input + Uninstall)
# Author: ROKHANZ - https://github.com/rokhanz

set -e
trap 'echo -e "\n🚨 Terjadi error! Setup dihentikan."; exit 1' ERR

# === [ Mode UNINSTALL ] ===

if [[ "$1" == "--remove" ]]; then
    echo "🗑️ Menghapus XRDP GUI setup..."
    read -p "Masukkan username yang ingin dihapus: " XRDP_USER
    sudo systemctl stop xrdp || true
    sudo deluser --remove-home "$XRDP_USER" || true
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
read -p "   ➤ Username: " XRDP_USER

if [[ -z "$XRDP_USER" ]]; then
    echo "❌ Username tidak boleh kosong."
    exit 1
fi

if [[ "$XRDP_USER" == "root" ]]; then
    echo "❌ Tidak boleh menggunakan username 'root'."
    exit 1
fi

echo "🔒 Tambahkan password untuk $XRDP_USER (minimal 6 karakter):"
read -s XRDP_PASS
echo
read -s -p "🔁 Ulangi password: " XRDP_PASS_CONFIRM
echo

if [[ ${#XRDP_PASS} -lt 6 ]]; then
    echo "❌ Password terlalu pendek. Minimal 6 karakter."
    exit 1
fi

if [[ "$XRDP_PASS" != "$XRDP_PASS_CONFIRM" ]]; then
    echo "❌ Password tidak cocok."
    exit 1
fi

sudo adduser --disabled-password --gecos "" "$XRDP_USER"
echo "$XRDP_USER:$XRDP_PASS" | sudo chpasswd
sudo usermod -aG sudo "$XRDP_USER"

# === 4. Set Splash + XFCE Session ===
echo "🚀 Setting splash screen and XFCE session..."
cat <<EOF | sudo tee /home/$XRDP_USER/.xsession > /dev/null
#!/bin/bash
zenity --info \
--title="SELAMAT DATANG DI XRDP" \
--width=400 \
--height=220 \
--text="Fitur ini masih dalam tahap pengembangan.\nJika ada permintaan fitur atau error lainnya,\nsilakan hubungi kontak yang tertera di README." \
--timeout=7

(
echo "10"
sleep 1
echo "30"
sleep 1
echo "70"
sleep 1
echo "100"
) | zenity --progress \
--title="Menyiapkan Lingkungan Desktop" \
--text="Harap tunggu..." \
--percentage=0 \
--width=300 \
--auto-close

exec startxfce4
EOF

sudo chmod +x /home/$XRDP_USER/.xsession
sudo chown $XRDP_USER:$XRDP_USER /home/$XRDP_USER/.xsession

# === 5. Enable Auto Login ===
echo "🔓 Enabling auto login for $XRDP_USER..."
sudo mkdir -p /etc/lightdm/lightdm.conf.d
cat <<EOF | sudo tee /etc/lightdm/lightdm.conf.d/50-autologin.conf
[Seat:*]
autologin-user=$XRDP_USER
autologin-user-timeout=0
user-session=xfce
greeter-session=lightdm-gtk-greeter
EOF

# === 6. Install Google Chrome ===
echo "🌐 Installing Google Chrome..."
wget -O /tmp/chrome.deb "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
sudo apt install -y /tmp/chrome.deb

# === 7. Add Desktop Shortcuts ===
echo "📁 Adding shortcuts to Desktop..."
sudo -u $XRDP_USER mkdir -p /home/$XRDP_USER/Desktop
sudo cp /usr/share/applications/google-chrome.desktop /home/$XRDP_USER/Desktop/
sudo cp /usr/share/applications/xfce4-terminal.desktop /home/$XRDP_USER/Desktop/
sudo cp /usr/share/applications/parole.desktop /home/$XRDP_USER/Desktop/ || echo "[!] Parole shortcut not found."
sudo chmod +x /home/$XRDP_USER/Desktop/*.desktop
sudo chown -R $XRDP_USER:$XRDP_USER /home/$XRDP_USER/Desktop

# === 8. Install Conky ===
echo "📊 Installing Conky..."
sudo apt install -y conky-all

# === 9. Create Conky Config ===
echo "⚙️ Creating Conky config..."
cat <<EOF | sudo tee /home/$XRDP_USER/.conkyrc > /dev/null
conky.config = {
alignment = 'top_right',
background = true,
update_interval = 2.0,
double_buffer = true,
no_buffers = true,
own_window = true,
own_window_type = 'normal',
own_window_hints = 'undecorated,below,sticky,skip_taskbar,skip_pager',
own_window_argb_visual = true,
own_window_argb_value = 0,
gap_x = 20,
gap_y = 50,
minimum_width = 200,
default_color = 'white',
font = 'sans 10'
};

conky.text = [[
ROKHANZ XRDP STATUS

RAM     : $mem / $memmax
CPU     : ${cpu cpu0}% @ ${freq_g} MHz
DISK    : ${fs_used /} / ${fs_size /}
UPTIME  : $uptime
OS      : ${exec lsb_release -d | cut -f2}
]];
EOF

sudo chown $XRDP_USER:$XRDP_USER /home/$XRDP_USER/.conkyrc

# === 10. Autostart Conky (delay 5s) ===
echo "⚡ Setting Conky autostart (delay 5s)..."
sudo -u $XRDP_USER mkdir -p /home/$XRDP_USER/.config/autostart
cat <<EOF | sudo tee /home/$XRDP_USER/.config/autostart/conky.desktop > /dev/null
[Desktop Entry]
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
sudo -u $XRDP_USER mkdir -p /home/$XRDP_USER/Pictures
sudo -u $XRDP_USER wget -qO /home/$XRDP_USER/Pictures/wallpaper.png "https://raw.githubusercontent.com/rokhanz/myimg/main/assets/image/chips_rokhanz.png"
sudo -u $XRDP_USER xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/image-path -s /home/$XRDP_USER/Pictures/wallpaper.png
sudo -u $XRDP_USER xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/image-style -s 3

# === 12. Auto-Lock After 1 Hour ===
echo "🔐 Setting auto-lock after 1 hour idle..."
sudo apt install -y xscreensaver
cat <<EOF | sudo tee /home/$XRDP_USER/.xscreensaver > /dev/null
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

cat <<EOF | sudo tee /home/$XRDP_USER/.config/autostart/xscreensaver.desktop > /dev/null
[Desktop Entry]
Type=Application
Exec=sh -c "sleep 10 && xscreensaver -no-splash"
Hidden=false
X-GNOME-Autostart-enabled=true
Name=Screen Locker
Comment=Auto-lock after 1 hour idle
EOF
sudo chown -R $XRDP_USER:$XRDP_USER /home/$XRDP_USER/.xscreensaver /home/$XRDP_USER/.config/autostart

# === 13. Prevent Screen Blank (System Level) ===
echo "💡 Disabling DPMS and screen blanking..."
echo "xset s off && xset -dpms && xset s noblank" | sudo tee -a /home/$XRDP_USER/.xprofile
sudo chown $XRDP_USER:$XRDP_USER /home/$XRDP_USER/.xprofile

# === 14. Install Screenshot & GUI Tools ===
echo "🖼️ Installing screenshot and GUI tools..."
sudo apt install -y flameshot xfce4-screenshooter ristretto gnome-software

# === 15. Add xrdp to ssl-cert Group ===
echo "🔒 Adding user xrdp to ssl-cert group..."
sudo adduser xrdp ssl-cert

# === 16. Final ===
echo -e "\n✅ Setup complete! Silakan reboot VPS sebelum login pertama via RDP:"
echo "   👉 Username: $XRDP_USER"
echo "   🔁 Perintah reboot: sudo reboot"
