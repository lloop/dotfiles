# ---------------------- 
# Functions
# ---------------------- 

# ------------ List all the Bash Functions on this page
function list_functions() {
    echo "________________________"
    echo "Local APE server";
    echo "  ape                   --- Launch aped PID";
    echo "  apekill               --- Kill aped PID";
    echo "  aperestart            --- Restart aped PID";
    echo "________________________"
    echo "Capistrano deploys";
    echo "  capawp                --- Wordpress Upgrade";
    echo "                              capwp [site] [stage] [task]";
    echo "                              E.G. capwp mp prod rollbk";
    echo "                              Defaults: capawp ** stag deploy";
    echo "  capa                  --- Content deploy";
    echo "                              capa [site] [stages] [task]";
    echo "                              E.G. capa mp prod deploy";
    echo "                                   capa mp - rollbk";
    echo "                                   capa mp prod";
    echo "                                   capa mp";
    echo "                              Defaults: capa ** stag deploy";
    echo "________________________"
    echo "MP3 Management";
    echo "  rinse_it              --- All the MP3 conditioning functions in one";
    echo "    directory_titles    --- Condition directory titles (Remove spaces and space-dash-space)";
	echo "    unlock_flags        --- Unlock files that are locked with the user immutable flag";
    echo "    upper_titles        --- Change all the first letters at the word beginnings to uppercase";
    echo "    replace_numb_spaces --- Replace spaces with underscores and fix track numbering (##title or ##.title)";
    echo "    repair_extensions   --- Find files without the extension. Repair or log";
    echo "    pull_ableton        --- Pull Ableton analysis files into new folder";
    echo "    log_odd_formats     --- Log odd formats into audio folder and other folder";
    echo "    remove_camelcase    --- Replace camelCase with under_score";
    echo "  fix_all_caps          --- Fix titles for files that have all capital letters in the title";
    echo "  tags_to_filename      --- Take the tag info for Title and Track_Number and concat and assign a filename";
    echo "  album_folders         --- Read the tags for albums and create folders for each album. Move the songs into the album folders";
    echo "  add_mp3_ext           --- Add the mp3 extension to all files in folder";
    echo "  treprem               --- Title replace or remove";
    echo "                              treprem [flag_for_force(-f)] [target_text] [replacement_text]"
    echo "                              Defaults: treprem _ ** _"
    echo "  tparenth              --- Dialog for treatment of parenthesis";
    echo "  tcomma                --- UNFINISHED - Dialog for treatment of commas";
    echo "________________________"
}



# ------------ Local APE server
#
# Launch aped PID 
function ape() {
	local conf="--cfg";
	local path="/Library/WebServer/Documents/APE_Server/bin/ape.conf";
	sudo /Library/WebServer/Documents/APE_Server/bin/aped "$conf" "$path" ;
}

# Kill aped PID	
function apekill() {
	pid=$(ps aux | grep -v grep | grep 'aped' | awk '{print $2}');
	sudo kill $pid;
}

# Restart aped PID
function aperestart() {
	pid=$(ps aux | grep -v grep | grep 'aped' | awk '{print $2}');
	sudo kill $pid;
	sleep 2
	local conf="--cfg";
	local path="/Library/WebServer/Documents/APE_Server/bin/ape.conf";
	sudo /Library/WebServer/Documents/APE_Server/bin/aped "$conf" "$path" ;
}

# ------------ Capistrano deploys
#
# Wordpress Upgrade
#	capwp [site] [stage] [task]
#	E.G. capwp mp prod rollbk
#	Defaults: capawp ** stag deploy
function capawp() {
	local pwd=`pwd`;
	local site="$1";
	local stages="$2";
	# marliespanciera, lloop, lloopwp, sonephon, four_five_six
	# mp,              lp,    lpwp,    sp,       ffs 
	if [ -z "$site" ]
	then
		exit "Must enter a site - mp, lp, lpwp, sp, ffs"
	fi
	case "$stages" in
		"stag")
			stages="_stag";;
		"prod")
			stages="_prod";;
		*)
			stages="_stag";;
	esac
	case "$task" in
		"deploy")
			task="deploy";;
		"rollbk")
			task="deploy:rollback";;
		*)
			task="deploy";;
	esac
	local arg="wp_up_"$site$stages;
	echo "$arg";
	cd "/Users/lloop/NetBeansProjects/Capistrano_Deployments/WP_Upgrade_Deployment/";
	cap $arg $task;
	cd "$pwd";
}

