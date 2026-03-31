#
# Copyright 2020 the original author jacky.eastmoon
#
# ------------------- shell setting -------------------

#!/bin/bash
set -e

# ------------------- declare CLI file variable -------------------

CLI_DIRECTORY=${PWD}
CLI_FILE=${BASH_SOURCE}
CLI_FILENAME=${BASH_SOURCE%.*}
CLI_FILEEXTENSION=${BASH_SOURCE##*.}

# ------------------- declare variable -------------------

PROJECT_NAME=${PWD##*/}

# ------------------- declare function -------------------


# ------------------- execute script -------------------

## Install tools
apt update -y
apt install build-essential libssl-dev -y
[ $(dpkg -l | grep build-essential | wc -l) -eq 0 ] && apt install -y build-essential || echo "[+] Package 'build-essential' installed."
[ $(dpkg -l | grep libssl-dev | wc -l) -eq 0 ] && apt install -y libssl-dev || echo "[+] Package 'libssl-dev' installed."
[ ! $(command -v curl) ] && apt install -y curl || echo "[+] Package 'curl' installed."

## Install uv
if [ ! $(command -v uv) ]; then
    echo "[-] Package 'uv' not find, install it."
    curl -LsSf https://astral.sh/uv/install.sh | bash
    source $HOME/.local/bin/env
else
    echo "[+] Package 'uv' installed."
fi

## Install nodejs
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
if [ ! $(command -v nvm) ]; then
  echo "[-] Package 'nvm' not find, install it."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
else
  echo "[+] Package 'nvm' installed."
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
if [ ! $(command -v node) ]; then
  echo "[-] Package 'node' not find, install it."
  nvm install --lts
  nvm use --lts
else
  echo "[+] Package 'node' installed."
fi

## Install claude CLI
[ $(dpkg -l | grep libsecret-1-0 | wc -l) -eq 0 ] && apt install -y libsecret-1-0 || echo "[+] Package 'libsecret-1-0' installed."
[ $(dpkg -l | grep libsecret-1-dev | wc -l) -eq 0 ] && apt install -y libsecret-1-dev || echo "[+] Package 'libsecret-1-dev' installed."
[ $(dpkg -l | grep gnome-keyring | wc -l) -eq 0 ] && apt install -y gnome-keyring || echo "[+] Package 'gnome-keyring' installed."
if [ ! $(command -v gemini) ]; then
    echo "[-] Package 'gemini' not find, install it."
    npm install -g @google/gemini-cli
else
    echo "[+] Package 'gemini' installed."
fi
