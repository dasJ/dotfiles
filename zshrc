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

###############
## Variables
###############
export HISTSIZE=500
export SAVEHIST=$HISTSIZE
export LSCOLORS="gxfxcxexbxegedabagacad" # http://geoff.greer.fm/lscolors/
export LS_COLORS="di=36;40:ln=35;40:so=32;40:pi=34;40:ex=31;40:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:"
export EDITOR=vim
export SYSTEMD_EDITOR=$EDITOR

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
# Fasd
eval "$(fasd --init zsh-hook posix-alias zsh-ccomp zsh-wcomp zsh-ccomp-install zsh-wcomp-install)"

###############
## Aliases
################
alias duh='du -h' # Human readable output
alias rcp='rsync -avP'
alias rmv='rcp --remove-source-files'
alias vi=vim
alias p='ping -c4'
alias why='whence -fa'
alias subl=subl3
alias tmux='tmux -2' # Color support
alias fuck='sudo $(fc -nl -1)'
alias dri='ncat -U /var/run/docker.sock' # Docker remote interface
unalias sl # SL
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

a2ensite() {
	[[ $1 ]] || return 1
	sudo ln -sv /etc/httpd/conf/sites-available/$1 /etc/httpd/conf/sites-enabled/$1
	sudo apachectl graceful
}

a2disite() {
	[[ $1 ]] || return 1
	sudo rm -v /etc/httpd/conf/sites-enabled/$1
	sudo apachectl graceful
}


###############
## Try to launch tmux
################

# Parts of this are taken from http://mutelight.org/practical-tmux
if hash tmux 2>/dev/null; then
	# Works because shell automatically trims
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


