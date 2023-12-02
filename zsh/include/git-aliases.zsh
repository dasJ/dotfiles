###############
# git aliases
###############

export GIT_SSH_COMMAND='@DOTFILES@/scripts/import-ssh; ssh -o VisualHostKey=no'

# git add
alias ga='git add'
alias gaa='ga --all'
alias gai='ga -i'

# git commit
alias gc='git commit -v'
alias gc!='gc --amend'

# git checkout
alias gco='git checkout'

# git branch
alias gb='git branch'

# git clone
alias gcl='git clone --recursive'
alias gcl1='gcl --depth 1'

# git diff
alias gd='git diff'
alias gdc='git diff --cached'

# git push/pull
alias gl='git pull'
alias gp='git push'
alias gp!='gp --force'

# git status
alias gst='git status'

# git log
alias glo='git log'
