# .bash_profile
#echo "PATH=$PATH"
[ -f ~/.trace.sh ] && . ~/.trace.sh && log_startup ${BASH_SOURCE[0]} enter

if [[ $(uname -s) == 'Darwin' ]]; then
    export IS_MACOS=1
elif [[ $(uname -s) == 'Linux' ]]; then
    export IS_LINUX=1
fi

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# Append to the Bash history file, rather than overwriting it
shopt -s histappend

# Autocorrect typos in path names when using `cd`
shopt -s cdspell

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
    shopt -s "$option" 2> /dev/null
done

if [[ -n $IS_LINUX ]]; then
    export XDG_RUNTIME_DIR=/run/user/$(id -u)
fi

# Load the bash_local setup script.
# This file can be used for host specific settings.
# Typically envvars to control features such as starship
# being enabled or not.
if [ -r ${HOME}/.bash_local ]; then
    source ${HOME}/.bash_local
fi

##############################################
# Homebrew
if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

##############################################
# NIX
if [ -e ${HOME}/.nix-profile/etc/profile.d/nix.sh ]; then
    source ${HOME}/.nix-profile/etc/profile.d/nix.sh
fi

##############################################
# Load the path setup script.
if [ -r ${HOME}/.bash_path ]; then
    source ${HOME}/.bash_path
fi

##############################################
# Add tab completion for many Bash commands
# Enable programmable completion features. You don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile.
if [ -n "$HOMEBREW_PREFIX" ] && [ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]; then
    # Ensure existing Homebrew v1 completions continue to work
    export BASH_COMPLETION_COMPAT_DIR="${HOMEBREW_PREFIX}/etc/bash_completion.d"
    source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
elif ! type _init_completion >/dev/null 2>&1; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        source /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        source  /etc/bash_completion
    fi
fi

# Add tab completion for SSH hostnames based on ${HOME}/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ${HOME}/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh

if [[ -n $IS_MACOS ]]; then
    # Add tab completion for `defaults read|write NSGlobalDomain`
    # You could just use `-g` instead, but I like being explicit
    complete -W "NSGlobalDomain" defaults

    # Add `killall` tab completion for common apps
    complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall
fi

####################################################
# Check for the 'keychain' command, if installed then use it to store SSH keys
# and set the environment variables for the SSH_AUTH_SOCK and SSH_AGENT_PID
# https://github.com/funtoo/keychain
# Debian & EL package 'keychain'
if command -v keychain > /dev/null; then
    keys=()
    for file in ${HOME}/.ssh/*; do
        if [[ -f "$file" && -f "$file.pub" ]]; then
            keys+=("$file")
        fi
    done
    eval "$(keychain --eval --quiet "${keys[@]}")"
fi

####################################################
# If not running interactively then return here
####################################################
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
        # We are root, set prompt to red
        PS1="\[\e[01;31m\]\h\[\e[01;34m\] \W \$\[\e[00m\] "
    elif [[ -n $IS_LINUX && -n "$(ip netns id)" ]]; then
	# We are in a net namespace, set UID in prompt to purple 
        PS1="\[\e[01;35m\]\u@\h\[\e[00m\] \[\e[01;34m\]\w \$\[\e[00m\] "
    else
        # Set it green
        PS1="\[\e[01;32m\]\u@\h\[\e[00m\] \[\e[01;34m\]\w \$\[\e[00m\] "
    fi
else
    PS1='\u@\h \w \$ '
fi
unset color_prompt

# enable color support of ls and also add handy aliases
if which dircolors &>/dev/null; then
    test -r ${HOME}/.dircolors && eval "$(dircolors -b ${HOME}/.dircolors)" || eval "$(dircolors -b)" 
fi

# Alias definitions.
if [ -f ${HOME}/.bash_aliases ]; then
    . ${HOME}/.bash_aliases
fi

# https://github.com/starship/starship
# You can set USE_STARSHIP=1 in ${HOME}/.bash_local
if [ -n "$USE_STARSHIP" ]; then
    if command -v starship > /dev/null; then
        eval "$(starship init bash)"
    fi
fi

[ -f ~/.trace.sh ] && . ~/.trace.sh && log_startup ${BASH_SOURCE[0]} exit

