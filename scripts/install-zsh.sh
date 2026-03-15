#!/usr/bin/env bash

set -e

echo "[ZSH] Installing zsh..."
sudo pacman -S --needed --noconfirm zsh git

# ==========================================================
# Normal User Setup
# ==========================================================

echo "[ZSH] Setting up for normal user..."

# Install Oh My Zsh (user)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
	echo "[ZSH] Cloning Oh My Zsh (user)..."
	git clone https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
else
	echo "[ZSH] Oh My Zsh already installed (user)."
fi

ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

# Plugins (user)
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
	echo "[ZSH] Installing zsh-syntax-highlighting (user)..."
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
		"$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
	echo "[ZSH] Installing zsh-autosuggestions (user)..."
	git clone https://github.com/zsh-users/zsh-autosuggestions \
		"$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

# Set default shell (user)
echo "[ZSH] Setting default shell for user..."
chsh -s "$(which zsh)"

echo "[ZSH] Normal user setup complete."

# ==========================================================
# Root Setup Function
# ==========================================================

setup_root_zsh() {

	echo "[ZSH] Setting up root user..."

	sudo bash <<EOF
set -e

# Backup existing root .zshrc
if [ -f /root/.zshrc ]; then
  cp /root/.zshrc /root/.zshrc.backup.\$(date +%Y%m%d%H%M%S)
  echo "[ZSH][ROOT] Existing .zshrc backed up."
fi

# Install Oh My Zsh (root)
if [ ! -d "/root/.oh-my-zsh" ]; then
  echo "[ZSH][ROOT] Cloning Oh My Zsh..."
  git clone https://github.com/ohmyzsh/ohmyzsh.git /root/.oh-my-zsh
else
  echo "[ZSH][ROOT] Oh My Zsh already installed."
fi

ZSH_CUSTOM="/root/.oh-my-zsh/custom"

# Plugins (root)
if [ ! -d "\$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
    "\$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

if [ ! -d "\$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions \
    "\$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

# Set default shell for root
chsh -s "\$(which zsh)" root

echo "[ZSH][ROOT] Setup complete."

EOF

	echo "[ZSH] Root setup finished."
}

# ==========================================================
# Ask for Root Setup
# ==========================================================

read -rp "Setup for root user too? (y/N): " answer

case "$answer" in
[yY])
	setup_root_zsh
	;;
*)
	echo "[ZSH] Skipping root setup."
	;;
esac

echo "[ZSH] All tasks completed successfully."
