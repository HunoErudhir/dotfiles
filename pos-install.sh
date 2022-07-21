#!/bin/bash

echo "Iniciando Pós-Instalação"

# Instalando paru
echo "Instalando paru"
sudo pacman -Syu git base-devel cmake --needed --noconfirm
git clone https://aur.archlinux.org/paru-bin.git
cd paru-bin/ && makepkg -si

# Atualizando todo sistema
echo "ATUALIZANDO"
sudo sed -i '17 s/^#//' /etc/paru.conf
sudo sed -i '33 s/^#//' /etc/pacman.conf 
paru --noconfirm

# Instalando pacotes
echo "Instalando pacotes comuns"
paru -S --noconfirm --needed steam alsa-utils winetricks wine-gecko wine-mono wine-staging firefox vlc keepassxc qbittorrent p7zip unzip unrar flameshot htop libreoffice neofetch feh nvim ranger thunar leafpad wget xdg-user-dirs

# ----------------WM-------------------- #
# Instalando awesome-wm e fontes
echo "Instalando windown manager"
paru -S awesome dmenu xf86-video-ati mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon amdvlk --needed --noconfirm

echo "INSTALANDO FONTES"
sudo pacman -S $(pacman -Ssq noto-fonts) --noconfirm

# Criando diretórios
echo "Criando diretórios"
xdg-user-dirs-update

# Configurando awesome
echo "CONFIGURANDO..."
rm -rf ~/.config/awesome/
cp ~/dotfiles/awesome/ ~/.config/

# Configurando nvim
rm -rf ~/.config/nvim/init.vim
cp ~/dotfiles/nvim/init.vim ~/.config/nvim/
# --------------TERMINAL----------------- #
git clone git://git.suckless.org/st
cd st
cp config.def.h config.h
sudo sed -i '8 s/12/14' config.h
sudo make clean install
# ------ JOGOS ------ #
# BetterSpades
echo "BetterSpades"
cd
paru -S --noconfirm glfw-x11 glew openal libdeflate enet
git clone https://github.com/xtreme8000/BetterSpades
cd BetterSpades
sudo sed -i '6 s/0.8.4/0.8.5/' src/CMakeLists.txt
cd build/ && cmake .. && make
mv BetterSpades ~/Desktop/

# ----------------------------- DF ---------------------------- #
cd
echo "Instalando Dwarf Fortress"
# DF de fato
paru -S --noconfirm sdl sdl2_ttf sdl_image glu gtk3 glib2 
wget http://www.bay12games.com/dwarves/df_47_05_linux.tar.bz2
tar -xvf df_47_05_linux.tar.bz2

# DFHack
wget https://github.com/DFHack/dfhack/releases/download/0.47.05-r6/dfhack-0.47.05-r6-Linux-64bit-gcc-7.tar.bz2
tar -xvf dfhack-0.47.05-r6-Linux-64bit-gcc-7.tar.bz2 -C df_linux

# Dwarf-Therapist
wget https://github.com/Dwarf-Therapist/Dwarf-Therapist/releases/download/v41.2.3/DwarfTherapist-v41.2.3-linux-x86_64.AppImage
wget https://raw.githubusercontent.com/Dwarf-Therapist/Dwarf-Therapist/master/dist/ptrace_scope/patch_df_ptracer
chmod a+x patch_df_ptracer
./patch_df_ptracer df_linux/

# TWBT
wget https://github.com/thurin/df-twbt/releases/download/0.47.05-r6/twbt-6.xx-linux64-0.47.05-r6.zip
unzip twbt-6.xx-linux64-0.47.05-r6.zip -d twbt/
cd twbt/
mv 0.47.05-r6/twbt.plug.so ~/df_linux/hack/plugins/
cp transparent1px.png shadows.png white1px.png ~/df_linux/data/art/

# Configurações finais
cd ../df_linux/
cp dfhack.init-example dfhack.init
sudo sed -i '11,19 s/YES/NO/' data/init/init.txt
sudo sed -i '121,150 s/YES/NO/' data/init/init.txt
sudo sed -i '85 s/NO/YES/' data/init/init.txt
sudo sed -i '67 s/2D/TWBT/' data/init/init.txt
sudo sed -i '95 s/50/20/' data/init/init.txt

sudo sed -i '11 s/NONE/SEASONAL/' data/init/d_init.txt
sudo sed -i '13,25 s/NO/YES/' data/init/d_init.txt
sudo sed -i '280 s/NO/YES/' data/init/d_init.txt
sudo sed -i '267 s/YES/NO/' data/init/d_init.txt

cd && mv df_linux/ ~/Desktop/
# --------------------------------------------------------- #
# Limpando ~/
echo "Limpando o ~/"
rm -rvf BetterSpades/ df_47_05_linux.tar.bz2 dfhack-0.47.05-r6-Linux-64bit-gcc-7.tar.bz2 dotfiles paru patch_df_ptracer st/ twbt/ twbt-6.xx-linux64-0.47.05-r6.zip
