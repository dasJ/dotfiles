#/usr/bin/bash -o nounset
# This script helps me to remember what to install
#

###
# Configuration
###

# name|graphical?|test|testparam
software=(
	"SECTION|Basic things"
	"zsh|no|command|zsh"
	"git|no|command|git"
	"pacaur|no|command|pacaur"
	"htop|no|command|htop"
	"curl|no|command|curl"
	"sudo|no|command|sudo"
	"systemd|no|command|systemctl"
	"coreutils|no|command|cat"
	"util-linux|no|command|lsblk"
	"gawk|no|command|awk"
	"iptuils|no|command|ip"
	"binutils|no|command|objdump"
	"gpg|no|command|gpg"

	"SECTION|vim"
	"vim|no|command|vim"
	"ctags|no|command|ctags"
	"pandoc|no|command|pandoc"

	"SECTION|Alias targets from zshrc"
	"sl|no|file|/usr/bin/sl"
	"binutils|no|command|objdump"
	"bc|no|command|bc"
	"minicom|no|command|minicom"
	"zfs|no|command|zfs"
	"rsync|no|command|rsync"
	"tree|no|command|tree"
	"ssh-agent|no|command|ssh-agent"

	"SECTION|tmux"
	"tmux|no|command|tmux"
	"fpp|no|command|fpp"
	"vlock|no|command|vlock"

	"SECTION|Archive extractors"
	"tar|no|command|tar"
	"bzip2|no|command|bunzip2"
	"unrar|no|command|unrar"
	"gzip|no|command|gunzip"
	"unzip|no|command|unzip"
	"p7zip|no|command|7z"
	"xz|no|command|unlzma"
	"cabextract|no|command|cabextract"

	"SECTION|Graphical stuff"
	"st|yes|command|st"
	"Anonymous Pro font|yes|exec|[ ! `fc-list "Anonymous Pro" | wc -l` -eq 0 ]"
	"numix theme|yes|file|/usr/share/themes/Numix/index.theme"
)


###
# Colors
###
_colors="$(tput colors 2>/dev/null)"
if (( _colors > 0 )) && tput setaf 0 &>/dev/null; then
	_color_none="$(tput sgr0)"
	_color_bold="$(tput bold)"
	_color_green="${_color_bold}$(tput setaf 2)"
	_color_yellow="${_color_bold}$(tput setaf 3)"
	_color_red="${_color_bold}$(tput setaf 1)"
fi

###
# Main
###
for sw in "${software[@]}"; do
	# Parse this software
	prettyname="`echo "${sw}" | awk -F '|' '{ print $1 }'`"
	isgraphical="`echo "${sw}" | awk -F '|' '{ print $2 }'`"
	# Headings
	if [ "${prettyname}" = "SECTION" ]; then
		echo "${_color_green}==>${_color_none} ${_color_bold}${isgraphical}${_color_none}"
		continue
	fi
	checktype="`echo "${sw}" | awk -F '|' '{ print $3 }'`"
	checkarg="`echo "${sw}" | awk -F '|' '{ print $4 }'`"
	# Print a nice message
	msgsuffix=''
	test "${isgraphical}" == 'yes' && msgsuffix="${msgsuffix} (graphical)"
	echo -ne "    [ ${_color_bold}....${_color_none} ] Checking for ${_color_bold}${prettyname}${_color_none}${msgsuffix}"
	# Ignore if not graphical
	if [ -f "$(readlink -f $(dirname "$0"))/nographical" ]; then
		if [ "${isgraphical}" == 'yes' ]; then
			echo -ne "\r    [ ${_color_yellow}skip${_color_none}\v\r"
			continue
		fi
	fi
	# Perform the actual check
	okay=0
	case "${checktype}" in
		'command')
			hash "${checkarg}" &>/dev/null
			okay="${?}"
			;;
		'file')
			test -f "${checkarg}"
			okay="${?}"
			;;
		'exec')
			${checkarg} &>/dev/null
			okay="${?}"
			;;
		*)
			okay=255
	esac
	# Process check result
	if [ "${okay}" -eq 0 ]; then
		echo -ne "\r    [ ${_color_green}okay${_color_none}\v\r"
	else
		echo -ne "\r    [ ${_color_red}miss${_color_none}\v\r"
	fi
done
