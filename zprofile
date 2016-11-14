#
# Executes commands at login pre-zshrc.
#

#
# Editors
#

export EDITOR='vim'
export VISUAL='vim'
export PAGER='vimpager'

#
# Language
#

if [[ -z "$LANG" ]]; then
	export LANG='en_US.UTF-8'
fi

#
# Paths
#

# Ensure path arrays do not contain duplicates.
typeset -gU cdpath fpath mailpath path

# Set the the list of directories that cd searches.
# cdpath=(
#   $cdpath
# )

# Set the list of directories that Zsh searches for programs.
path=(
	/usr/bin
	$HOME/bin
	$HOME/.vim/plugged/vimpager
	$path
)

#
# Less
#

# Set the default Less options.
# Mouse-wheel scrolling has been disabled by -X (disable screen clearing).
# Remove -X and -F (exit if the content fits on one screen) to enable it.
export LESS='-g -i -M -R -S -w -z-4'

#
# Temporary Files
#

if [[ ! -d "$TMPDIR" ]]; then
	export TMPDIR="/tmp/$USER"
	mkdir -p -m 700 "$TMPDIR"
fi

TMPPREFIX="${TMPDIR%/}/zsh"
if [[ ! -d "$TMPPREFIX" ]]; then
	mkdir -p "$TMPPREFIX"
fi

