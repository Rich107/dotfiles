#!/bin/bash

# https://github.com/catppuccin/lazygit
echo "Installing lazygit:"
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
install lazygit -D -t /usr/local/bin/

# This allows for better git diffs in git cli and lazygit
echo "install git-delta with cargo"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env
cargo install git-delta

echo "Set up pure prompt"
# git clone https://github.com/sindresorhus/pure.git "~/.zsh/pure"

echo "Nvim config:"
git clone https://github.com/Rich107/neovim-config.git ~/.config/nvim/

echo "Install fzf for telescope to work githib cli ssh and bits"
apt update -y && apt install -y openssh-client gh curl wget tar ripgrep build-essential fzf

echo "Install ssh as not all containers have it installed"
apt apt install openssh-client

echo "Set Mason installs for Nvim (this will save waiting on the first nvim reboot"
nvim --headless -c "MasonInstallAll" -c "qall"

# Install NVM for npm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

echo "Setup complete. Zsh configuration files have been downloaded and set up."
