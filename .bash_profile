# .bash_profile
#echo "PATH=$PATH"

if [[ $(uname -s) == 'Darwin' ]]; then
    export IS_MACOS=1
elif [[ $(uname -s) == 'Linux' ]]; then
    export IS_LINUX=1
fi

if [[ -x /opt/homebrew/bin/brew ]]; then
    # Setup homebrew environment
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# User specific environment and startup programs
for file in ~/.{bash_path,bash_prompt,exports,aliases,functions,extra}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
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

# Add tab completion for many Bash commands
# Enable programmable completion features. You don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile.

if which brew &> /dev/null && [ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]; then
    # Ensure existing Homebrew v1 completions continue to work
    export BASH_COMPLETION_COMPAT_DIR="$(brew --prefix)/etc/bash_completion.d"
    source "$(brew --prefix)/etc/profile.d/bash_completion.sh"
elif ! type _init_completion >/dev/null 2>&1; then
    if [ -f /etc/bash_completion ]; then
        # ubuntu
        source /etc/bash_completion
    elif [ -f /usr/share/bash-completion/bash_completion ]; then
        # rhel
        source /usr/share/bash-completion/bash_completion
    fi
fi

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh

if [[ -n $IS_MACOS ]]; then
    # Add tab completion for `defaults read|write NSGlobalDomain`
    # You could just use `-g` instead, but I like being explicit
    complete -W "NSGlobalDomain" defaults

    # Add `killall` tab completion for common apps
    complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall
fi

if [[ -n $IS_LINUX ]]; then
    export XDG_RUNTIME_DIR=/run/user/$(id -u)
fi

# Check for the 'keychain' command, if installed then use it to store SSH keys
# and set the environment variables for the SSH_AUTH_SOCK and SSH_AGENT_PID
# https://github.com/funtoo/keychain
# Debian & EL package 'keychain'
if command -v keychain > /dev/null; then
    keys=()
    for file in ~/.ssh/*; do
        if [[ -f "$file" && -f "$file.pub" ]]; then
            keys+=("$file")
        fi
    done
    eval "$(keychain --eval --quiet "${keys[@]}")"
fi
