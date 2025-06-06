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

echo "Installing Artuin for history in terminal commands"
echo 'eval "$(atuin init zsh)"' >>~/.zshrc

echo "copying in mcphub config "
rm ~/.config/mcphub/servers.json
cp ~/dotfiles/mcphub/servers.json ~/.config/mcphub/servers.json
cat ~/.config/mcphub/servers.json

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

echo "Install GitHub CLI and TUI"
(type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) &&
    sudo mkdir -p -m 755 /etc/apt/keyrings &&
    out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg &&
    cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null &&
    sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg &&
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null &&
    sudo apt update &&
    sudo apt install gh -y
apt update
apt install gh
gh extension install dlvhdr/gh-dash

echo "Aliases:"
echo "alias ls='eza -lh'" >>~/.zshrc

echo "Setup complete. Zsh configuration files have been downloaded and set up."