# Content deploy
#	capa [site] [stages] [task]
#	E.G. capa mp prod deploy OR
#		 capa mp - rollbk OR
#		 capa mp prod
#		 capa mp
#	Defaults: capa ** stag deploy
function capa() {
	local pwd=`pwd`;
	local path;
	local site="$1";
	local stages="$2";
	local task="$3";
	# marliespanciera, lloop, lloopwp, sonephon, four_five_six
	case "$site" in
		"mp")
			path="/Users/lloop/NetBeansProjects/Capistrano_Deployments/MarliesPanciera_Deployment/";;
		"lp")
			path="/Users/lloop/NetBeansProjects/Capistrano_Deployments/Lloop_Site_Deployment/";;
		"lpwp")
			path="/Users/lloop/NetBeansProjects/Capistrano_Deployments/Lloop_WP-Content_Deployment/";;
		"sp")
			path="/Users/lloop/NetBeansProjects/Capistrano_Deployments/Sonephon_Deployment/";;
		"ffs")
			path="/Users/lloop/NetBeansProjects/Capistrano_Deployments/Four_Five_Six_Deployment_dreamhost/";;
		*)
			exit "improper first variable";;
	esac
	case "$stages" in
		"stag")
			stages="_stag";;
		"prod")
			stages="_prod";;
		*)
			stages="_stag";;
	esac
	case "$task" in
		"deploy")
			task="deploy";;
		"rollbk")
			task="deploy:rollback";;
		*)
			task="deploy";;
	esac		
	local arg=$site$stages;
	cd "$path";
	cap "$arg" "$task";
	cd "$pwd";
}

# ------------ MP3 Management
#
# All the MP3 conditioning functions in one
function rinse_it() {
	# Select directory titles that are all uppercase.
	# Replace the space-comma-space with a dash
	# Replace a space with a dash
	directory_titles;
	# Unlock files that are locked with the user immutable flag
	unlock_flags;
	# In file and directory titles, change all lowercase first letters at the word beginnings to uppercase 
	upper_titles;
	# Find files without the file extension at the end of the name
	# Detect the file type and add the extension
	repair_extensions
	# In file and directory titles, replace all the space-dash-space combinations with only a dash 
	# Replace all the word-comma-space combinations with only a comma 
	# Replace all the track_number problems like ##title or #.title with a number-dash-title
	# Replace remaining spaces with underscores
	replace_numb_spaces;
	# Change camelCase to word_word
	remove_camelcase;
	# Pull Ableton files
	pull_ableton;
	# Find odd format files (m4a, oga, ogg, flac ...) from the working directory recursively
	# Extensions are read from "/Users/lloop/.audio_extensions".
	# Log the files with odd extensions into new text file "!_ODD_FILE_FORMATS.txt"
	log_odd_formats;
}

# Select directory titles that are all uppercase. 
# Replace comma, space, space-comma, space-comma-space, and comma-space with a dash
# !! Requires GNU Find (not OSX standard.Macports)
function directory_titles() {
	gfind -P . -depth -type d -regextype posix-extended -regex "^.*(\b[[:upper:]]+\b)([[:space:]]*,?[[:space:]]*\b[[:upper:]]*\b)+$" -execdir rename "s/\s*(,|\s)+/-/g" "{}" \;
}

# Unlock files that are locked with the user immutable flag
function unlock_flags() {
	chflags -R nouchg . ;
}

