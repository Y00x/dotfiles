#!/bin/bash
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

blueecho  ""
blueecho  "--------------------------------------------------"
blueecho  "              - OMZ-Installer -                   "
blueecho  "-------------------By Yo0x------------------------"
blueecho  ""


sudo apt install -y zsh zsh-syntax-highlighting zsh-autosuggestions
redecho "FOR OMZ TYPE Y AND EXIT TO CONTINUE INSTALLATION"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git $ZSH_CUSTOM/plugins/zsh-autocomplete


#transparency dock
gsettings set org.gnome.shell.extensions.dash-to-dock transparency-mode 'FIXED'
gsettings set org.gnome.shell.extensions.dash-to-dock background-opacity 0

blueecho  ""
blueecho  "--------------------------------------------------"
blueecho  "             - Installation complete. -           "
blueecho  "--------------------------------------------------"
blueecho  ""