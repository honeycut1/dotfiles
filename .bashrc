#######################################################
# ${HOME}/.bashrc: executed by bash(1) for non-login shells.
#######################################################

[ -f ~/.trace.sh ] && . ~/.trace.sh && log_startup ${BASH_SOURCE[0]} enter
[ "${PS1-}" ] && source "${HOME}/.bash_profile";
