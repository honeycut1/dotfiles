# ~/.bash_profile: read by bash login shells. Everything lives in .bashrc.
#
# Startup files are shared across Mint Cinnamon, RHEL 8, Ubuntu and macOS via yadm.
#   .bash_profile  login bash: sources .bashrc, nothing else
#   .bashrc        env (all shells) + interactive setup; sources .bash_local, .bash_path, .bash_aliases
#   .bash_path     PATH/MANPATH; must be idempotent (runs again in every nested shell)
#   .bash_local    untracked, per-host settings (USE_STARSHIP, START_KEYCHAIN, ...)
#   .profile       sh/dash and display managers only; bash never reads it (see below)
#   .trace.sh      log_startup -> ~/.startup-trace.log; use it to check the notes below
#
# Bash rules (all platforms):
#   login bash:            /etc/profile, then the FIRST of ~/.bash_profile, ~/.bash_login,
#                          ~/.profile. This file exists, so bash skips ~/.profile.
#   interactive non-login: ~/.bashrc only (plus /etc/bash.bashrc on Debian-family builds).
#   `ssh host cmd`:        non-interactive, but bash still reads ~/.bashrc. That's why
#                          .bashrc sets env before its interactive check.
#   tmux panes, `bash -l`: login shells, so this file runs again inside an existing env.
#
# Per platform:
#   RHEL 8   Terminal tabs are non-login. Bash doesn't read /etc/bashrc on its own, so
#            .bashrc sources it (it also runs /etc/profile.d/* for non-login shells).
#            /etc/skel ships .bash_profile + .bashrc. /bin/sh is bash.
#   Ubuntu   /etc/skel ships .profile (sources .bashrc) and no .bash_profile, so ours
#            overrides it. Bash reads /etc/bash.bashrc itself and there's no /etc/bashrc.
#            /bin/sh is dash. GNOME on Wayland starts the session through a login $SHELL,
#            so for bash users this file, not .profile, sets the GUI env.
#   Mint     Same Debian-family bash as Ubuntu: dash, /etc/bash.bashrc.
#            gnome-terminal opens non-login shells, WezTerm opens LOGIN shells (verified 21.3).
#   Cinnamon LightDM starts the session. /usr/sbin/lightdm-session sources ~/.profile (as sh)
#            and never runs a login bash, so ~/.profile sets the GUI-app env
#            (verified on Mint 21.3, X11). Wayland becomes the default in the Mint release
#            based on Ubuntu 26.04 (late 2026); not verified yet, check ~/.startup-trace.log.
#            ~/.config/environment.d/*.conf reaches systemd user services in both.
#   macOS    Terminal.app/iTerm2/WezTerm start a LOGIN shell for every window/tab. /etc/profile
#            runs path_helper, which puts inherited PATH entries behind /usr/bin (see
#            .bash_path), then sources /etc/bashrc. The default shell is zsh and
#            /bin/bash is 3.2. We use Homebrew bash 5.x (/opt/homebrew/bin/bash, added to
#            /etc/shells, then chsh). Homebrew bash doesn't read /etc/bashrc on its own.
#            GUI apps never see dotfile env (use launchctl setenv). /bin/sh is bash 3.2 in POSIX mode.
[ -f ~/.trace.sh ] && . ~/.trace.sh && log_startup ${BASH_SOURCE[0]} enter

[ -f ~/.bashrc ] && . ~/.bashrc

[ -f ~/.trace.sh ] && . ~/.trace.sh && log_startup ${BASH_SOURCE[0]} exit
