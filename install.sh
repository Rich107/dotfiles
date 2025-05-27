#!/bin/bash

# https://github.com/catppuccin/lazygit
echo "Installing lazygit:"
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
install lazygit -D -t /usr/local/bin/

# This allows for better git diffs in git cli and lazygit
echo "Installing cargo:"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
export CARGO_HOME="$HOME/.cargo"
export PATH="$CARGO_HOME/bin:$PATH"
. "$CARGO_HOME/env"
. "$HOME/.cargo/env"

echo "installing git-delta, eza, bat, du-dust, ripgrep, atuin, fd-find, tealdeer with cargo"
echo "Richard look here!"
cargo install git-delta
cargo install eza
cargo install bat
cargo install du-dust
cargo install ripgrep
cargo install atuin
cargo install fd-find
cargo install tealdeer

cargo --version

echo "copying in gitconfig"
rm ~/.gitconfig
cp ~/dotfiles/gitconfig ~/.gitconfig
cat ~/.gitconfig

echo "copying in lazygit config"
rm ~/.config/lazygit/config.yml
cp ~/dotfiles/lazygit_repo/config.yml ~/.config/lazygit/config.yml
cat ~/.config/lazygit/config.yml

echo "Set up pure prompt"
# git clone https://github.com/sindresorhus/pure.git "~/.zsh/pure"

echo "Nvim config:"
rm -rf ~/.config/nvim
git clone https://github.com/Rich107/neovim-config.git ~/.config/nvim/

echo "Install fzf for telescope to work, plus githib cli ssh and bits"
apt update -y && apt install -y xclip openssh-client less zsh gh curl wget tar build-essential fzf

echo "Install Oh My zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# this will save waiting on the first nvim reboot
# This is causing some issues going to install it manually to see whats going on
# echo "Run Mason installs for Nvim"
# nvim --headless -c "MasonInstall *" -c "qall"

# Install NVM for npm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

echo "Aliases:"
echo "alias ls='eza -lh'" >>~/.zshrc

echo "Setup complete. Zsh configuration files have been downloaded and set up."
