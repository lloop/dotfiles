# ----------------------
# Sourcing
# ----------------------
# Source .bashrc because .bash_profile loads first 
# .bash_profile is for interactive login shells
# .bashrc is for non-interactive login shells
if [ -f ~/.bashrc ]; then
source ~/.bashrc
fi

# ----------------------
# Colors
# ----------------------
# Tell ls to be colourful
# export CLICOLOR=1
# export LSCOLORS=dxcxaxdxbxexexaxxxAxAx

# Tell grep to highlight matches
# export GREP_OPTIONS='--color=auto'

