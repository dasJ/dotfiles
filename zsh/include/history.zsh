if hash atuin >/dev/null 2>&1; then
	eval "$(atuin init zsh --disable-up-arrow)"
elif [ -d /run/current-system/sw/share/fzf ]; then
	. /run/current-system/sw/share/fzf/key-bindings.zsh
	. /run/current-system/sw/share/fzf/completion.zsh
fi

# History file
HISTFILE=~/.zsh_history
# Size of history
HISTSIZE=1000
SAVEHIST="$HISTSIZE"
