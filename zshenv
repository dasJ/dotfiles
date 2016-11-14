#
# Executes commands at ZSH startup
#

# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ "$SHLVL" -eq 1 && ! -o LOGIN && -s "$HOME/.zprofile" ]]; then
	source "$HOME/.zprofile"
fi

export EDITOR='vim'
export VISUAL='vim'
export PAGER='vimpager'

path=(
	/usr/bin
	"$HOME/bin"
	"$HOME/.vim/plugged/vimpager"
	"$path"
)

export PATH
