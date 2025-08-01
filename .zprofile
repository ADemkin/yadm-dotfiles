umask 077

# History
export HISTFILE=$HOME/.zhistory
export HISTSIZE=64000
export SAVEHIST=64000

# Terminal
# export TERM=xterm-256color

# Basic envs
export SHELL=/bin/zsh
export EDITOR=vim
export VISUAL=vim

# Less options
export PAGER=less
export LESSHISTFILE=-
# Additional less options:
export LESS=RXi

# Python options
# export PIP_RESPECT_VIRTUALENV=true
# export PIP_VIRTUALENV_BASE=~/.virtualenvs
export PYTHONDONTWRITEBYTECODE=1
export PYTHONSTARTUP="$HOME/.pythonstartup.py"
# export PYTHONWARNINGS=ignore

# Go
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"

# Docker options
export DOCKER_CLI_HINTS=false

# Homebrew
# update PATH with homebrew paths
export HOMEBREW_NO_ENV_HINTS=1
eval "$(/opt/homebrew/bin/brew shellenv)"
