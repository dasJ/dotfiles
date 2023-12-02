###############
## Aliases
###############

# ls
alias ls='ls -h --color --group-directories-first -F'
alias ll='ls -lF'
alias la='ll -a'

# rm
alias rm='rm -I' # Less intrusive interactive mode

# pager
alias more="$PAGER"
alias less="$PAGER"
alias zless="$PAGER"

# find
alias fd='find . -type d -name'
alias ff='find . -type f -name'

# Directories
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias -- -='cd -'
alias 1='-'
for i in {2..9}; do
	alias $i="cd -$i"
done

# Command suffixes
alias -g H='| head'
alias -g T='| tail'
alias -g G='| grep'
alias -g NUL='&>/dev/null'

# task
alias in='task add +in'
alias tctx='task context'

# tmux
alias tmux='tmux -2' # Colors
alias outertmux='tmux -L "$tmuxname"'

# Misc. stuff
alias sudo='sudo ' # Use aliases with sudo
alias vi=nvim
alias vim=nvim
alias why='whence -fa'
alias fuck='sudo $(fc -nl -1)'
alias dd='dd status=progress'
alias yay='echo "\\(^o^)/"'
alias lsblk='lsblk -o NAME,MAJ:MIN,SIZE,TYPE,UUID,LABEL,FSTYPE,MOUNTPOINT'
alias userctl='systemctl --user'
alias :q='exit'
alias privip="ip a | grep 'inet ' | awk -F' ' '{print $2}'"
alias pubip='dig +short myip.opendns.com @resolver1.opendns.com'
alias path='echo -e ${PATH//:/\\n}'
alias va=vagrant
alias ip='ip -c'
alias deploy=/var/src/helsinki/0scripts/deploy

# Includes
source "$zshincl/git-aliases.zsh"
source "$zshincl/grep.zsh"
