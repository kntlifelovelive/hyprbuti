#!/bin/bash

set -e

REPO="$HOME/hyprbuti/config"
CONFIG="$HOME/.config"
DATE="$(date +%Y%m%d_%H%M%S)"

mkdir -p "$CONFIG"

echo "Hypr Configurations Setup from $REPO"
echo

# Skip list
SKIP_ITEMS=("mainstaller" "packages" "scripts" "photo")

for item in "$REPO"/*; do
  [ -e "$item" ] || continue
  name="$(basename "$item")"

  # Skip check
  for skip in "${SKIP_ITEMS[@]}"; do
    if [[ "$name" == "$skip" ]]; then
      echo "Skipping $name"
      continue 2
    fi
  done

  # ------------------------------
  # ZSH (Normal User)
  # ------------------------------
  if [[ "$name" == "zsh" ]]; then
    if [ -f "$item/.zshrc" ]; then

      if [ -f "$HOME/.zshrc" ]; then
        echo "Backing up user .zshrc → .zshrc_backup_$DATE"
        mv "$HOME/.zshrc" "$HOME/.zshrc_backup_$DATE"
      fi

      echo "Copying user .zshrc"
      cp "$item/.zshrc" "$HOME/"
    fi
    continue
  fi

  # ------------------------------
  # Normal config copy
  # ------------------------------
  if [ -e "$CONFIG/$name" ]; then
    echo "Backing up $name → ${name}_backup_$DATE"
    mv "$CONFIG/$name" "$CONFIG/${name}_backup_$DATE"
  fi

  echo "Copying $name"
  cp -r "$item" "$CONFIG/"
done

echo
echo "User configuration done."

# ==========================================================
# Root .zshrc Setup (Optional)
# ==========================================================

setup_root_zshrc() {

  if [ ! -f "$REPO/zshroot/.zshrc" ]; then
    echo "No root .zshrc found in zshroot folder. Skipping."
    return
  fi

  echo "Setting up root .zshrc..."

  sudo bash -c "
	DATE=\"$DATE\"

	if [ -f /root/.zshrc ]; then
		echo 'Backing up root .zshrc'
		mv /root/.zshrc /root/.zshrc_backup_\$DATE
	fi

	echo 'Copying new root .zshrc'
	cp \"$REPO/zshroot/.zshrc\" /root/.zshrc
	chown root:root /root/.zshrc
	chmod 644 /root/.zshrc
	"

  echo "Root .zshrc setup complete."
}

echo
read -rp "Setup root .zshrc too? (y/N): " answer

case "$answer" in
[yY])
  setup_root_zshrc
  ;;
*)
  echo "Skipping root setup."
  ;;
esac

echo
echo "All configuration completed successfully."
