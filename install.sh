#!/bin/bash

# https://github.com/catppuccin/lazygit
echo "Installing lazygit:"
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
install lazygit -D -t /usr/local/bin/

# This allows for better git diffs in git cli and lazygit
echo "install git-delta with cargo"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source $HOME/.cargo/env
export PATH="$HOME/.cargo/bin:$PATH"
cargo install git-delta
cargo install eza

echo "copying in gitconfig"
rm ~/.gitconfig
cp ~/dotfiles/gitconfig ~/.gitconfig
cat ~/.config/lazygit/config.yml

echo "copying in lazygit config"
rm ~/.config/lazygit/config.yml
cp ~/dotfiles/lazygit_repo/config.yml ~/.config/lazygit/config.yml
cat ~/.config/lazygit/config.yml

echo "Set up pure prompt"
# git clone https://github.com/sindresorhus/pure.git "~/.zsh/pure"

echo "Nvim config:"
git clone https://github.com/Rich107/neovim-config.git ~/.config/nvim/

echo "Install fzf for telescope to work, plus githib cli ssh and bits"
apt update -y && apt install -y openssh-client bat less gh curl wget tar ripgrep build-essential fzf

# this will save waiting on the first nvim reboot
echo "Run Mason installs for Nvim"
nvim --headless -c "MasonInstallAll" -c "qall"

# Install NVM for npm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

echo "Setup complete. Zsh configuration files have been downloaded and set up."
