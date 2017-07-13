###############
## antibody sourcing and bundles
###############

export ANTIBODY_HOME="$zshconf/antibody/repos"
source <($zshconf/../scripts/antibody init)
antibody bundle < "$zshconf/antibody/plugins.txt"
# Afterwards to enforce it's the last thing
eval $(antibody bundle dasJ/zsh-theme)
