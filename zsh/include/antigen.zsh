###############
## antigen sourcing and bundles
###############

export ADOTDIR="$zshconf/antigen"
source "$ADOTDIR/antigen/antigen.zsh"

# Bundles
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-completions src
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle kennethreitz/autoenv

# Theme
antigen theme dasJ/zsh-theme themes/janne

# Let's go
antigen apply
