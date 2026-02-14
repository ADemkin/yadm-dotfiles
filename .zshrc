# # Prompt
# # Find and set branch name var if in git repository.
function format_git_branch() {
    _branch=$(git br)
    [[ $_branch != "" ]] && echo "%F{green}>%f $_branch" || echo ""
}

# Config for prompt. PS1 synonym.
# autoload -U colors && colors
setopt prompt_subst
export PROMPT='%n%F{red}@%f%m%F{red}:%f%? %* %~ $(format_git_branch)
%F{red}%#%f '

# hook that runs on cd command
chpwd() {
    for d in venv .venv; do
        if [[ -f "$d/bin/activate" ]]; then
            . "$d/bin/activate"
            if [[ -z $PYTHONPATH ]]; then
                export PYTHONPATH="$PWD"
            fi
            return
        fi
    done
}

# Basic options
setopt APPEND_HISTORY SHARE_HISTORY INC_APPEND_HISTORY HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE  # dont write cmd to hist if it start with space
setopt INTERACTIVE_COMMENTS
setopt GLOB_STAR_SHORT  # change **/*.py to **.py
setopt GLOB_DOTS
setopt EXTENDED_GLOB  # use ~ to ignore, ex: **.py*~*.pyc will ignore .pyc
setopt NO_NOMATCH
setopt AUTO_PUSHD PUSHD_IGNORE_DUPS  # use pushd when cd

# EMACS mode
bindkey -e
setopt EMACS
# Allow to edit command line in editor
autoload -U edit-command-line
zle -N edit-command-line
bindkey "^x^e" edit-command-line  # open editor with C-x C-e

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


#######################################################################
# Aliases
#######################################################################

# Git workflow
alias grup="git remote update"
alias grim="git rebase -i origin/main"
alias grm="git rebase origin/main"
alias grid="git rebase -i origin/dev"
alias grc="git rebase --continue"
alias gst="git status"
alias gg="git graph"
alias greset="git reset --hard"
alias gchom="git checkout origin/main"
alias gchod="git checkout origin/dev"
alias gchb="git checkout -b"

# More complex grep
GREP=$(which grep)
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
setopt AUTO_MENU
setopt AUTO_LIST
# zstyle ":completion:*:functions" ignored-patterns "_*"
# zstyle ":completion:*" matcher-list "" 'm:{a-z\-}={A-Z\_}' 'r:|?=** m:{a-z\-}={A-Z\_}'
# _mycomp () {
#     [ $CURRENT -eq 1 ] && _command_names || _files
# }
# zstyle ":completion:*" completer _mycomp _parameters
# autoload -U compinit ; compinit -d /tmp/.zcompdump
# zstyle ":completion:*:default" list-colors ""
# autoload -U complist

# My Completion
autoload -U compinit; compinit

# Highlighting
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]="fg=yellow"
ZSH_HIGHLIGHT_STYLES[globbing]="fg=magenta"
ZSH_HIGHLIGHT_STYLES[history-expansion]="fg=magenta"
ZSH_HIGHLIGHT_STYLES[commandseparator]="fg=red"
ZSH_HIGHLIGHT_STYLES[redirection]="fg=red"
ZSH_HIGHLIGHT_STYLES[assign]="fg=cyan"

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

# bat as manpager
export BAT_THEME="gruvbox-dark"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

cheat() {
    curl cheat.sh/$1
}

# Python
alias python="python3"
alias pip="pip3"
# venv workflow enhances
export PYTHON="python3"
mkvenv() {
    local python_version="$1"
    echo $python_version
    local python_name=$PYTHON
    if [[ $python_version ]]; then
        python_name="python$python_version"
    fi
    echo $python_name
    $python_name -m venv venv &&
    ./venv/bin/python -m pip install --upgrade pip
}
_activate_venv() {
    # get optional basepath
    local base="."
    if [[ -n $1 ]]; then
        base=$1
    fi
    # find activate script
    # first try to search in usual places
    local act=""
    for d in "$base/venv" "$base/.venv"; do
        if [[ -f "$d/bin/activate" ]]; then
            act="$d/bin/activate"
            break
        fi
    done
    # if not found - try to to use find
    if [[ -z $act ]]; then
        act=$(find "$base" -depth 3 -type f -name activate)
        if [[ $(wc -l <<< "$act") -gt 1 ]]; then
            echo "multiple venvs found:" >&2
            echo "$act" >&2
            return 1
        fi
    fi
    # final check
    if [[ -z $act ]]; then
        echo "no venv found" >&2
        return 1
    fi
    . "$act"
    # set PYTHONPATH
    if [[ -z $PYTHONPATH ]]; then
        export PYTHONPATH=$base
    fi
}
alias va="_activate_venv"

