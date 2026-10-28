# .profile: read by sh/dash login shells and display managers (bash uses .bash_profile).
[ -f ~/.trace.sh ] && . ~/.trace.sh && log_startup .profile enter

[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
[ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ] && . "$HOME/.nix-profile/etc/profile.d/nix.sh"

# Disable caps lock key (X11 only)
[ -n "$DISPLAY" ] && command -v setxkbmap >/dev/null && setxkbmap -option ctrl:nocaps

[ -f ~/.trace.sh ] && . ~/.trace.sh && log_startup .profile exit
