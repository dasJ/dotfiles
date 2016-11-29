###############
## Key configuration
###############

# vi keybindings
bindkey -v

# No lag when switching vi modes (0.1 secs)
KEYTIMEOUT=1

# Configure zle
if [[ -n ${terminfo[smkx]} ]] && [[ -n ${terminfo[rmkx]} ]]; then
	function zle-line-init() {
		echoti smkx
	}
	function zle-line-finish() {
		echoti rmkx
	}
	zle -N zle-line-init
	zle -N zle-line-finish
fi

# Arrow up for history
if [[ "${terminfo[kpp]}" != "" ]]; then
	bindkey "${terminfo[kpp]}" up-line-or-history
fi

# Arrow down for history
if [[ "${terminfo[knp]}" != "" ]]; then
	bindkey "${terminfo[knp]}" down-line-or-history
fi

# Arrow up with non-empty buffer
if [[ "${terminfo[kcuu1]}" != "" ]]; then
	autoload -U up-line-or-beginning-search
	zle -N up-line-or-beginning-search
	bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search
fi

# Arrow down with non-empty buffer
if [[ "${terminfo[kcud1]}" != "" ]]; then
	autoload -U down-line-or-beginning-search
	zle -N down-line-or-beginning-search
	bindkey "${terminfo[kcud1]}" down-line-or-beginning-search
fi

# Home key
if [[ "${terminfo[khome]}" != "" ]]; then
	bindkey "${terminfo[khome]}" beginning-of-line
fi

# End key
if [[ "${terminfo[kend]}" != "" ]]; then
	bindkey "${terminfo[kend]}"  end-of-line
fi

# Space does history expansion
bindkey ' ' magic-space

# Ctrl+Arrow to move by word
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

# Move through completion backwards with Shift+Tab
if [[ "${terminfo[kcbt]}" != "" ]]; then
	bindkey "${terminfo[kcbt]}" reverse-menu-complete
fi

# Backspace to delete backwards
bindkey '^?' backward-delete-char

# Delete to delete forward
if [[ "${terminfo[kdch1]}" != "" ]]; then
	bindkey "${terminfo[kdch1]}" delete-char
else
	bindkey "^[[3~" delete-char
	bindkey "^[3;5~" delete-char
	bindkey "\e[3~" delete-char
fi

# Ctrl+R for backward search
bindkey "^r" history-incremental-search-backward

# v command for opening in $EDITOR
bindkey -M vicmd v edit-command-line
