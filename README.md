# dotfiles
For use inside my DevPod containers make sure it is included like so:
<img width="1370" height="641" alt="image" src="https://github.com/user-attachments/assets/07e2702f-3e57-4595-8098-041a953e5ac2" />
Note that this is using the HTTPS addres to avoid auth issues with sudo not being on some of the images that I use. 
Double note that when downloading a project you want to do the opposite and use the ssh not HTTPS to ensure git creds work with commits and you don't have to reauth

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

## Securely fetch dev_local.py from 1Password

This repo doesn’t store secrets. Use a 1Password Service Account and the CLI to pull `dev_local.py` on demand.

### Prereqs
- 1Password account (Business/Team) with access to a vault you control
- 1Password CLI v2+ installed: https://developer.1password.com/docs/cli/get-started/
- `jq` installed (for JSON parsing)

### One-time setup (manual)
1. Create a vault
   - In 1Password web: New → Vault → name it (e.g., “Dev Secrets”).
2. Add `dev_local.py` to the vault
   - Option A (Document): New → Document → upload `dev_local.py` → name it `dev_local.py`.
   - Option B (Item with file attachment): New → Secure Note (or any item) → Attach file `dev_local.py` → ensure the item name is `dev_local.py` (or remember it).
3. Create a Service Account and token
   - 1Password web → Developer → Service Accounts → New Service Account.
   - Scope: Read access to your chosen vault.
   - Copy the generated token and store it securely (you’ll pass it to the script).

Notes:
- Service Account tokens do not require device pairing and work non-interactively.
- Keep the token out of your shell history; prefer env vars or a manager.

### Fetch script
This repo includes `fetch_dev_local.sh` which:
- Takes the Service Account token as the first argument
- Asks for: vault name and destination path
- Downloads `dev_local.py` from the vault and saves it

Usage:
```bash
./fetch_dev_local.sh "<OP_SERVICE_ACCOUNT_TOKEN>"
```

You’ll be prompted for:
- Vault name (e.g., Dev Secrets)
- Item/file name (defaults to `dev_local.py`)
- Destination path (full path, defaults to `/tmp/dev_local.py`)

### Common issues
- op not found: install the CLI and ensure it’s on PATH.
- Vault not accessible: confirm the Service Account has read access to that vault.
- Item not found: confirm the name in 1Password matches `dev_local.py` or enter the exact item/document name when prompted.
- Attachments vs documents: the script handles both a Document named `dev_local.py` and an Item with a file attachment.

### Security
- The token isn’t stored; it’s used only for the current run.
- Output file is chmod 600.
- Don’t commit the token or `dev_local.py` to git.

## ToDo:
-  Sort out clip board access:
    * Right now only copying from neovim gets back to the host outside the container
    * Copying branch names from lazygit fails
    * Look at using [clipper](https://github.com/wincent/clipper):
       -[Using clipper to pip to clipboard](https://github.com/jesseduffield/lazygit/issues/1617)
-  Fix lazygit being able to open PRs by using the host machines browser
