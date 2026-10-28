# .bash_profile: executed by bash(1) for login shells.
# Everything lives in .bashrc.
[ -f ~/.trace.sh ] && . ~/.trace.sh && log_startup ${BASH_SOURCE[0]} enter

[ -f ~/.bashrc ] && . ~/.bashrc

[ -f ~/.trace.sh ] && . ~/.trace.sh && log_startup ${BASH_SOURCE[0]} exit
