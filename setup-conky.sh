#!/bin/bash

echo "🔧 Installing Conky..."
sudo apt update
sudo apt install -y conky-all

echo "📝 Creating ~/.conkyrc configuration..."
cat > ~/.conkyrc << 'EOF'
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
ROKHANZ VPS STATUS

RAM     : $mem / $memmax
CPU     : ${cpu cpu0}% @ ${freq_g} MHz
DISK    : ${fs_used /} / ${fs_size /}
UPTIME  : $uptime
OS      : ${exec lsb_release -d | cut -f2}
]];
EOF

echo "🚀 Setting up autostart for Conky..."
mkdir -p ~/.config/autostart
cat > ~/.config/autostart/conky.desktop << 'EOF'
[Desktop Entry]
Type=Application
Exec=sh -c "sleep 5 && conky"
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Conky
EOF

echo "✅ Done! Conky will launch automatically at next login."
echo "🔄 You can test now by running: conky &"
