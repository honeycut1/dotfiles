

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias -- -="cd -"

alias l='lsd'
alias ll='l -l'

alias l.='ls -d .* --color=auto'
alias ls='ls -F --color=auto'
alias lsa='ls -aF --color=auto'
alias lsl='ls -l --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias h='history'

alias les='less -i'

alias d1='delta --file-decoration-style "ul ol" --file-style "yellow"'
alias d2='delta --file-decoration-style "ul ol" --file-style "yellow" --diff-highlight'

# Print each PATH entry on a separate line
alias path='echo -e ${PATH//:/\\n}'

# git stuff
alias gdiff='git diff --no-index'
alias gst='git status'
alias gl1s='git lg1s -30'
alias gl1ss='git lg1ss -30'
alias gl1sa='git lg1s -30 --all'
alias gl1ssa='git lg1ss -30 --all'
alias ga='gl1ssa'

gd() {
  local git_opts=""
  local delta_opts=""
  local parsing_delta=false

  # Parse arguments
  for arg in "$@"; do
    if [[ "$arg" == "--" ]]; then
      parsing_delta=true
      continue
    fi
    if [[ "$parsing_delta" == true ]]; then
      delta_opts="$delta_opts $arg"
    else
      git_opts="$git_opts $arg"
    fi
  done

  # Run the command
  git diff $git_opts | d2 $delta_opts
}


alias ackv='ack --ignore-dir=.venv'

alias xo='xdg-open'

alias sagent-start='eval "$(ssh-agent -s)"'

zimgitpush() { git add .; git commit -m "stuff"; git push $@; }

git-repos-cmd() {
  # Check if a command is provided
  if [ $# -eq 0 ]; then
    echo "Usage: git-repos-cmd <git-command> [args...]"
    return 1
  fi

  # Loop through all subdirectories
  for dir in */; do
    # Check if the directory is a Git repository
    if [ -d "$dir/.git" ]; then
      echo -e "\n----------------------------------------------------"
      echo "$(tput bold)Executing in $dir:$(tput sgr0)"
      # Navigate into the directory, run the command, and return to the original directory
      (cd "$dir" && git "$@")
    else
      echo -e "\n-------- $dir is not a Git repository."
    fi
  done
}

# svn
svn-log() { svn log $@ | sed '/^$/d' | sed 's/^------/\n------/'; }

# Update path with mvn, java, ant tools
tools-setup() { source ${HOME}/bin/add-paths.sh $@; }

alias conky-restart='killall conky -SIGUSR1'

### Open VS Code remote file or folder
rcode-file() { code --remote ssh-remote+${1} $2; }
rcode-dir()  { code --folder-uri vscode-remote://ssh-remote+${1}${2}; }

# print stuff
clp() { a2ps --medium=Letter -s1 -R --columns=1 --rows=2 --chars-per-line=132 "$@" -o - | lpr; }
plp() { a2ps --medium=Letter -s2 "$@" -o - | lpr; }


# zfs
# ----
zfslist() { zfs list -t all -o name,avail,used,usedsnap,usedds,usedrefreserv,usedchild,reservation,quota,refreservation,refquota -r "$@"; }
zfsls1() { zfs list -t snapshot -o name,creation -s creation "$@"; }
zfsls2() { zfs list -o name,avail,used,refer,written,usedsnap -r -t all "$@"; }

# Misc
# -----
# Add an "alert" alias for long running commands.
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# netns aliases
alias boomaga-netns-killdbus="ps \$(ip netns pids ns1) | grep '[d]bus-launch' | awk '{print \$1;}' | xargs kill"

# run-in-netns <namespace> <cmd> <parms> ...
run-in-netns () 
{
    if [ "$#" -lt 2 ]; then
       echo "Usage: ${FUNCNAME[0]} <netnns> <cmd> [parms] ..."
       return 0
    fi
        
    local _ns=$1;
    shift;
    if ! test -e "/var/run/netns/${_ns}" >/dev/null 2>&1; then
        echo "Invalid netns: $_ns"
        return 1
    fi

    sudo ip netns exec "$_ns" sudo -u "${USER}" "$@"
}

vns() { run-in-netns ns1 $@; }
alias sns=vns
