# ----------------------
# Aliases
# ----------------------
# List
	# 
alias l='ls'
	# long human readable
alias ll='ls -lh'
	# long human readable recursive
alias llr='ls -lhR'
	# long human readable dotfiles
alias llh='ls -lah'
	# long human readable dotfiles recursive
alias llhr='ls -lahR'

# CD
alias cdh='cd ~'
alias cdr='cd /'
alias .1='cd ..'
alias .2='cd ../../'
alias .3='cd ../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../../'

# Source
alias brc='source ~/.bashrc'
alias brp='source ~/.bash_profile'

# Apache
alias apstart='sudo apachectl -k start'
alias apstop='sudo apachectl -k stop'
alias aprestart='sudo apachectl -k restart'

# Logs
# --- Apache
alias aplogrewrite='tail -f /private/var/log/apache2/rewrite_log.log'

# Generic Colouriser
# TODO  alias tparenth='colourify tparenth'
GRC=`which grc`
if [ "$TERM" != dumb ] && [ -n GRC ]
then
	alias colourify="$GRC -es --colour=auto"
	alias configure='colourify ./configure'
	alias diff='colourify diff'
	alias make='colourify make'
	alias gcc='colourify gcc'
	alias g++='colourify g++'
	alias as='colourify as'
	alias gas='colourify gas'
	alias ld='colourify ld'
	alias netstat='colourify netstat'
	alias ping='colourify ping'
	alias traceroute='colourify /usr/sbin/traceroute'
	alias tail='colourify tail'
	alias cap='colourify cap'
	alias ls='colourify ls'
fi