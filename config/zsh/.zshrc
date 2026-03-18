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
alias e='eza --icons'
alias el='eza -lh --icons --git --group-directories-first'
alias ela='eza -alh --icons --git --group-directories-first'

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

# node global Path import 
export PATH=~/.npm-global/bin:$PATH

export TERM=kitty
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

eval "$(zoxide init zsh)" # super file maanger for packager metadatas 


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

# ZSH Customize PS1 Prompt  Function 
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
#    PROMPT="%F{magenta}╭(${venv_name}%K{#9A348E}${user_color} %n %f%k%F{magenta})-[%F{cyan}%~%f%F{magenta}]${git_branch}
# %F{magenta}╰─${prompt_symbol} %f"
}

# Zsh PS1 Prompt function Invoke 
autoload -Uz add-zsh-hook
add-zsh-hook precmd set_bubu_prompt


# Define the banner function
print_banner() {
	printf "\e[0m\e[1;36m🌺 Trust your heart if the sea catch fire,\e[0m\e[5m\e[1;31mlive\e[0m\e[1;36m by \e[0m\e[5m\e[1;32mlove\e[0m\e[1;36m though the stars walk backwack. 🌸🌾 \e[25m\e[0m\n"
	# printf "\033[0;100m\e[1;92m 󱢴  %s - %s - %s - 󰥔 %s 󱢴 \n" "$(date +'%b')" "$(date +'%d')" "$(date +'%Y')"  "$(date +'%I:%M -%p')"
}


# Custom clear command to include banner
function clear {
	command clear
	print_banner
}


# ┌────────────────────────────────────────────┐
# │ Terminal Banner ScriptPath Import Variable │
# │ AuthorModify : KyawNyeinThant,Gemini flash │
# │ Date         : 2026 , March, 17            │
# └────────────────────────────────────────────┘
# Terminal Banner Script Path folder 
BANNER_DIR="$HOME/.config/TerminZsh_Banner"

# 1 Load Variable Files
[[ -f "$BANNER_DIR/asciibanners.zsh" ]] && source "$BANNER_DIR/asciibanners.zsh"
[[ -f "$BANNER_DIR/textbanners.zsh" ]] && source "$BANNER_DIR/textbanners.zsh"

# 2 Load All Functions (Animations & Effects)
for f in "$BANNER_DIR/animations/"*.zsh; do source "$f"; done
for f in "$BANNER_DIR/text_effects/"*.zsh; do source "$f"; done



# ┌────────────────────────────────────────────┐
# │ Terminal Banner Animation Main Function    │
# │ AuthorModify : KyawNyeinThant,Gemini flash │
# │ Date         : 2026 , March, 17            │
# └────────────────────────────────────────────┘
# 3 Master Random Banner Function (Fixed Version)
random_banner() {

    # (A) ASCII Banner Random 
    local ascii_list=( ${(k)parameters[(I)Banner_*]} )
    local selected_ascii_name="${ascii_list[$(( RANDOM % ${#ascii_list[@]} + 1 ))]}"
    local selected_ascii="${(P)selected_ascii_name}"

    # (B) Text Message Random 
    local text_list=( ${(k)parameters[(I)Text_*]} )
    local selected_text_name="${text_list[$(( RANDOM % ${#text_list[@]} + 1 ))]}"
    local selected_text="${(P)selected_text_name}"

    # (C) Auto-Detect Functions
    local header_anims=( ${(k)functions[(I)header_*]} )
    local text_effects=( ${(k)functions[(I)text_*]} )

    # --- EXECUTION ---
    # ၁။ ASCII Header Animation (Index + 1 )
    if [[ ${#header_anims[@]} -gt 0 ]]; then
        local h_idx=$(( RANDOM % ${#header_anims[@]} + 1 ))
        ${header_anims[$h_idx]} "$selected_ascii"
    fi
    
    # ၂။ Text Effect Animation Random (Index + 1 )
    if [[ ${#text_effects[@]} -gt 0 ]]; then
        local t_idx=$(( RANDOM % ${#text_effects[@]} + 1 ))
        ${text_effects[$t_idx]} "$selected_text"
    fi
}

# ┌────────────────────────────────────────────┐
# │ Terminal Banner Animation Open Run         │
# │ AuthorModify : KyawNyeinThant,Gemini flash │
# │ Date         : 2026 , March, 17            │
# └────────────────────────────────────────────┘
[[ -o interactive ]] && { command clear; random_banner }
