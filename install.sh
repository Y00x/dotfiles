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

dependency(){
    # update & upgrade
    apt update && apt upgrade -y

    echo -e "${GREEN}[+]${END} up-to-date system"

    # install dependencies
    apt install -y build-essential feh  xclip dconf-cli uuid-runtime curl gnome-tweaks chromium-browser \
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
    cd /tmp && git clone https://github.com/radareorg/radare2
    /tmp/radare2/sys/install.sh
    wget -k https://github.com/rizinorg/cutter/releases/download/v2.1.2/Cutter-v2.1.2-Linux-x86_64.AppImage -O /bin/cutter_re
    chmod +x /bin/cutter_re
    # add cutter to launcher gnome https://codebysamgan.com/how-to-add-appimage-application-to-menu-in-ubuntu-linux
    #IDA
    wget -k https://out7.hex-rays.com/files/idafree82_linux.run -O /tmp/idafree.run
    chmod +x /tmp/idafree.run
    /tmp/idafree.run
    export PATH="/opt/idafree-8.2:$PATH"
    mv /opt/idafree-8.2/ida64 /opt/idafree-8.2/ida
    
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
    sudo apt install -y keepassxc smbclient

}

cybertools

blueecho ""
blueecho "--------------------------------------------------"
blueecho "         - Installing dotfiles & themes-          "
blueecho "--------------------------------------------------"
blueecho ""

dotfilesnthemes(){
   
    #shell and app thme
    #chsh -s /bin/zsh

    git clone https://github.com/linuxopsys/ubuntu-to-kali-terminal.git /tmp/ubuntu-to-kali-terminal
    cd /tmp/ubuntu-to-kali-terminal
    tar -xvf color-schemes.tar && tar -xvf kali-dark-theme.tar
    sudo mv /tmp/ubuntu-to-kali-terminal/usr/share/themes/Kali-Dark /usr/share/themes
    
    #papirus Icon themes
    sudo add-apt-repository ppa:papirus/papirus
    sudo apt install papirus-icon-theme

    git clone https://github.com/Y00x/dotfiles.git /tmp/dotfiles
    cd /tmp/dotfiles

    chown 1000:1000 -R config/
    cat  config/.zshrc > /home/${USER}/.zshrc
    #source /home/${USER}/.zshrc
    mkdir -p /home/${USER}/.config/terminator/
    cat config/terminator/config > /home/${USER}/.config/terminator/config

}

dotfilesnthemes
# misc
blueecho ""
blueecho "--------------------------------------------------"
blueecho "                - Other configs -"
blueecho "--------------------------------------------------"
blueecho ""
#smbclient, 


python -m pip install -r requirements.txt

# cleaning
blueecho ""
blueecho "--------------------------------------------------"
blueecho "                 - Cleaning files -               "
blueecho "--------------------------------------------------"
blueecho ""


rm -rf /tmp/*
rm /etc/apt/sources.list.d/metasploit-framework.list 
cd

blueecho ""
blueecho "--------------------------------------------------"
blueecho "            - Configuration complete. -           "
blueecho "             Add app to ubuntu laucher :          "
blueecho "https://codebysamgan.com/how-to-add-appimage-application-to-menu-in-ubuntu-linux"
blueecho "      You can switch themes in gnome tweak        "
blueecho "Use ida command to start ida and cutter_re to start cutter"
blueecho "--------------------------------------------------"
blueecho ""

gnome-tweaks
#exegol, nmap, wireshark, ffuf, postman,vscode, metasploit
#cd /tmp && git clone https://github.com/radareorg/radare2
#/tmp/radare2/sys/install.sh

#dotfiles, themes omz + transparancy dock
#keepass: sudo apt install keepassxc
#conclusion tools installé + install themes tuto

#rm /etc/apt/sources.list.d/metasploit-framework.list 
#TODO: Ppirus + Kali themes