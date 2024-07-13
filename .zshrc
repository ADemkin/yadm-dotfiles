# PATH
# MacPort
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# NPM
export PATH="/Users/$USER/.npm-global/bin/:$PATH"
# Homebrew
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/opt/node@18/bin:$PATH"

# Homebrew keys
# export HOMEBREW_GITHUB_API_TOKEN="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"

# # Prompt
# # Find and set branch name var if in git repository.
function git_branch() {
    git branch --show-current 2>&-
}
function format_git_branch() {
    _branch=$(git_branch)
    [[ $_branch != "" ]] && echo "%F{green}>%f $_branch" || echo ""
}

# Config for prompt. PS1 synonym.
# autoload -U colors && colors
setopt prompt_subst
export PROMPT='%n%F{red}@%f%m%F{red}:%f%? %* %~ $(format_git_branch)
%F{red}%#%f '

# Basic options
setopt APPEND_HISTORY SHARE_HISTORY INC_APPEND_HISTORY HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE  # dont write cmd to hist if it start with space
setopt INTERACTIVE_COMMENTS
setopt GLOB_STAR_SHORT  # change **/*.py to **.py
setopt GLOB_DOTS
setopt EXTENDED_GLOB  # use ~ to ignore, ex: **.py*~*.pyc will ignore .pyc
setopt NO_NOMATCH
setopt AUTO_PUSHD PUSHD_IGNORE_DUPS  # use pushd when cd
# additional stuff
# setopt CORRECT  # auto correct command, not arguments

export HISTFILE=$HOME/.zhistory

# EMACS mode
bindkey -e
setopt EMACS
autoload -U edit-command-line
zle -N edit-command-line
bindkey "^x^e" edit-command-line  # open editor with C-x C-e
# may not work in zsh 5.7:
export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'  # non-word symbols are threated like words
# https://unix.stackexchange.com/questions/250690/how-to-configure-ctrlw-as-delete-word-in-zsh

