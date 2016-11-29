###############
## Extract anything
###############

extract() {
	if [ -f "$1" ]; then
		case $1 in
			*.tar.bz2) tar xjf "$1" ;;
			*.tar.gz) tar xzf "$1" ;;
			*.tar.xz) tar xJf "$1" ;;
			*.bz2) bunzip2 "$1" ;;
			*.rar) unrar x "$1" ;;
			*.gz) gunzip "$1" ;;
			*.tar) tar xf "$1" ;;
			*.tbz2) tar xjf "$1" ;;
			*.tgz) tar xzf "$1" ;;
			*.zip) unzip "$1" ;;
			*.7z) 7z x "$1" ;;
			*.wim) 7z x "$1" ;;
			*.lzma) unlzma "$1" ;;
			*.xz) unxz "$1" ;;
			*.exe) cabextract "$1" ;;
			*) echo "'$1' can has an unknown format" ;;
		esac
	else
		echo "'$1' is not a valid file"
	fi
}

compctl -g '*.tar.bz2' '*.tar.gz' '*.tar.xz' '*.bz2' '*.rar' '*.gz' '*.tar' '*.tbz2' '*.tgz' '*.zip' '*.7z' '*.wim' '*.lzma' '*.xz' + -g '*(-/)' extract
