# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# set tab width
tabs -4

# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# set history length
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# If set, an argument to the cd builtin command that is not a directory is assumed
# to be the name of a variable whose value is the directory to change to.
shopt -s cdable_vars

# If set, minor errors in the spelling of a directory component in a cd command will
# be corrected. The errors checked for are transposed characters, a missing character,
# and a character too many. If a correction is found, the corrected path is printed,
# and the command proceeds. This option is only used by interactive shells.
shopt -s cdspell

# add git branch info and time to prompt
PS1='$(printf "\[\e[1;31m\]%*s\r%s" $(( COLUMNS )) \
    "[$(git branch 2>/dev/null | grep '^*' | sed s/..//)] $(date +%H:%M:%S)" \
    "\[\e[1;32m\]\u@\h \[\e[1;34m\]\w\n\[\e[1;33m\]\$\[\e[0m\]")'

# add current directory to PATH
PATH=.:$PATH

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias gdiff='git diff --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ld='ls -l | grep "^d"'

# some handy aliases
alias ..='cd ..'
alias c='clear'
alias x='exit'
alias catn='cat -n'
alias grepn='grep -n'

# select terminal emulator for X
if [ -e /usr/share/terminfo/x/xterm-256color ]; then
    export TERM='xterm-256color'
else
    export TERM='xterm-color'
fi

# configs based on OS
case $(uname) in
    # MAC OS X
    'Darwin')
        export TERM="xterm-256color"
        export CLICOLOR=cons25
        # use coordiff if exists
        [ -x $(which colordiff) ] && alias diff='colordiff -u' || alias diff='diff -u'
        ;;
    'Linux')
        # use xclip to fake pbcopy & pbpaste commands, to use it make sure xclip is installed
        alias pbcopy='xclip -selection clipboard'
        alias pbpaste='xclip -selection clipboard -o'
        ;;
esac

#
# some handy self-defined functions
#

# toggle executability
function cx() {
    op=+ && [ -x $1 ] && op=-
    chmod ${op}x $@
}

# man with color
function man() {
    env \
        LESS_TERMCAP_mb=$(printf "\e[1;31m") \
        LESS_TERMCAP_md=$(printf "\e[1;31m") \
        LESS_TERMCAP_me=$(printf "\e[0m") \
        LESS_TERMCAP_se=$(printf "\e[0m") \
        LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
        LESS_TERMCAP_ue=$(printf "\e[0m") \
        LESS_TERMCAP_us=$(printf "\e[1;32m") \
        man "$@"
}

# display ip
function showip() {
    ip=$(ifconfig eth0 | awk '/inet/ { print $2 } ' | sed -e s/addr://)
    echo ${ip:-"Not connected"}
}

# run a command n times
function repeat() {
    n=$1; shift;
    
    while ((n--)); do
        eval "$@";
    done
}
