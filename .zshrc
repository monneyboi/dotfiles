# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="agnoster"
DEFAULT_USER="johan"

export BRAVE_API_KEY=BSA44Q29c8tkwU2mr2wSjQ_PluvTevT

# Tell ssh-add where ssh-agent lives
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

export MAKEFLAGS=-j8
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin

export EDITOR=nvim
export FZF_DEFAULT_COMMAND='rg --files --follow --hidden -g "!{.git,.hg,node_modules,dist}"'

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias htop="TERM=screen htop"
alias vim="nvim"
alias dc="docker-compose"
alias dig="drill"
alias k="kubectl"
alias kc="k config"
alias kcg="kc get-contexts"
alias kcs="kc set-context"
alias kubeseal="kubeseal --controller-name=sealed-secrets --controller-namespace=kube-system"
alias dotfiles="git --git-dir=$HOME/.dotfiles.git --work-tree=$HOME"
# Set to this to use case-sensitive completion
#CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how many often would you like to wait before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git)

source /opt/google-cloud-cli/completion.zsh.inc
source /opt/google-cloud-cli/path.zsh.inc

source $ZSH/oh-my-zsh.sh
# Define after sourcing oh-my-zsh as it sets grep alias aswell
alias grep="grep --color=auto --exclude-dir={.git,.hg,node_modules,dist,.next,__pycache__,.venv}"

export CUDA_HOME=/opt/cuda
export LD_LIBRARY_PATH=$CUDA_HOME/lib64:${LD_LIBRARY_PATH:-}
export WEBKIT_DISABLE_DMABUF_RENDERER=1

# Customize to your needs...
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/google-cloud-cli/bin:~/.npm-global/bin:$CUDA_HOME/bin:/home/johan/.cargo/bin:/home/johan/.local/bin:/home/johan/.local/share/pnpm:/home/johan/.local/share/pnpm/bin
