LS_COLORS=''

#LS_COLORS="${LS_COLORS}:lc="         # Left of color sequence
#LS_COLORS="${LS_COLORS}:cc="         # Right of color sequence
#LS_COLORS="${LS_COLORS}:ec="         # End color (replaces lc+no+rc)
#LS_COLORS="${LS_COLORS}:rs="         # Reset to normal colors
LS_COLORS="${LS_COLORS}:no=00;37"     # Normal color
LS_COLORS="${LS_COLORS}:fi=00;37"     # Files
LS_COLORS="${LS_COLORS}:di=00;36"     # Directories
LS_COLORS="${LS_COLORS}:ln=00;35"     # Symlinks
LS_COLORS="${LS_COLORS}:pi=01;33"     # Pipes
LS_COLORS="${LS_COLORS}:so=01;32"     # Sockets
LS_COLORS="${LS_COLORS}:bd=01;35"     # Block devices
LS_COLORS="${LS_COLORS}:cd=01;37"     # Character devices
LS_COLORS="${LS_COLORS}:mi=00;31"     # Missing file
LS_COLORS="${LS_COLORS}:or=01;30"     # Orphaned symlinks
LS_COLORS="${LS_COLORS}:ex=00;31"     # Executable files
LS_COLORS="${LS_COLORS}:do=01;32"     # Doors. Uses the same style as sockets
LS_COLORS="${LS_COLORS}:su=00;37;41"  # Files with setuid
LS_COLORS="${LS_COLORS}:sg=00;37;45"  # Files with setgid
LS_COLORS="${LS_COLORS}:st=00;37;44"  # Sticky files
LS_COLORS="${LS_COLORS}:ow=00;36;41"  # Directory writable by others
LS_COLORS="${LS_COLORS}:tw=00;36;44"  # Directory writable by others and sticky
LS_COLORS="${LS_COLORS}:ca=00;31;46"  # Has capabilities
LS_COLORS="${LS_COLORS}:mh="          # Has multiple hardlinks
#LS_COLORS="${LS_COLORS}:cl="         # Clear to end of line

export LS_COLORS
