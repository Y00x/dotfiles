#!/bin/bash
# inspired by https://github.com/kevin-mizu/dotfiles/

#color
END='\033[0m'       # Text Reset
RED='\033[0;31m'          # Red
GREEN='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
BLUE='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple

redecho(){
    echo -e "${RED} $@ ${END}"
}
blueecho(){
    echo -e "${BLUE} $@ ${END}"
}
greencho(){
    echo -e "${GREEN} $@ ${END}"
}

blueecho ""
blueecho "--------------------------------------------------"
blueecho "              - Ubuntu Installer -             "
blueecho "-------------------By Yo0x------------------------"
blueecho ""


blueecho ""
blueecho "--------------------------------------------------"
blueecho "              - Installation checks -             "
blueecho "--------------------------------------------------"
blueecho ""

# must be root
if [ "$EUID" -ne 0 ]
    then echo -e "${RED}[-]${END} This script must be run as root!"
    exit
fi

# home user
USER=yo0x


blueecho ""
blueecho "--------------------------------------------------"
blueecho "            - Auto configure script -             "
blueecho "   This script need to run with root privileges.  "
blueecho "Please use this with a Ubuntu/Debian based distro."
blueecho "--------------------------------------------------"
blueecho ""

blueecho ""
blueecho "--------------------------------------------------"
blueecho "        - This script is made for gnome  -        "
blueecho "           - TODO: install.sh for i3 -            "
blueecho "--------------------------------------------------"
blueecho ""

blueecho ""
blueecho "--------------------------------------------------"
blueecho "            - Installing dependencies -           "
blueecho "--------------------------------------------------"
blueecho ""

dependecy(){
    # update & upgrade
    apt update && apt upgrade -y

    echo -e "${GREEN}[+]${END} up-to-date system"

    # install dependencies
    apt install -y build-essential feh  xclip dconf-cli uuid-runtime curl gnome-tweaks \
    ffmpeg imagemagick libncurses5-dev git make pkg-config vim lxappearance \
    xinput ncdu notepadqq libnotify-bin playerctl neofetch  postgresql postgresql-contrib \
    bat apt-transport-https curl vlc terminator htop numlockx pulseaudio \
    gcc-multilib fuse libfuse2 gem ruby-rubygems php nodejs snapd  cmake meson libzip-dev zlib1g-dev libqt5svg5-dev qttools5-dev qttools5-dev-tools \
    libkf5syntaxhighlighting-dev libgraphviz-dev libshiboken2-dev libpyside2-dev  qtdeclarative5-dev \
    libzip-dev zlib1g-dev qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools libqt5svg5-dev qttools5-dev qttools5-dev-tools \
    libkf5syntaxhighlighting-dev libgraphviz-dev libshiboken2-dev libpyside2-dev  qtdeclarative5-dev 


    # python
    apt install -y python2 python3 python3-pip python-is-python3
    wget https://bootstrap.pypa.io/pip/2.7/get-pip.py -O /tmp/get-pip.py && python2.7 /tmp/get-pip.py

    #discord
    sudo snap install discord

    # docker
    mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    apt update && apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
    groupadd docker && usermod -aG docker ${USER}
    systemctl enable docker
    systemctl start docker


    echo -e "${GREEN}[+]${END} dependecy installed"
}

dependency

blueecho ""
blueecho "--------------------------------------------------"
blueecho "              - Cyber Basic Tools -               "
blueecho "--------------------------------------------------"
blueecho ""

cybertools(){

    blueecho " -- pwn & reverse -- "

    apt install -y gdb ltrace checksec
    bash -c "$(curl -fsSL https://gef.blah.cat/sh)"
    gem install one_gadget
    sudo -H python3 -m pip install ROPgadget
    python3 -m pip install pwntools
    cd /tmp && git clone https://github.com/radareorg/radare2
    /tmp/radare2/sys/install.sh
    #wget -k https://github.com/rizinorg/cutter/releases/download/v2.1.2/Cutter-v2.1.2-Linux-x86_64.AppImage -O /bin/cutter_re
    #chmod +x /bin/cutter_re
    # add cutter to launcher gnome https://codebysamgan.com/how-to-add-appimage-application-to-menu-in-ubuntu-linux
    #IDA
    wget -k https://out7.hex-rays.com/files/idafree82_linux.run -O /tmp/idafree.run
    chmod +x /tmp/idafree && /tmp/idafree.run
    
    blueecho " -- Radio & network --"

    sudo snap install urh
    sudo apt install -y gqrx-sdr inspectrum gnuradio audacity
    sudo apt install -y wireshark tshark remmina

    blueecho " -- Stegano --"

    apt install -y exiftool binwalk foremost

    blueecho " -- Web -- "

    sudo snap install postman --edge
    sudo apt install -y ffuf gobuster   

    blueecho " -- Pentest -- " 

    sudo usermod -aG docker $(id -u -n)
    python3 -m pip install exegol
    curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > /tmp/msfinstall
    chmod 755 /tmp/msfinstall
    sudo /tmp/msfinstall
    sudo systemctl start postgresql
    msfdb init
    

    blueecho " -- Programming --"
    sudo snap install --classic code

    blueecho " -- Misc --"
    sudo apt install -y keepassxc

}

cybertools

blueecho ""
blueecho "--------------------------------------------------"
blueecho "         - Installing dotfiles & themes-          "
blueecho "--------------------------------------------------"
blueecho ""

dotfilesnthemes(){
    #transparency dock
    gsettings set org.gnome.shell.extensions.dash-to-dock transparency-mode 'FIXED'
    gsettings set org.gnome.shell.extensions.dash-to-dock background-opacity 0


    #shell and app thme
    sudo apt install -y zsh zsh-syntax-highlighting zsh-autosuggestions
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
    git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
    git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git $ZSH_CUSTOM/plugins/zsh-autocomplete
    chsh -s /bin/zsh

    git clone https://github.com/linuxopsys/ubuntu-to-kali-terminal.git /tmp/ubuntu-to-kali-terminal
    cd /tmp/ubuntu-to-kali-terminal
    tar -xvf color-schemes.tar
    tar -xvf kali-dark-theme.tar
    sudo mv -f usr/share/themes/Kali-Dark /usr/share/themes 
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/linuxopsys/ubuntu-to-kali-terminal/main/gnome-themes/Kali-Dark.sh)"

    git clone https://github.com/Y00x/dotfiles.git /tmp/dotfiles
    cd /tmp/dotfiles

    chown 1000:1000 -R config/
    cat  config/.zshrc >> ~/.zshrc
    cat config/terminator/config >> ~/config/terminator/config

}

#smbclient, 

#exegol, nmap, wireshark, ffuf, postman,vscode, metasploit
#cd /tmp && git clone https://github.com/radareorg/radare2
#/tmp/radare2/sys/install.sh

#dotfiles, themes omz + transparancy dock
#keepass: sudo apt install keepassxc
#conclusion tools installé + install themes tuto

#rm /etc/apt/sources.list.d/metasploit-framework.list 