###############
## Completion configuration
###############

# Initialize completions with dump
compinit -i -d "$HOME/.cache/zsh/zcompdump-${SHORT_HOST}-${ZSH_VERSION}"

# Rehash with every completion
zstyle ':completion:*' rehash true

# Make completion case insensitive
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'

# Enable completion cache
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path "$HOME/.cache/zsh"

# Tabbable menu
zstyle ':completion:*' menu select

# Reorder completion tags
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories

# Parse known_hosts for hostnames
zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'

# Ignore some usernames
zstyle ':completion:*:*:*:users' ignored-patterns bin daemon mail ftp \
	uuidd dbus avahi systemd-journal-gateway systemd-timesyncd systemd-network \
	systemd-bus-proxy systemd-resolve systemd-journal-upload systemd-coredump \
	systemd-journal-remote

# Complete ignored stuff if there is nothing else
zstyle '*' single-ignored show

# ls colors
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
# ps colors
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;93=0=01'
# ps columns
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
