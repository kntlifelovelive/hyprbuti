#!/usr/bin/env zsh 



--- Smart File Opener with Rich Preview (Ctrl+T) ---
# Preview Photos 
fzf-file-widget() {
  local preview_cmd='
    if [ -d {} ]; then
      eza --icons=always --tree --color=always {} | head -200
    else
      case {} in
        *.png|*.jpg|*.jpeg|*.gif|*.bmp|*.webp)
          # Kitty icat show Photos Preview 
          kitty +kitten icat --clear --transfer-mode=memory --stdin no --place "${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}@0x0" {} ;;
        *.mp4|*.mkv|*.avi|*.mp3|*.flac) 
          mediainfo {} ;;      
        *.pdf) 
          exiftool {} ;;                                
        *) 
          bat --color=always -n --line-range :500 {} ;;    
      esac
    fi'

  local selected_path=$(fd --hidden --exclude .git | fzf \
    --layout=reverse \
    --height=85% \
    --header=" [q]File-Search to Quit | [Enter] to Open Default" \
    --header-first \
    --prompt="|| Search > " \
    --bind="q:abort" \
    --preview "$preview_cmd" \
    --preview-window="right:50%:wrap")

  if [[ -n "$selected_path" ]]; then
    if [ -d "$selected_path" ]; then
      cd "$selected_path"
    elif [[ "$selected_path" =~ \.(png|jpg|jpeg|gif|mp4|mp3|mkv|pdf|docx|webp)$ ]]; then
      xdg-open "$selected_path" > /dev/null 2>&1 &
    else
      zle -I
      nvim "$selected_path"
    fi
  fi

  # Kitty image cache clean  
  kitty +kitten icat --clear --stdin no
  command clear
  zle reset-prompt
}


# --- Ctrl + F (Folder Search) Custom Widget for [q] support ---
fzf-cd-widget() {
  local cmd="fd --type=d --hidden --exclude .git"

  local dest=$(eval "$cmd" | fzf \
    --layout=reverse \
    --height=85% \
    --header="󰉍 Folder Search | [q] to Quit" \
    --header-first \
    --prompt="  || Search > " \
    --bind="q:abort" \
    --preview 'eza --icons=always --tree --color=always {} | head -200')

  if [[ -n "$dest" ]]; then
    cd "$dest"
  fi

  # Prompt clean
  zle reset-prompt
}


# Register & Bind
zle -N fzf-file-widget
bindkey '^t' fzf-file-widget
bindkey -M viins '^t' fzf-file-widget
bindkey -M vicmd '^t' fzf-file-widget

zle -N fzf-cd-widget
bindkey '^f' fzf-cd-widget
bindkey -M viins '^f' fzf-cd-widget
bindkey -M vicmd '^f' fzf-cd-widget
