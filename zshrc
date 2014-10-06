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

. ~/.dotfiles/z/z.sh
bindkey "^R" history-incremental-search-backward

###############
## Environment Variables
################
export HISTSIZE=500
export SAVEHIST=$HISTSIZE

###############
## Aliases
################

alias duh='du -h -d' # Human readable output
alias zshconfig='vim ~/.zshrc && source ~/.zshrc'
alias mcserver='CURRENTPATH=`pwd` && cd /srv/minecraft && java -Xmx4096M -Xms4069M -jar minecraft_server.jar nogui && cd $CURRENTPATH'
alias minecraft='java -Xmx4096M -Xms4096M -jar ~/Desktop/Minecraft.jar'
alias tree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"
alias vi=vim
alias p='ping -c4'
alias dd_status='kill -SIGUSR1 $(pidof dd)'
alias why='whence -fa'
alias subl=subl3

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
			*) echo "'$1' cannot be extracted via extract()" ;;
		esac
	else
		echo "'$1' is not a valid file"
	fi
}

function gi() {
	curl http://www.gitignore.io/api/$@ ;
}

function dcvpn() {
	sudo truecrypt -t -k "" -m ro ~/.dcvpn.tc /mnt/tcdcvpn
	CURRENTPATH=`pwd`
	cd /mnt/tcdcvpn
	sudo openvpn client.ovpn
	cd $CURRENTPATH
	sudo truecrypt -d ~/.dcvpn.tc
}

