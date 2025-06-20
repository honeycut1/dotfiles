

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias -- -="cd -"

alias l='lsd'
alias ll='l -l'
alias ls='ls -F --color=auto'
alias lsa='ls -aF --color=auto'
alias lsl='ls -l --color=auto'
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

alias gl1s='git lg1'
alias gl1sa='git lg1 --all'


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
function svn-log { svn log $@ | sed '/^$/d' | sed 's/^------/\n------/'; }

# Update path with mvn, java, ant tools
function tools-setup { source ${HOME}/bin/add-paths.sh $@; }

alias sshstart='eval "$(ssh-agent -s)"'

# zfs
# ----
function zfslist { zfs list -t all -o name,avail,used,usedsnap,usedds,usedrefreserv,usedchild,reservation,quota,refreservation,refquota -r "$@"; }



