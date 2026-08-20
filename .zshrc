# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="agnoster"
DEFAULT_USER="johan"

# Secrets (API keys etc.) live in ~/.zshrc.local, which is untracked
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# Tell ssh-add where ssh-agent lives
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

export MAKEFLAGS=-j8
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin

export EDITOR=nvim
export FZF_DEFAULT_COMMAND='rg --files --follow --hidden -g "!{.git,.hg,node_modules,dist}"'

# Example aliases
alias vim="nvim"
alias dig="drill"
alias dotfiles="git --git-dir=$HOME/.dotfiles.git --work-tree=$HOME"
alias restic-local='restic -r ~/Backup --password-command "secret-tool lookup service restic"'
alias restic-hetzner='restic -r rclone:restic -o "rclone.program=ssh storagebox" --password-command "secret-tool lookup service restic"'

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git)

source /opt/google-cloud-cli/completion.zsh.inc
source /opt/google-cloud-cli/path.zsh.inc

source $ZSH/oh-my-zsh.sh

export CUDA_HOME=/opt/cuda
export LD_LIBRARY_PATH=$CUDA_HOME/lib64:${LD_LIBRARY_PATH:-}
export WEBKIT_DISABLE_DMABUF_RENDERER=1

# Customize to your needs...
export PATH=/usr/bin:/opt/google-cloud-cli/bin:$CUDA_HOME/bin:$HOME/.cargo/bin:$HOME/.local/bin:$HOME/.local/share/pnpm/bin

# Package caches live under Projects so uv and pnpm can hardlink from cache
# to target (venvs, node_modules) within one filesystem/mount.
export UV_CACHE_DIR="$HOME/Projects/.cache/uv"
export pnpm_config_store_dir="$HOME/Projects/.cache/pnpm-store"
