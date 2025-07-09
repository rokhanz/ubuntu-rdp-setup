#!/bin/bash
# Ubuntu RDP Setup Script (XFCE + Chrome + Conky)
# Author: ROKHANZ - https://github.com/rokhanz

set -e

# === Update & Upgrade ===
echo "[+] Updating system packages..."
sudo apt update && sudo apt upgrade -y

# === Install XFCE and xRDP ===
echo "[+] Installing XFCE and xRDP..."
sudo apt install -y xfce4 xfce4-goodies xorg dbus-x11 x11-xserver-utils xrdp

# === Add user ===
echo "[+] Creating new user: rdpuser"
sudo adduser --gecos "" rdpuser
sudo usermod -aG sudo rdpuser

# === Set XFCE as default session ===
echo "[+] Configuring XFCE session for xRDP..."
echo "xfce4-session" | sudo tee /home/rdpuser/.xsession
sudo chown rdpuser:rdpuser /home/rdpuser/.xsession
sudo systemctl restart xrdp

# === Install Chrome ===
echo "[+] Installing Google Chrome..."
wget -O /tmp/chrome.deb "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
sudo apt install -y /tmp/chrome.deb

# === Add Desktop Shortcuts ===
echo "[+] Adding shortcuts to Desktop..."
sudo -u rdpuser mkdir -p /home/rdpuser/Desktop
sudo cp /usr/share/applications/google-chrome.desktop /home/rdpuser/Desktop/
sudo cp /usr/share/applications/xfce4-terminal.desktop /home/rdpuser/Desktop/
sudo cp /usr/share/applications/parole.desktop /home/rdpuser/Desktop/ || echo "[!] Parole shortcut not found."
sudo chmod +x /home/rdpuser/Desktop/*.desktop
sudo chown -R rdpuser:rdpuser /home/rdpuser/Desktop

# === Install Conky ===
echo "[+] Installing Conky..."
sudo apt install -y conky-all

# === Create Conky Config ===
echo "[+] Creating Conky config..."
cat <<EOF | sudo tee /home/rdpuser/.conkyrc
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

RAM     : \$mem / \$memmax
CPU     : \${cpu cpu0}% @ \${freq_g} MHz
DISK    : \${fs_used /} / \${fs_size /}
UPTIME  : \$uptime
OS      : \${exec lsb_release -d | cut -f2}
]];
EOF
sudo chown rdpuser:rdpuser /home/rdpuser/.conkyrc

# === Autostart Conky ===
echo "[+] Configuring autostart for Conky..."
sudo -u rdpuser mkdir -p /home/rdpuser/.config/autostart
cat <<EOF | sudo tee /home/rdpuser/.config/autostart/conky.desktop
[Desktop Entry]
Type=Application
Exec=conky
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Conky System Monitor
Comment=Start conky on login
EOF
sudo chown -R rdpuser:rdpuser /home/rdpuser/.config

# === Install Screenshot Tools ===
echo "[+] Installing screenshot tools..."
sudo apt install -y flameshot xfce4-screenshooter

# === Install Optional GUI Tools ===
echo "[+] Installing Ristretto image viewer and GNOME Software..."
sudo apt install -y ristretto gnome-software

# === Install user xrdp to group ssl-cert ===
echo "[+] user xrdp to groups ssl-cert"
sudo adduser xrdp ssl-cert

# === Finish ===
echo -e "\n✅ Setup complete! You can now connect via RDP using the username: rdpuser"
echo "📌 Tip: After first login, if 'Default Keyring' prompts for password, use the same password as your user."
echo "🔁 Reboot your VPS before connecting: sudo reboot"
