# Oh-My-Zsh
DISABLE_AUTO_UPDATE="true"
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""

plugins=(git zsh-syntax-highlighting zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

# Custom plugins
source "${ZSH_CUSTOM:-~/.zsh}/plugins/zsh-system-clipboard/zsh-system-clipboard.zsh"