# Change all the first letters at the word beginnings to uppercase 
# from the working directory recursively
# Do not change first letter of file extensions, or after apostrophes
# "\342\200\231" and "\342\200\233" are single quotes in unicode
# "\047" is an apostrophe in unicade
function upper_titles() {
	gfind . -depth -regextype posix-extended -regex ".*\<[[:lower:]][^mp3].*" -execdir rename -f 's/(?<![\.|\342\200\231|\047])(\b|_)([a-z])/uc("$&")/ge' "{}" \; 
	#gfind . -depth -regextype posix-extended -regex ".*[[:lower:]][^mp3].*" -execdir rename -f 's/(?<![\.|\342\200\231|\047])(\b|_)([a-z])/uc("$&")/ge' "{}" \; 
	#gfind  . -depth -regextype posix-extended -regex ".*[[:lower:]][^mp3].*" ;
}

# In file and directory titles, replace all the space-dash-space combinations with only a dash.
# Replace all the word-comma-space combinations with only a comma.
# Replace remaining spaces with underscores.
function replace_numb_spaces() {
	# Find all the files that have a space before the extension and remove the space
	find . -depth -name "* .mp3" -execdir rename "s/\s\.mp3/\.mp3/" "{}" \;
	# Replace all the space-dash-space combinations with only a dash 
 	find . -depth -name "* - *" -execdir rename "s/\s*-\s*/-/g" "{}" \;
 	# Replace all files with single_number-dot-title or single_number-underscore-title with padded_number-dash-title
 	find -E . -depth -type f -regex "^[[:digit:]](\.|_).*" -execdir rename 's/^(\d)(.|_)?/0$1-/' "{}" \;
	# Replace all the track_number-dot-space-title with track_number-dash-title
	# Or, track_number-dot-title with track_number-dash-title
	# Or, track_number-title with track_number-dash-title
	# but not a track_number against .mp3, .aif, or .wav (in find -not)
	# and not a full year date (4 digits - in rename sub) 
	# TODO Posix regex could return a graphics file with number-dot-extension
	find -E . -depth \( -regex "^.*[[:digit:]]{2}\.?[[:space:]]?[[:alnum:]]+.*" -not -regex "^.*[[:digit:]]{2}\.(mp3|aif|wav)" \) -execdir rename 's/(?<![\d])((\d{2})\.?\s?-?)(?!\d)/$2-/' "{}" \;
	# Replace all the word-comma-space combinations with only a comma 
 	find . -depth -name "*, *" -execdir rename "s/,\s+/,/g" "{}" \;
	# Replace remaining spaces with underscores
 	find . -depth -name "* *" -execdir rename 's/\s/_/g' "{}" \;
}

# Find files with no file extension at the end of the name
# Detect the file type and add the extension
# Log files with no extension that show errors in detection
function repair_extensions() {
	local wd=`pwd`;
	touch "$wd"/!_FILES_NO_EXTENS_TYPE_ERRORS.txt;
	# Requires "osxutils". Macports
	setlabel Red "$wd"/!_FILES_NO_EXTENS_TYPE_ERRORS.txt;
	find . -depth -type f ! -name "*.*" -print0 | 
		while read -d $'\0' fil
		do
			file --brief --no-buffer "$fil" | cut -d : -f 2 |
				while read line
				do
					info=$(echo "$line" | cut -d , -f 1,2);
					case "$info" in
						" MPEG ADTS, layer III")
							#echo "GOOD";
							mv -i "$fil" "$fil.mp3"
							echo "Added extension to : $fil";
							;;
						*)
							# Requires "osxutils". Macports
							# setlabel Red "$fil";
							# remove leading whitespace characters
							fil="${fil#"${fil%%[![:space:]]*}"}" 
							# remove trailing whitespace characters
    						fil="${fil%"${fil##*[![:space:]]}"}" 
							fileinfo="File:$fil TypeInfo:$info";
							echo "$fileinfo" >> "$wd"/!_FILES_NO_EXTENS_TYPE_ERRORS.txt;
							#echo "NOT GOOD -- $info";
							echo "Filetype error on : $fil";
							;;
					esac
				done
		done
}

function temp() {
# 	find .  -name "*.png"
	local number=1;
	find .  -name "*.png" -print0 | 
		while read -d $'\0' fil
		do
#			echo $fil;
			rename "s/.*/default_$number\.png/" "$fil";
# 			mv -i "$fil" "$fil.mp3"
			number=$(( $number + 1 ));
		done
}

