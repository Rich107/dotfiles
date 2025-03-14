# dotfiles
For use inside my DevPod containers 

## How to use:

### Graphical UI
When running DevPod in the UI be sure to set your dotfile repo under:
> settings -> Customization -> Dotfiles


### CLI:
pass in `--dotfiles` argument when running DevPod up for example:

``` bash
devpod up https://github.com/example/repo --dotfiles https://github.com/my-user/my-dotfiles-repo
```
In this repos case:
``` bash
devpod up https://github.com/example/repo --dotfiles https://github.com/Rich107/dotfiles
```

## How this works:
DevPod will look for the following file names and execute them:
-  install.sh 👈️ This is what I will be using
-  install
-  bootstrap.sh
-  bootstrap
-  script/bootstrap
-  setup.sh
-  setup
-  script/setup

[link to DevPod docs](https://devpod.sh/docs/developing-in-workspaces/dotfiles-in-a-workspace)

My preference is to keep my Neovim/TMUX dotfiles separate to make them easier to maintain on my mac.
Ideally I want one nvim and one TMUX config


## Assumptions:
-  These dotfiles will be used on a linux based container either running on a linux host or mac host (have not tested windows or linux)
-  The project devcontainer.json will have the neovim feature installing neovim 0.8 or higher
