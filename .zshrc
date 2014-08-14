export ZSH=$HOME/.oh-my-zsh

###############
# Environment Variables
###############

export HISTSIZE=500
export SAVEHIST=$HISTSIZE
export EDITOR='vim'
export LANG=en_US.UTF-8

###############
# ZSH Config
###############

ZSH_THEME="jonathan"
CASE_SENSITIVE="true" # Case sensitive search
ENABLE_CORRECTION="true" # Autororrection (did you mean ...?)
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true" # Untracked files aren'T dirty
plugins=(git git-extras)

source $HOME/.path

source $ZSH/oh-my-zsh.sh

###############
# Aliases
###############

unalias sl # Because I love the sl
alias duh='du -h -d' # Human readable output
alias pacman=yaourt

###############
# Functions
###############

function extract () {
	if [ -f $1 ] ; then
		case $1 in
			*.tar.bz2) tar xjf $1 ;;
			*.tar.gz)  tar xzf $1 ;;
			*.bz2)     bunzip2 $1 ;;
			*.rar)     unrar x $1 ;;
			*.gz)      gunzip $1 ;;
			*.tar)     tar xf $1 ;;
			*.tbz2)    tar xjf $1 ;;
			*.tgz)     tar xzf $1 ;;
			*.zip)     unzip $1 ;;
			*.Z)       uncompress $1 ;;
			*) echo "'$1' cannot be extracted via extract()" ;;
		esac
	else
		echo "'$1' is not a valid file"
	fi
}

function gi() {
	curl http://www.gitignore.io/api/$@ ;
}

function windows() {
qemu-system-x86_64 -enable-kvm -M q35 -m 2084 -cpu host \
-smp 6,sockets=1,cores=6,threads=1 \
-bios /usr/share/qemu/bios.bin -vga none \
-device ioh3420,bus=pcie.0,addr=1c.0,multifunction=on,port=1,chassis=1,id=root.1 \
-device vfio-pci,host=04:00.0,bus=root.1,addr=00.0,multifunction=on,x-vga=on \
-device vfio-pci,host=04:00.1,bus=root.1,addr=00.1 \
-drive file=/root/windows.img,id=disk,format=raw -device ide-hd,bus=ide.0,drive=disk
}
