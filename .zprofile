# History
HISTFILE=~/.zhistory
HISTSIZE=32768
SAVEHIST=32768

# Terminal
# export COLORFGBG="default;default;0"
# export COLORTERM="xterm-256color"
# [ "$TERM" = "screen-256color" ] || TERM=xterm-256color
# export TERM
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