# Find the Ableton Live .asd files from the working directory recursively
# Move them to a new folder named "Pulled_ableton_files" created
# in the working directory
function pull_ableton() {
	local wd=`pwd`;
	mkdir "$wd"/!_PULLED_ABLETON_FILES/;
	# Requires "osxutils". Macports
	setlabel Red "$wd"/!_PULLED_ABLETON_FILES/;
	find . -depth -name "*.asd" -execdir mv -i {} "$wd/!_PULLED_ABLETON_FILES/{}" \;
}

# Find odd format files (m4a, oga, ogg, flac ...) from the working directory recursively
# Audio extensions are read from "/Users/lloop/.audio_extensions".
# Log the files with matching audio extensions into new text file "!_ODD_AUDIO_FORMATS.txt"
# Log the rest into "!_ODD_FILE_FORMATS.txt"
# TODO add a filter for graphic files for artwork
function log_odd_formats() {
 	local wd=`pwd`;
 	touch "$wd/!_ODD_AUDIO_FORMATS.txt";
 	touch "$wd/!_ODD_FILE_FORMATS.txt";
	# Requires "osxutils". Macports
	setlabel Red "$wd/!_ODD_AUDIO_FORMATS.txt";
	setlabel Red "$wd/!_ODD_FILE_FORMATS.txt";
	# Find files that have extensions ( exclude mp3, aif(f)?, wav, and asd)
	find . -depth -type f -name "*.*" | perl -nle 'print if /^.*\.(?!mp3|aif(f)?|wav|asd)\w*$/' | while read file
	do
		# file with ext
		local basenam="${file##*/}"; 
		# ext (greedy version)
		local ext=".${basenam##*.}";
		local file_excludes="!_FILES_NO_EXTENS_TYPE_ERRORS.txt !_ODD_AUDIO_FORMATS.txt .DS_Store";
		local extension_excludes=".asd .pdf"
		local directory_excludes="!_ODD_FILE_FORMATS !_PULLED_ABLETON_FILES";
		if grep --quiet --fixed-strings "$ext" /Users/lloop/.audio_extensions ;
		then
		local abc="";
			echo "$file" >> "$wd"/!_ODD_AUDIO_FORMATS.txt;
		else
			if [[ ! $(echo "$file_excludes" | grep "$basenam") ]] && [[ ! $(echo "$directory_excludes" | grep "$file") ]] && [[ ! $(echo "$extension_excludes" | grep "$ext") ]];
 			then
				echo "$file" >> "$wd"/!_ODD_FILE_FORMATS.txt;
 			fi
		fi
	done 
}

# Find titles with upper-lower-upper. Not dotfiles
# Change camelCase to word_word
# TODO Letters following an apostraphe are getting capitalized (I.E. ./James_Bond-06-Casino_Royale/06-SirJames’STripToFindMata.mp3)
# "\342\200\231" and "\342\200\233" are single quotes in unicode
# "\047" is an apostrophe in unicode
function remove_camelcase() {
	find -E . -depth -type f -regex "^.*([[:upper:]])(([[:lower:]]+)([[:upper:]])).*" -not -name ".*" | perl -nle 'chomp; $f=$_; s{(?<!,|-|_|/|\d|[A-Z]|[\342\200\231|\047])([A-Z][^A-Z])}{_\1}g; print qq{mv "$f" "$_" \n}' | sh; 
}

# NOT IN RINSE
#
# Fix titles for files that have all capital letters in the title
function fix_all_caps() {
	find . -name "*" -not -name ".DS_Store" -execdir rename -f  "s/([A-Z])([A-Z]+_?)/\$1\L\$2/g" "{}"  \;
	# this one turns all lowers to capital-lower
	# gfind . -depth -regextype posix-extended -regex ".*\<[[:lower:]][^mp3].*" -execdir rename -f 's/(?<![\.|\342\200\231|\047])\b([a-z])/uc("$&")/ge' "{}" \; 
}

