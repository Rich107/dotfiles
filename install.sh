#!/bin/bash

# This was origainlly copied from a nix base but that is not currently working below is what we need to ensure is installed:
# There was then an alternative for Brew but that will only work on a linux machine
# Brew does not work inside a container running on a M chip Mac
# packages=(
#     fd
#     ripgrep
#     npm
#     lazygit
#     fzf
#     kubectl
#     direnv
# )

export IN_CONTAINER=true

echo "Installing lazygit:"
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/

echo "Installing github tbc:"

echo "Set up pure prompt"
# git clone https://github.com/sindresorhus/pure.git "~/.zsh/pure"

echo "Nvim config:"
git clone https://github.com/Rich107/neovim-config.git ~/.config/nvim/

echo "Install fzf for telescope to work:"
sudo apt update -y && apt install -y curl wget tmux tar ripgrep build-essential fzf

echo "Set Mason installs for Nvim (this will save waiting on the first nvim reboot"
sudo nvim --headless -c "MasonInstallAll" -c "qall"

# Install NVM for npm
sudo curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

echo "Setup complete. Zsh configuration files have been downloaded and set up."
