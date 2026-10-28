# .profile: read by sh/dash login shells and display managers (bash uses .bash_profile).
[ -f ~/.trace.sh ] && . ~/.trace.sh && log_startup .profile enter

[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
[ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ] && . "$HOME/.nix-profile/etc/profile.d/nix.sh"

[ -f ~/.trace.sh ] && . ~/.trace.sh && log_startup .profile exit