# Take the tag info for "Title" and "Track Number" and assemble and assign a filename
function tags_to_filename() {
	for files in $(find . -depth 1 -type f -name "*" -not -name ".DS_Store" )
	do
		local tags=$( id3v2 -l "$files" );
		local titl=$( echo "$tags" | grep -Eh 'TIT2' | awk -F": " '{ print $2 }' );
		declare -a numb=( $( echo "$tags" | grep -Eh 'TRCK' | awk -F": " '{ print $2 }' | tr '/' ' ' ) );
		if [ -z "$titl" ] || [ -z "$numb" ]; # Will return true if a variable is unset.
		then
			echo "$files - Needs proper id3v2 tags for Tile and Track_Number";
		else
			if [[ ${numb[1]} -gt 99 ]]
			then
				# Only good when track amount is less then 1000 (which is pretty much always)
				local padnumb=$(printf "%03d" ${numb[0]});
			else 
				local padnumb=$(printf "%02d" ${numb[0]});
			fi
			local newtitl=$(echo "$titl" | tr " " "_" );
			mv "$files" "./$padnumb-$newtitl.mp3";
		fi
	done;
}

# Read the tags for albums and create folders for each album. Move the songs into the album folders.
function album_folders() {
	for files in $(find . -type f -name "*.mp3" )
	do
		local tags=$( id3v2 -l "$files" );
		local alb=$( echo "$tags" | grep -Eh 'TALB' | awk -F": " '{ print $2 }' );
		if [ -z "$alb" ]; # Will return true if a variable is unset.
		then
			echo "$files - Needs proper id3v2 tags for Album";
		else
			if [ -d "$alb" ]; 
			then
    			mv -i "./$files" "./$alb/$files";
    		else
    			mkdir "./$alb";
    			mv -i "./$files" "./$alb/$files";
			fi
		fi
	done
}

# Add the mp3 extension to all files in folder
function add_mp3_ext() {
	find . -type f -name "*" -not -name "*.*" -execdir rename -f "s/(\w+)$/\$1\.mp3/" "{}"  \;
}

# Title replace or remove
# Removes target text if parameter two is empty
# treprem [force_flag(-f)] [target_text] [replacement_text]"
#	Defaults: treprem "_" ** ""
# Parenthesis need to be escaped "\(\)" and in quotes.
# Odd ascii characters need to be copied directly from the file title in finder.
function treprem() {
		if [[ $1 == "-f" ]]
		then
			local targtext="$2";
			local reptext="${3:-}";
			find -E . -depth -name "*$targtext*" -execdir rename -f "s/$targtext/$reptext/" "{}" \;
		else
			local targtext="$1";
			local reptext="${2:-}";
			find -E . -depth -name "*$targtext*" -execdir rename "s/$targtext/$reptext/" "{}" \;
		fi
}

# Find all titles containing parenthesis
# Prompt for options to replace, delete, mark, or skip
# TODO write so command can be called from another directory I.E. "directory/directory/tparenth"
function tparenth() {
	ifssave=IFS
	IFS="$(printf '\n\t')"
	local PS3='What to do? '
	# Do find first so that file count can be echoed
	local exp=$(find . -depth -name "*(*)*");
	# For an array, ${#array[*]} and ${#array[@]} give the number of elements in the array. 
	local count=0
	for file in $exp; 
	do
		let "count+=1"
	done
	echo "FILECOUNT:$count"
	for parenth in $exp
	do 
		echo "File : $parenth";
		select choice in \
			"Skip" \
			"Mark" \
			"Delete" \
			"Delete with preceding" \
			"Remove parenthesis" \
			"Replace enclosed text" \
			"Replace whole title" \
			"quit"
		do
			case $choice in
				"Skip") 
					echo "Skipped" 
					break
					;;
				"Mark") 
					rename 's/\)/)->->->/' "$parenth";
					echo "$parenth";
					break
					;;
				"Delete") 
					rename 's/\(.*\)//' "$parenth";
					echo "$parenth";
					break
					;;
				"Delete with preceding") 
					rename 's/.\(.*\)//' "$parenth"; 
					echo "$parenth";
					break
					;;
				"Remove parenthesis") 
					rename 's/\((.*)\b\)/$1/' "$parenth"; 
					echo "$parenth";
					break
					;;
				"Replace enclosed text") 
					echo "Replace with? : " 
					read replacement
					if [ -z $replacement ] 
					then
						echo "empty string"
					else
						rename "s/\(.*\)/\($replacement\)/" "$parenth";
					fi
					echo "$parenth";
					break
					;;
				"Replace whole title")
					echo "Replace with? (file extension is preserved) : " 
					read replacement
					if [ -z $replacement ] 
					then
						echo "empty string"
					else
						# path 
						local pathdir="${parenth%/*}";
						# file with ext
						local basen="${parenth##*/}"; 
						# if file has extension
						#echo "EXT: ${basen#*.}"
						if [ "${basen#*.}" =~ .*\.[A-Za-z1-9]+$ ]
						then
							# ext
							local ext=".${basen#*.}";
						else
							local ext="";
						fi
						echo mv -i "$parenth" "$pathdir/$replacement$ext";
					fi
					echo "$parenth";
					break
					;;
				"quit") 
					echo "bye" 
					break 2
					;;
			esac
		done
	done
	IFS=$ifssave;
}

