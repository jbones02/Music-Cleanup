#!/usr/bin/bash

curArtist=""
curTitle=""
targetDir="$1" # Function Argument
canBeConverted=true
shift 1  # Shift to offset first arg

# Gets song name
getArtistName() {
	# Get line with artist
	artistFromFile="$(ffprobe -show_format -loglevel quiet "$i" | grep TAG:artist)"
	# Remove tag
	artistNoTag="${artistFromFile/'TAG:artist='/''}"
	# Remove whitespace
	artistFormated="${artistNoTag// /}"
	
	# If didn't find artist tag in lower case, try upper case
	if [[ $artistFormated == "" ]]
	then
		# Get line with artist
		artistFromFile="$(ffprobe -show_format -loglevel quiet "$i" | grep TAG:ARTIST)"
		# Remove tag
		artistNoTag="${artistFromFile/'TAG:ARTIST='/''}"
		# Remove whitespace
		artistFormated="${artistNoTag// /}"
	fi

	# Assign current song artist
	curArtist="$artistFormated"
}

# Gets artist name
getSongName() {
	# Get line with title
	titleFromFile="$(ffprobe -show_format -loglevel quiet "$i" | grep TAG:title)"
	# Remove tag
	titleNoTag="${titleFromFile/'TAG:title='/''}"
	# Remove whitespace
	titleFormated="${titleNoTag// /}"

	# If didn't find title tag in lower case, try upper case
	if [[ $titleFormated == "" ]]
	then
	# Get line with title
	titleFromFile="$(ffprobe -show_format -loglevel quiet "$i" | grep TAG:TITLE)"
	# Remove tag
	titleNoTag="${titleFromFile/'TAG:TITLE='/''}"
	# Remove whitespace
	titleFormated="${titleNoTag// /}"
	fi

	if [[ $titleFormated == "" ]]
	then
		canBeConverted=false
	fi

	# Assign current song title
	curTitle="$titleFormated"
}

# Reformats song file
doConversion() {
	# This function performs the conversion on a single file

	# Formulate file name
	newName="$curArtist"  # Add artist to file name
	newName+="_"  # Add underscore to separate artist and title in file name
	newName+="$curTitle"  # Add title to file name
	newName+=".mp3"  # Add file extension to file name

	# Check if file can be renamed
	if [[ $canBeConverted ]]
	then
		newDirName="$targetDir"/"$newName"  # Creates new directory name for mv command
		
		# Rename Song
		mv "$i" "$newDirName"
	fi

	rm "$i"  # Delete original file
}

# Convert each file in directory
# for each file
for i in "$targetDir"/*
do
	getArtistName
	getSongName
	doConversion
done
exit 1
