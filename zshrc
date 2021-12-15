
[ -f /opt/dev/dev.sh ] && source /opt/dev/dev.sh
if [ -e /Users/paulellislinton/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/paulellislinton/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

[[ -f /opt/dev/sh/chruby/chruby.sh ]] && type chruby >/dev/null 2>&1 || chruby () { source /opt/dev/sh/chruby/chruby.sh; chruby "$@"; }
#source $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh

[[ -x /usr/local/bin/brew ]] && eval $(/usr/local/bin/brew shellenv)
