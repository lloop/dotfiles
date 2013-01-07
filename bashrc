# ----------------------
# Paths
# ----------------------
# MySQL
export PATH="/usr/local/mysql/bin:$PATH"
# Additional binary folders
export PATH=$PATH:/Users/lloop/bin
# Macports
export PATH=/opt/local/bin:/opt/local/sbin:$PATH

# ----------------------
# Default Compiler
# ----------------------
# From LLVM to gcc
# export CC=/usr/bin/gcc-4.2
export CC=gcc
# Set default compile to 64bit ( error --- get "-bash: export: `x86_64”': not a valid identifier" on startup )
# export ARCHFLAGS=”-arch x86_64”

# Lack of ssh-askpass in /usr/libexec/ in OSX LION fix ( for netbeansV7.1 ssh key connection to SVN repo )
# export SSH_ASKPASS="/usr/libexec/ssh-askpass"

# ----------------------
# Prompt
# ----------------------
# user, host, working directory basename
export PS1="\u@\H:\W > "

# ----------------------
# Aliases/Functions
# ----------------------
if [ -f ~/.bash_aliases ]; then
. ~/.bash_aliases
fi

if [ -f ~/.bash_functions ]; then
. ~/.bash_functions
fi

# ----------------------
# No File Overwrite (turn off 'set +o noclobber')
# (temp turn off 'ls /etc >| output.txt' - Use '>|' operator to force the file to be overwritten)
# ----------------------
set -o noclobber