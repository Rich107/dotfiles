#!/bin/bash

# Set up XDG_CONFIG_HOME
export XDG_CONFIG_HOME="$HOME"/.config
mkdir -p "$XDG_CONFIG_HOME"
mkdir -p "$XDG_CONFIG_HOME"/nixpkgs

# wip need to pull in my .zsh config
# curl -o "$HOME/.zshrc" https://raw.githubusercontent.com/mischavandenburg/dotfiles/main/.zshrc
# curl -o "$HOME/.zprofile" https://raw.githubusercontent.com/mischavandenburg/dotfiles/main/.zprofile

# Nvim should already be installed
# curl -o "$HOME/.config/nvim/" https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz && rm -rf /opt/nvim && tar -C /opt -xzf nvim-linux-x86_64.tar.gz

packages=(
    fd
    ripgrep
    npm
    lazygit
    fzf
    kubectl
    direnv
)

# Iterate over the array and install each package
for package in "${packages[@]}"; do
    echo "Installing $package..."
    /home/linuxbrew/.linuxbrew/bin/brew install "$package"
done

echo "All packages have been installed."

# Set up pure prompt

mkdir -p "$HOME/.zsh"
git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"

# Silence source warning

touch "$HOME/.privaterc"

# Set up completions

echo "Setup complete. Zsh configuration files have been downloaded and set up."
