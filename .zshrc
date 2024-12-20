# PATH
export PATH="/Users/$USER/.npm-global/bin/:$PATH"

# # Prompt
# # Find and set branch name var if in git repository.
function git_branch() {
    git br
}
function format_git_branch() {
    _branch=$(git br)
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
alias grib="git rebase -i origin/master"
alias grid="git rebase -i origin/dev"
alias gch="git checkout"
alias gst="git status"
alias gdiff="git diff"
alias gg="git graph"
alias gchom="git checkout origin/master"
alias gchod="git checkout origin/dev"

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
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
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
alias python="python3"
alias pip="pip3"
# venv workflow enhances
export PYTHON="python3"
mkvenv() {
    $PYTHON -m venv venv &&
    ./venv/bin/python -m pip install --upgrade pip
}
_activate_venv() {
    # get optional basepath
    local _basepath="."
    if [[ -n $1 ]]; then
        _basepath=$1
    fi
    # find activate script
    local _activate=$(find $_basepath -name "activate" -type f -depth 3)
    # case: multiple venvs found
    if [[ $(wc -l <<< $_activate) -gt 1 ]]; then
        echo "multiple venvs found:\n$_activate"
        return 1
    fi
    # case: no venv found
    if [[ -z $_activate ]]; then
        echo "no venv found"
        return 1
    fi
    . $_activate
    # set PYTHONPATH
    if [[ -z $PYTHONPATH ]]; then
        export PYTHONPATH=$_basepath
    fi
}
alias act="_activate_venv"
# auto activate venv from current path
# [[ -f ./venv/bin/activate ]] && act

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
    local _from=$1
    local _to=$2
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
alias "%ml"="cd ~/code/moscowliuda-webinar-utils && act; tmux rename-window 'moscowliuda'"
alias "%lsb"="cd ~/code/lionsoul-backend && act && tmux rename-window 'lsb'"

alias psql=pgcli

# fzf
fkill() {
    ps aux |\
    sed 1d |\
    fzf \
    --reverse \
    --preview='echo {}' \
    --preview-window=top:3:wrap \
    --border --border-label='kill (enter to kill, C-c to exit)' --border-label-pos=5 \
    --no-info |\
    awk '{print $2}' |\
    xargs kill -9
}

fadd() {
    git status --short | sed -e "s/^M /$(printf '\033[32m')M $(printf '\033[m')/" \
                             -e "s/^A /$(printf '\033[32m')S $(printf '\033[m')/" \
                             -e "s/^D /$(printf '\033[31m')D $(printf '\033[m')/" \
                             -e "s/^ M/$(printf '\033[33m')M $(printf '\033[m')/" \
    | fzf --multi --ansi --reverse --height=40 --border \
        --preview="(echo {} | grep -q 'Staged' && git diff --cached --color=always -- {-1} | delta) || git diff --color=always -- {-1} | delta" \
        --bind="a:toggle" \
        --header="Select files to stage (press enter to stage selected files)" \
        --prompt="Git files> " \
    | echo
}

# Copilot
alias copilot=" gh copilot explain"


# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source <(fzf --zsh)
bindkey '^f' fzf-file-widget


# secrets
if [ -f ~/.secrets ]; then
    source ~/.secrets
fi

# completions for brew installed apps
# installed with docker, etc...
source $(brew --prefix)/share/zsh/site-functions