# History search
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^[[A" history-beginning-search-backward-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^[[B" history-beginning-search-forward-end
bindkey "^N" history-beginning-search-forward-end
bindkey "^R" history-incremental-search-backward

# alert when ready to promt:
precmd() {
    print -n "\a"
    # echo -ne "\a"
}

# # Tmux pane name
# clear_tmux_pane()
# {
#     printf "\033]2;\033\\"
# }
# clear_tmux_pane

#######################################################################
# Aliases
#######################################################################
#
alias l="ls -AF "
alias ll="ls -AFl "
alias -g M="| less"
alias timer="python ~/code/pytimer/timer.py"

# Git workflow
alias grup="git remote update"
alias greb="git rebase origin/master"
alias grib="git rebase -i origin/master"
alias gch="git checkout"
alias gst="git status"
alias gdiff="git diff"
alias greset="git reset --hard"
alias ggrep="git grep"
alias gg="git graph"
alias gchom="git checkout origin/master"

# ssh and attach tmux with compression:
ssht() {
    ssh -C -t "$1" tmux attach -t0
}

# More complex grep
GREP=$(which grep)
g() {
    $GREP --color=always --with-filename --recursive $@ | less --RAW-CONTROL-CHARS
}
alias cgrep="$GREP --color=always"
function grep() {
    # disable color when output is piped
    if [ -t 1 ]; then
        # output is terminal
        _colour="always"
    else
        # output is pipe
        _colour="never"
    fi;
    $GREP --colour=$_colour $@
}


# Completion
setopt AUTO_MENU AUTO_LIST
zstyle ":completion:*:functions" ignored-patterns "_*"
zstyle ":completion:*" matcher-list "" 'm:{a-z\-}={A-Z\_}' 'r:|?=** m:{a-z\-}={A-Z\_}'

_mycomp () {
    [ $CURRENT -eq 1 ] && _command_names || _files
}
zstyle ":completion:*" completer _mycomp _parameters

autoload -U compinit ; compinit -d /tmp/.zcompdump

zstyle ":completion:*:default" list-colors ""
autoload -U complist

# Highlighting
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
. $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]="fg=yellow"
ZSH_HIGHLIGHT_STYLES[globbing]="fg=magenta"
ZSH_HIGHLIGHT_STYLES[history-expansion]="fg=magenta"
ZSH_HIGHLIGHT_STYLES[commandseparator]="fg=red"
ZSH_HIGHLIGHT_STYLES[redirection]="fg=red"
ZSH_HIGHLIGHT_STYLES[assign]="fg=cyan"

# Launch ssh-agent or reuse it
# ~/agent.sh $HOME/.ssh/agent.sock

# Murder process
murder()
{
    pkill -f "$@";
}

# forward ports
fwd()
{
    for port in $@; do
        ssh -fNL "$port":localhost:"$port" imac5k
    done;
}

# kill all forwarding ssh
unfwd()
{
    pkill -f "ssh -fNL";
}

# ssh & connect to tmux
ssht() {
    ssh -C -t "$1" $(which tmux) -S /tmp/tmux-shared.sock attach -t shared
}

# mkdir and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

mov2gif() {
    _mov_name="$1"
    _gif_name="$(basename -s .mov $_mov_name).gif"
    ffmpeg -i $_mov_name -pix_fmt rgb8 -r 10 $_gif_name && gifsicle -O3 $_gif_name -o $_gif_name
}

# Colorized man pages: http://boredzo.org/blog/archives/2016-08-15/colorized-man-pages-understood-and-customized
LESS_TERMCAP_mb=$(printf "\e[1;31m") \
LESS_TERMCAP_md=$(printf "\e[1;31m") \
LESS_TERMCAP_me=$(printf "\e[0m") \
LESS_TERMCAP_se=$(printf "\e[0m") \
LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
LESS_TERMCAP_ue=$(printf "\e[0m") \
LESS_TERMCAP_us=$(printf "\e[1;32m") \

# ls colors
export CLICOLOR=1
export LSCOLORS="BxGxcxdxCxegDxabagacad"

# Python
export PATH="/opt/homebrew/opt/python@3.8/bin:$PATH"
export PATH="/opt/homebrew/opt/python@3.10/bin:$PATH"
export PATH="/opt/homebrew/opt/python@3.11/bin:$PATH"
export PATH="/opt/homebrew/opt/python@3.12/bin:$PATH"
# export PYTHONPATH=$(which python3)
alias python="python3"
alias pip="pip3"
# venv workflow enhances
export PYTHON="python3"
# alias act='. $(find . -name "activate" -type f -depth 3)'
# alias mkvenv="$PYTHON -m venv venv && . ./venv/bin/activate; [ -r 'requirements.txt' ] && pip install -r requirements.txt "
mkvenv() {
    $PYTHON -m venv venv &&
    ./venv/bin/python -m pip install --upgrade pip
}
_activate_venv() {
    local _activate=$(find . -name "activate" -type f -depth 3)
    if [[ $(wc -l <<< $_activate) -gt 1 ]]; then
        echo "multiple venvs found:\n$_activate"
        return 1
    fi
    if [[ -z $_activate ]]; then
        echo "no venv found"
        return 1
    fi
    . $_activate
    export PYTHONPATH=$(pwd)
}
alias act="_activate_venv"

# Go
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"

print256colors() {
    for i in {0..255} ; do
        printf "\x1b[48;5;%sm%3d\e[0m " "$i" "$i"
        if (( i == 15 )) || (( i > 15 )) && (( (i-15) % 6 == 0 )); then
            printf "\n";
        fi
    done
}

alias zshrc="vim ~/.zshrc"
alias vimrc="vim ~/.vimrc"
alias nvimrc="nvim ~/.config/nvim/init.vim"

replace() {
    _from=$1
    _to=$2
    echo "called with args from='$_from' to='$_to'"
    if [[ -z $_from ]]; then
        echo "usage: replace [FROM] [TO]"
        return
    fi
    echo "git grep '$_FROM'"
    echo "git grep done"
    if [[ -z $_to ]]; then
        echo "no [TO] arg, printing files"
        echo $(git grep $_from)
        return
    fi
    _files=$(git grep -l "$_from")
    echo "replacing '$_from' > '$_to'"
    echo $_files | xargs sed -i.tmp "s/$_from/$_to/g"
    echo "replacing done"
    echo "clean up"
    find . -name "*.tmp" -delete
    echo "clean up done"
}

# Poetry Aliases
alias p="poetry"

# tmux auto session
alias tmuxs="~/.tmux.sh"

# workflow
alias "%ml"="cd ~/code/moscowliuda-webinar && act; tmux rename-window '#moscowliuda'"
alias fuzz="nms"
# avito
alias "%dc"="cd ~/code/service-dataset-collector && act && tmux rename-window '#dc' && export PYTHONPATH='.'"
alias "%dcf"="cd ~/code/service-dataset-collector-frontend; tmux rename-window '#frontend'"
alias flint="avito fmt && avito lint"
alias astart="avito devenv start"
alias adebug="avito service debug"
alias arun="avito service run"
alias atest="avito service test --ci"
alias astop="avito devenv stop"
alias apurge="avito devenv stop --purge"
alias arestart="avito devenv stop && avito devenv start"

alias psql=pgcli

# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source <(fzf --zsh)
source ~/.avito_completion.sh
