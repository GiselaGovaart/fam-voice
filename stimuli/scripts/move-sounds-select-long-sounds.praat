
# This script moves the i and e wavs to seperate folders, and within these folder, the wavs longer than 70 ms in a seperate folder and the wavs shorter than 70 ms in another folder
# ! You need to create the folders beforehand!
#
# Written by Gisela Govaart (January 31, 2020)
# Latest revision: January 31, 2020
#
# This script is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation, either version 3 of
# the License, or (at your option) any later version.
#
# A copy of the GNU General Public License is available at
# <http://www.gnu.org/licenses/>.


## Set the names for the dir (for improvement, you can make this into a form)
indir$ = "../Recordings/SpeakerX/wavs/vowels/"

files = Create Strings as file list: "wavs", indir$

selectObject: files
numFiles = Get number of strings

for fileNum from 1 to numFiles
	selectObject: files
	fileName$ = Get string: fileNum
	sound = Read from file: indir$ + fileName$
	dur = Get total duration
	if left$(fileName$) == "e" & dur > 0.07
		selectObject: sound
		Save as WAV file: indir$ + "e/>70ms/" + fileName$
	elsif left$(fileName$) == "e" & dur < 0.07
		selectObject: sound
		Save as WAV file: indir$ + "e/<70ms/" + fileName$
	elsif left$(fileName$) == "i" & dur > 0.07
		selectObject: sound
		Save as WAV file: indir$ + "i/>70ms/" + fileName$
	elsif left$(fileName$) == "i" & dur < 0.07
		selectObject: sound
		Save as WAV file: indir$ + "i/<70ms/" + fileName$
	endif

	removeObject: sound
endfor

removeObject: files


