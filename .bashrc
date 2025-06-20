
# ~/.bashrc: executed by bash(1) for non-login shells.


# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000
HISTTIMEFORMAT="%F %T "

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# Set default Editor
export VISUAL=vim
export EDITOR="$VISUAL"

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize


# make less more friendly for non-text input files, see lesspipe(1)
if which lesspipe &>/dev/null; then
    eval $(lesspipe)
elif which lesspipe.sh &>/dev/null; then
    eval $(lesspipe.sh)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm|xterm-color|*-256color) color_prompt=yes ;;
esac

if [ "$color_prompt" = yes ]; then
    if [[ ${EUID} == 0 ]] ; then
        PS1="\[\e[01;31m\]\h\[\e[01;34m\] \W \$\[\e[00m\] "
    else
        PS1="\[\e[01;32m\]\u@\h\[\e[00m\] \[\e[01;34m\]\w \$\[\e[00m\] "
    fi
else
    PS1='\u@\h \w \$ '
fi
unset color_prompt

# enable color support of ls and also add handy aliases
if which dircolors &>/dev/null; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)" 

    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
