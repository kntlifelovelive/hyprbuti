#!/usr/bin/env bash

echo "[ZSH] Installing zsh..."
sudo pacman -S --needed zsh

# ------------------------------
# Oh My Zsh Install
# ------------------------------
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "[ZSH] Installing Oh My Zsh..."
  RUNZSH=no CHSH=no sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "[ZSH] Oh My Zsh already installed."
fi

# ------------------------------
# Plugins Install (safe)
# ------------------------------
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

# zsh-syntax-highlighting
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
else
  echo "[ZSH] zsh-syntax-highlighting already installed."
fi

# zsh-autosuggestions
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
else
  echo "[ZSH] zsh-autosuggestions already installed."
fi

# ------------------------------
# Set default shell
# ------------------------------
echo "[ZSH] Setting default shell..."
chsh -s $(which zsh)

echo "[ZSH] Done."
