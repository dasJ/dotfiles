###############
## grep configuration
###############

GREP_OPTIONS=''
# Enable grep colors
if echo | grep --color=auto '' &>/dev/null; then
	GREP_OPTIONS+=' --color=auto'
fi
# Do not grep VCS directories
if echo | grep --exclude-dir=.cvs '' &>/dev/null; then
	GREP_OPTIONS+=' --exclude-dir={.bzr,.CVS,.git,.hg,.svn}'
elif echo | grep --exclude=.cvs '' &>/dev/null; then
	GREP_OPTIONS+=' --exclude={.bzr,.CVS,.git,.hg,.svn}'
fi
alias grep="grep${GREP_OPTIONS}"
alias fgrep="fgrep${GREP_OPTIONS}"
alias egrep="egrep${GREP_OPTIONS}"
unset GREP_OPTIONS
