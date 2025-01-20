###############
## zsh options
###############

# cd options
setopt auto_pushd # cd behaves like pushd
setopt pushd_to_home # pushd with no arguments -> pushd $HOME
# Completion
setopt auto_param_keys # Be smarter when completing whithin parameters
setopt auto_param_slash # Add / after completed directories
setopt auto_remove_slash # When autocomplete adds a slash and you do as well, one will be removed
setopt complete_in_word # Tab completion in word
setopt menu_complete # Insert the first match immediately
setopt no_list_beep # No beep when completion list is displayed
# Globbing
setopt brace_ccl # Expand stuff like {0-9} {a-z}
setopt glob # Perform filename generation (globbing)
setopt mark_dirs # Append trailing / to all globbed directories
setopt nomatch # Warn when nothing matched
setopt rc_expand_param # foo=(a b c); foo${foo}bar -> fooabar foobbar foocbar
setopt rematch_pcre # =~ will use PCRE expressions
#setopt warn_create_global # Warn when creating a global parameter in a function (disabled with typeset -g). Useful for testing scripts but annoying in normal shell operation.
# History
setopt append_history # Append to history instead of replacing it
setopt hist_fcntl_lock # Use fcntl to lock history while writing
setopt hist_ignore_dups # Do not add to history if the same as previos command
setopt hist_ignore_space # Do not add to history if command contains a leading space
setopt hist_reduce_blanks # Remove superflous blanks
setopt share_history # One history for all shells
# IO
setopt correct # Try to correct selling of commands
setopt interactive_comments # Allow comments in interactive shells
setopt print_exit_value # Print exit value if $? != 0
setopt rm_star_silent # Do not warn when executing rm *
# Job control
setopt check_jobs # Remind user of remaining jobs when quitting
setopt long_list_jobs # List jobs in long format by default
# Scripts and functions
setopt function_arg_zero # Function name instead of zsh when using $0
# Prompt
setopt prompt_subst # Allow variables in prompt
