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

# lazygit:
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/

echo "All packages have been installed."

# # Set up pure prompt
# git clone https://github.com/sindresorhus/pure.git "~/.zsh/pure"

# Nvim config:
git clone https://github.com/Rich107/neovim-config.git ~/.config/nvim/

# Set up completions

echo "Setup complete. Zsh configuration files have been downloaded and set up."
