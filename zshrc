#
# Executes commands at the start of an interactive session.
#

# Source antigen
export ADOTDIR=$HOME/.dotfiles/antigen
source $HOME/.dotfiles/antigen/antigen/antigen.zsh

antigen use oh-my-zsh
antigen bundle common-aliases
antigen bundle fasd
antigen bundle git
antigen bundle golang
antigen bundle systemd
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-completions src
antigen bundle Tarrasch/zsh-autoenv
antigen theme dasJ/zsh-theme themes/janne
antigen apply

###############
## Variables
###############
export HISTSIZE=500
export SAVEHIST=$HISTSIZE
export LSCOLORS="gxfxcxexbxegedabagacad" # http://geoff.greer.fm/lscolors/
export LS_COLORS="di=36;40:ln=35;40:so=32;40:pi=34;40:ex=31;40:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:"
export EDITOR=vim
export SYSTEMD_EDITOR=$EDITOR
export REPORTTIME=5
export LESSHISTFILE=/dev/null
export USE_CCACHE=1
export ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

###############
## zsh options
###############
setopt nolistbeep # No beep when completion list is displayed
setopt share_history # One history for all shells
setopt auto_remove_slash # When autocomplete adds a slash and you do as well, one will be removed
setopt auto_cd # Allow omitting of cd
setopt function_arg_zero # Function name instead of zsh when using $0
setopt complete_in_word # Tab completion in word
setopt braceccl # Expand stuff like {0-9} {a-z}
bindkey "^R" history-incremental-search-backward # Ctrl+R for backwards search
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS} # ls colors
zstyle ':completion:*' rehash true

###############
## Aliases
################
alias zpool='sudo zpool'
alias ls='ls -h --color --group-directories-first'
alias ll='ls -lF'
alias la='ll -a'
alias duh='du -h' # Human readable output
alias rcp='rsync -avP'
alias rmv='rcp --remove-source-files'
alias vi=vim
alias p='ping -c4'
alias why='whence -fa'
alias subl=subl3
alias tmux='tmux -2' # Color support
alias fuck='sudo $(fc -nl -1)'
alias dd='dd status=progress'
alias slapdebug='/usr/bin/slapd -u ldap -g ldap -h "ldapi:// ldap://[::1] ldaps://" -d -1'
alias tmuxsess='eval $(tmux switch-client \; show-environment -s)'
alias yay='echo "\\(^o^)/"'
unalias sl 2> /dev/null # SL
alias sl='sl -a'
unalias 'G' # Why?
# Math stuff
alias bin2dec='cbase 2 10'
alias bin2hex='cbase 2 16'
alias bin2oct='cbase 2 8'
alias dec2bin='cbase 10 2'
alias dec2hex='cbase 10 16'
alias dec2oct='cbase 10 8'
alias hex2bin='cbase 16 2'
alias hex2dec='cbase 16 10'
alias hex2oct='cbase 16 8'
alias oct2bin='cbase 8 2'
alias oct2dec='cbase 8 10'
alias oct2hex='cbase 8 16'

if ! hash "tree" 2>/dev/null; then
	alias tree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"
fi
###############
## Functions
################

function extract () {
	if [ -f $1 ] ; then
		case $1 in
			*.tar.bz2) tar xjf $1 ;;
			*.tar.gz) tar xzf $1 ;;
			*.tar.xz) tar xJf $1 ;;
			*.bz2) bunzip2 $1 ;;
			*.rar) unrar x $1 ;;
			*.gz) gunzip $1 ;;
			*.tar) tar xf $1 ;;
			*.tbz2) tar xjf $1 ;;
			*.tgz) tar xzf $1 ;;
			*.zip) unzip $1 ;;
			*.Z) uncompress $1 ;;
			*.war) unzip $1 ;;
			*.7z) 7z x $1 ;;
			*.wim) 7z x $1 ;;
			*.lzma) unlzma $1 ;;
			*.xz) unxz $1 ;;
			*.exe) cabextract $1 ;;
			*) echo "'$1' cannot be extracted via extract()" ;;
		esac
	else
		echo "'$1' is not a valid file"
	fi
}

function cbase() {
	echo "obase=$2;ibase=$1;$3" | bc
}

mkcd() {
	[[ $1 ]] || return 0
	[[ -d $1 ]] || mkdir -vp "$1"
	[[ -d $1 ]] && builtin cd "$1"
}

kopt() {
	[[ $1 ]] || return 1
	zgrep -i "${1}" /proc/config.gz
}

deps() {
	local bin dir
	if [[ -f "$1" ]]; then
		bin=$1
	elif bin=$(type -P "$1"); then
		:
	else
		# maybe its a lib?
		[[ -f /usr/lib/$1 ]] && bin=/usr/lib/$1
	fi
	if [[ $bin && $1 != "$bin" ]]; then
		printf '%s => %s\n\n' "$1" "$bin"
	fi
	if [[ -z $bin ]]; then
		echo "error: binary not found: $1"
		return 1
	fi
	objdump -p "$bin" | awk '/NEEDED/ { print $2 }'
}

###############
## Try to launch tmux
################
if hash tmux 2>/dev/null; then
	# Works because shell automatically trims
	trim() { return $1; }
	# Outer tmux for mango
	if [ "`hostname`" = "mango" ] && [[ -z "$TMUX" ]]; then
		tmux start-server
		session_id="outer-`date +%Y%m%d%H%M%S`"
		tmux new-session -d -s "$session_id" "journalctl -f"
		tmux set-option -t "$session_id" status off
		tmux split-window -t "$session_id" -v -p 90 "`getent passwd $USER | cut -d: -f7`; tmux kill-session -t $session_id"
		tmux set-option -t "$session_id" -s prefix M-y
		tmux set-option -t "$session_id" -s mouse off
		tmux set-option -t "$session_id" -s pane-border-fg colour235
		tmux set-option -t "$session_id" -s pane-active-border-fg colour235
		#tmux unbind -t "$session_id" C-a
		exec tmux attach-session -t "$session_id"
		#tmux kill-session -t "$session_id" 2>/dev/null
		exit
	fi
	# Unset TMUX if we just spawned the outer session and want to spawn the inner session
	session="`tmux display-message -p '#S'`"
	if [ "`hostname`" = "mango" ] && [ "${session:0:5}" = "outer" ]; then
		unset TMUX
	fi
	# TODO Kill old sessions
	# Create new base session
	if [[ `tmux ls | grep "^base" | wc -l` == 0 ]]; then
		tmux new-session -s base
		exit
	else
		# Base session exists, attach to it
		# Don't spawn tmux inside the inner session
		if [[ -z "$TMUX" ]]; then
			session_id=`date +%Y%m%d%H%M%S`
			tmux new-session -d -t base -s $session_id
			exec tmux attach-session -t $session_id
			#tmux kill-session -t $session_id
			exit
		fi
	fi
fi

