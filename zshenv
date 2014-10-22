#
# Defines environment variables.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ "$SHLVL" -eq 1 && ! -o LOGIN && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprofile"
fi

# For apache directory studio
GTK2_RC_FILES=/usr/share/themes/Raleigh/gtk-2.0/gtkrc

export HISTSIZE=500
export SAVEHIST=$HISTSIZE
export LSCOLORS="gxfxcxexbxegedabagacad" # http://geoff.greer.fm/lscolors/
export LS_COLORS="di=36;40:ln=35;40:so=32;40:pi=34;40:ex=31;40:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:"