# Find all titles containing commas
# Prompt for options to replace, move, mark, or skip
# TODO Unfinished
function tcomma() {
	ifssave=IFS
	IFS="$(printf '\n\t')"
	local PS3='What to do? '
	# Do find first so that file count can be echoed
	# ???? find . -depth -type f -name "*.*"  | perl -nle 'print if /^.*\.(?!mp3|aif(f)?|wav)\w*$/' | while read file
	local exp=$(find . -depth -name "*,*");
	# For an array, ${#array[*]} and ${#array[@]} give the number of elements in the array. 
	local count=0
	for file in $exp; 
	do
		let "count+=1"
	done
	echo "FILECOUNT:$count"
	for comma in $exp
	do
		echo "File : $comma";
		select choice in \
			"Skip" \
			"Mark" \
			"Replace with underscore" \
			"Move following word to before preceding word" \
			"quit"
		do
			case $choice in
				"Skip") 
					echo "Skipped" 
					break
					;;
				"Mark") 
					rename 's/,/,->->->/' "$comma";
					echo "$comma";
					break
					;;
				"Replace with underscore") 
					rename 's/,/_/' "$comma";
					echo "$comma";
					break
					;;
				"Move following word to before preceding word") 
					rename 's/([A-Za-z0-9]+\b),([A-Za-z0-9]+)/\2_\1/' "$comma"; 
					echo "$comma";
					break
					;;
# 				"Move following word to before number of words") 
#  					echo "How many words previous? (Up to 4) : " 
#  					read number
# 					if ! [[ "$number" =~ ^[0-9]+$ ]]
# 					then
# 						echo "Must enter a whole number"
# 					else
# 						case $number in
# 							"1")
# 								rename -n "s/([A-Za-z0-9]+),([A-Za-z0-9]+'?[A-Za-z0-9]*)/\2_\1/" "$comma";
# 								break
# 								;;
# 							"2")
# 								rename -n "s/([A-Za-z0-9]+_)?([A-Za-z0-9]+),([A-Za-z0-9]+'?[A-Za-z0-9]*)/$3_$1$2/" "$comma"; 
# 								break
# 								;;
# 							3)
# 								rename -n 's/([A-Za-z0-9]+_)?([A-Za-z0-9]+_)?([A-Za-z0-9]+),([A-Za-z0-9]+\'?[A-Za-z0-9]*)/$4_$1$2$3/' "$comma"; 
# 								break
# 								;;
# 							4)
# 								rename -n 's/([A-Za-z0-9]+_)?([A-Za-z0-9]+_)?([A-Za-z0-9]+_)?([A-Za-z0-9]+),([A-Za-z0-9]+\'?[A-Za-z0-9]*)/$5_$1$2$3$4/' "$comma"; 
# 								break
# 								;;
# 						esac
# 						#rename -n 's/([A-Za-z0-9]+_)?([A-Za-z0-9]+_)?([A-Za-z0-9]+_)?([A-Za-z0-9]+),([A-Za-z0-9]+\'?[A-Za-z0-9]*)/$5_$1$2$3$4/' "$comma"; 
#  					fi
#  					echo "$comma";
# 					;;
				"quit") 
					echo "bye" 
					break 2
					;;
			esac
		done	
	done
}