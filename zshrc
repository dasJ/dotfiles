#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...

setopt nolistbeep # No beep when completion list is displayed
setopt share_history # One history for all shells
setopt auto_remove_slash # When autocomplete adds a slash and you do as well, one will be removed
setopt auto_cd # Allow omitting of cd
setopt function_arg_zero # Function name instead of zsh when using $0
setopt complete_in_word # Tab completion in word
setopt braceccl # Expand stuff like {0-9} {a-z}

# Source Z
. ~/.dotfiles/z/z.sh
# Useful ZSH Stuff
bindkey "^R" history-incremental-search-backward
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

###############
## Aliases
################

alias duh='du -h -d' # Human readable output
alias zshconfig='vim ~/.zshrc && source ~/.zshrc'
alias mcserver='CURRENTPATH=`pwd` && cd /srv/minecraft && java -Xmx4096M -Xms4069M -jar minecraft_server.jar nogui && cd $CURRENTPATH'
alias minecraft='java -Xmx4096M -Xms4096M -jar ~/Downloads/Minecraft.jar'
alias vi=vim
alias p='ping -c4'
alias dd_status='kill -SIGUSR1 $(pidof dd)'
alias why='whence -fa'
alias subl=subl3
alias tmux='tmux -2'
if ! hash "find" 2>/dev/null; then
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
			*.bz2) bunzip2 $1 ;;
			*.rar) unrar x $1 ;;
			*.gz) gunzip $1 ;;
			*.tar) tar xf $1 ;;
			*.tbz2) tar xjf $1 ;;
			*.tgz) tar xzf $1 ;;
			*.zip) unzip $1 ;;
			*.Z) uncompress $1 ;;
			*.war) unzip $1 ;;
			*) echo "'$1' cannot be extracted via extract()" ;;
		esac
	else
		echo "'$1' is not a valid file"
	fi
}

function gi() {
	curl https://www.gitignore.io/api/$@ ;
}

function dcvpn() {
	sudo truecrypt -t -k "" -m ro ~/.dcvpn.tc /mnt/tcdcvpn
	CURRENTPATH=`pwd`
	cd /mnt/tcdcvpn
	sudo openvpn client.ovpn
	cd $CURRENTPATH
	sudo truecrypt -d ~/.dcvpn.tc
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

# Parts of this are taken from http://mutelight.org/practical-tmux
if which tmux >/dev/null 2>&1; then
	# Works because bash automatically trims
	trim() { echo $1; }
	# Check if tmux session exists
	tmux_nb=$(trim `tmux ls | grep "^base" | wc -l`)
	if [[ "$tmux_nb" == "0" ]]; then
		tmux new-session -s base
		exit
	else
		# Make sure  we don't start tmux in tmux
		if [[ -z "$TMUX" ]]; then
			# Kill defunct sessions first
			old_sessions=$(tmux ls 2>/dev/null | egrep "^[0-9]{14}.*[0-9]+\)$" | cut -f 1 -d:)
			for old_session_id in $old_sessions; do
				tmux kill-session -t $old_session_id
			done
			# Session is is date and time to prevent conflict
			session_id=`date +%Y%m%d%H%M%S`
			# Create session and link to old one
			tmux new-session -d -t base -s $session_id
			# Attach to it
			tmux attach-session -t $session_id
			# When we detach, kill it
			tmux kill-session -t $session_id
			exit
		fi
	fi
fi

