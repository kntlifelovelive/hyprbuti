#.zshrc Customize Configuration 
DISABLE_AUTO_UPDATE="true"
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
plugins=(git zsh-syntax-highlighting zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh

# ==== Configuration Commands === 
alias update='sudo pacman -Syu'
alias love='clear && myfetch -i A -f -c 16 -C " █ "'
alias grep='grep --color=auto'
alias bye='sudo shutdown -h now'
alias loop='sudo reboot'
alias fonts='fc-list -f "%{family}\n"'
alias fontcache='fc-cache -fv'
alias n="nvim"
alias hr="hyprctl reload"

# Myconfig alias ===
# ==================
alias ls='ls --color=auto'
alias tree='tree -C'

# Pacman install package
alias pacupf='sudo pacman -Syyu'  # force update system
alias pacmanrm='sudo pacman -Rns' # remove package with configs
alias pacmanss='pacman -Ss'       # search package in repo
alias pacmani='sudo pacman -S'    # install package
alias pacq='pacman -Q'            # list installed packages
alias pacql='pacman -Ql'          # list files of a package
alias pacinfo='pacman -Si'        # show package info

# Yay (AUR helper)
alias yupdate='yay -Syu' # update all (AUR + repo)
alias yinstall='yay -S'  # install package from AUR/repo
alias yremove='yay -Rns' # remove with configs
alias yclean='yay -Yc'   # clean unneeded packages
alias ysearch='yay -Ss'  # search

export TERM=kitty
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

HISTSIZE=150000
SAVEHIST=150000
HISTFILE=~/.zsh_history

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS

# ZSH Customize Prompt  Function 
function set_bubu_prompt() {
  local exit_code=$?        # last command exit code
  local git_branch=""
  local prompt_symbol=">"
  local venv_name=""
  local user_color=""

  # Detect active Python virtual environment
  if [[ -n "$VIRTUAL_ENV" ]]; then
    venv_name="(%F{green} $(basename $VIRTUAL_ENV)%f) "
  elif [[ -n "$CONDA_DEFAULT_ENV" ]]; then
    venv_name="(%F{green} $CONDA_DEFAULT_ENV%f) "
  fi

  # Git branch & dirty check
  if git rev-parse --git-dir >/dev/null 2>&1; then
    local branch_name
    branch_name=$(git branch --show-current 2>/dev/null)
    git_branch=" %F{cyan}%f %F{blue}$branch_name%f"

    if [[ -n $(git status --porcelain 2>/dev/null) ]]; then
      prompt_symbol="%F{red}>%f"
    fi
  fi

  # Command error check
  if [[ $exit_code -ne 0 ]]; then
    prompt_symbol="%F{red}>%f"
  fi

  # User color
  if [[ $EUID -eq 0 ]]; then
    user_color="%F{red}"   # root = red
  else
    user_color="%F{220}%B" # normal user = yellow
  fi

  # Build prompt: actual newline here
  PROMPT="%F{magenta}╭(${venv_name}${user_color}%n%f%F{magenta})-[%F{cyan}%~%f%F{magenta}]${git_branch}
%F{magenta}╰─${prompt_symbol} %f"
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd set_bubu_prompt


# Shell Prompt Title Banner Function 

title_banner() {
echo -e "\033[1;35m  
▄▄   ▄▄ ▄▄▄▄▄ ▄▄     ▄▄▄▄  ▄▄▄  ▄▄   ▄▄   ▄▄▄▄▄▄ ▄▄▄    ████▄  ▄▄▄▄  ▄▄▄▄▄  ▄▄▄  ▄▄   ▄▄ 
██ ▄ ██ ██▄▄  ██    ██▀▀▀ ██▀██ ██▀▄▀██     ██  ██▀██   ██  ██ ██▄█▄ ██▄▄  ██▀██ ██▀▄▀██ 
 ▀█▀█▀  ██▄▄▄ ██▄▄▄ ▀████ ▀███▀ ██   ██     ██  ▀███▀   ████▀  ██ ██ ██▄▄▄ ██▀██ ██   ██
\033[0m"
	local text=" 🌺 Trust your heart if the sea catch fire,live by love though the stars walk backwack. 🌸🌾 "

	local padding=35 # slide distance
	local speed=0.04

	tput civis # hide cursor

	# Slide from right
	for ((i = padding; i >= 0; i--)); do
		printf "\r%*s\e[1;36m%s\e[0m" "$i" "" "$text"
		sleep $speed
	done
	# Keep full text and enable blink
	printf "\r\e[5m\e[1;36m%s\e[25m\e[0m\n" "$text"
	tput cnorm # restore cursor
}

# Define the banner function
print_banner() {
	printf "\e[0m\e[1;36m🌺 Trust your heart if the sea catch fire,\e[0m\e[5m\e[1;36mlive\e[0m\e[1;36m by love though the stars walk backwack. 🌸🌾 \e[25m\e[0m\n"
	# printf "\033[0;100m\e[1;92m 󱢴  %s - %s - %s - 󰥔 %s 󱢴 \n" "$(date +'%b')" "$(date +'%d')" "$(date +'%Y')"  "$(date +'%I:%M -%p')"
}

# Custom clear command to include banner
function clear {
	command clear
	print_banner
}

# function invoke  call 
[[ -o interactive ]] && title_banner
