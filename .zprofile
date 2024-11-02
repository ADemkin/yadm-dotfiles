# History
export HISTFILE=$HOME/.zhistory
export HISTSIZE=64000
export SAVEHIST=64000

# Terminal
export TERM=xterm-256color

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
export PYTHONSTARTUP=~/.pythonstartup.py
export PYTHONWARNINGS=ignore

# set default chmod to 077:
umask 077
# startup fun

# update PATH with homebrew paths
eval "$(/opt/homebrew/bin/brew shellenv)"
