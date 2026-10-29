# .profile: read by sh/dash login shells and display managers (bash uses .bash_profile).
# Must stay POSIX sh: dash (Ubuntu/Mint), bash --posix (RHEL, macOS /bin/sh).
#   Mint Cinnamon: /usr/sbin/lightdm-session sources this at login, so GUI-app env goes here
#   (verified on Mint 21.3, X11). Wayland (Mint on Ubuntu 26.04, late 2026): not verified yet.
#   Ubuntu GNOME Wayland / RHEL GNOME: the session uses a login $SHELL -> .bash_profile instead.
#   macOS: not read at all (bash uses .bash_profile, zsh uses .zprofile).
# Keep this file and .bash_path in step for anything both need (cargo, nix).
[ -f ~/.trace.sh ] && . ~/.trace.sh && log_startup .profile enter

[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
[ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ] && . "$HOME/.nix-profile/etc/profile.d/nix.sh"

# Same order as .bash_path: last one listed ends up first in PATH.
for d in "$HOME/go/bin" "$HOME/.local/bin" "$HOME/bin"; do
    case ":$PATH:" in *":$d:"*) ;; *) [ -d "$d" ] && PATH="$d:$PATH" ;; esac
done
export PATH
unset d

[ -f ~/.trace.sh ] && . ~/.trace.sh && log_startup .profile exit