print256colors() {
    for i in {0..255} ; do
        printf "\x1b[48;5;%sm%3d\e[0m " "$i" "$i"
        if (( i == 15 )) || (( i > 15 )) && (( (i-15) % 6 == 0 )); then
            printf "\n";
        fi
    done
}

alias zshrc="nvim ~/.zshrc"
alias vimrc="vim ~/.vimrc"
alias nvimrc="cd ~/.config/nvim && nvim init.lua"

alias vimdiff="nvim -d"

replace() {
    local _from=$1
    local _to=$2
    echo "called with args from='$_from' to='$_to'"
    if [[ -z $_from ]]; then
        echo "usage: replace [FROM] [TO]"
        return
    fi
    echo "git grep '$_from'"
    if [[ -z $_to ]]; then
        echo "no [TO] arg, printing files"
        echo $(git grep $_from)
        return
    fi
    _files=$(git grep -l "$_from")
    echo "git grep done"
    echo "$_files"
    echo "replacing '$_from' > '$_to'"
    echo $_files | xargs sed -i.tmp "s/$_from/$_to/g"
    echo "replacing done"
    echo "clean up"
    find . -name "*.tmp" -delete
    echo "clean up done"
}

# Poetry Aliases
alias p="poetry"

# workflow
alias "%ml"="cd ~/code/moscowliuda-webinar-utils && tmux rename-window 'moscowliuda'"
alias "%mb"="cd ~/code/moscowliuda-backend && tmux rename-window 'moscowliuda-backend'"
alias "%md"="cd ~/code/moderation-detectors/ && tmux rename-window 'detectors'"
alias "%maas"="cd ~/code/maas-moderation/ && tmux rename-window 'maas'"
alias "%mig"="cd ~/code/moderation-input-gateway/ && tmux rename-window 'input-gateway'"
alias "%mid"="cd ~/code/moderation-io-dump/ && tmux rename-window 'io-dump'"

# Copilot
alias copilot=" gh copilot explain"

# fzf
source <(fzf --zsh)
bindkey '^f' fzf-file-widget
export FZF_DEFAULT_OPTS="--no-mouse"

# secrets
if [ -f ~/.secrets ]; then
    source ~/.secrets
fi

# completions for brew installed apps
# installed with docker, etc...
# source ~/.zsh-completion
source $(brew --prefix)/share/zsh/site-functions
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/antondemkin/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions
# Add Docker Desktop for Mac (docker)
export PATH="$PATH:/Applications/Docker.app/Contents/Resources/bin/"

# wb teleport
alias tsh17='TELEPORT_HOME=${HOME}/.tsh17 TELEPORT_PROXY=tp.rwb.ru:443 TELEPORT_CLUSTER=teleport-rwb /Applications/tsh.app/Contents/MacOS/tsh'
alias tshdm="tsh17 kube login k8s.moderation-dm && kubectl config set-context --current --namespace=moderation"
alias tshel="tsh17 kube login k8s.moderation-el && kubectl config set-context --current --namespace=moderation"
alias tshxs="tsh17 kube login k8s.moderation-xs && kubectl config set-context --current --namespace=moderation"
alias tshstage="tsh17 kube login k8s.tns-stage-el && kubectl config set-context --current --namespace=moderation"
alias tshlogin="tsh17 login --auth=passwordless --user=demkin.anton"
alias tshlogout="tsh17 logout --user=demkin.anton"

podlogs() {
    kubectl -n moderation logs $@
}


