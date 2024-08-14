# This script analyzes the F1, F2, F3 and duration of all the .wavs in a certain folder.
# !! This script analyzes only females voices. If you want to analyze male voices, set the max formant to 5000 instead of 5500 (formant = To Formant (burg): 0, 5, 5500, 0.025, 50).
#
# Written by Gisela Govaart (January 30, 2020)
# Latest revision: January 31, 2020
#
# This script is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation, either version 3 of
# the License, or (at your option) any later version.
#
# A copy of the GNU General Public License is available at
# <http://www.gnu.org/licenses/>.


## Set the names for the dirs and files (for improvement, you can make this into a form)
indir$ = "../Recordings/NAME/wavs/vowels/"
outdir$ = "../Recordings/NAME/analyses/"
outfile$ = "F1F2F3dur_NAME.txt"

# In output file, add a line with name, duration, F1 F2 F3
deleteFile: outdir$ + outfile$
writeFileLine: outdir$ + outfile$,  "name", tab$, "duration (ms)", tab$, "F1 (Hz)", tab$, "F2 (Hz)", tab$, "F3 (Hz)"

# so weird: this does the same (old syntax??)
;fileappend 'outdir$'/'outfile$' name 'tab$' duration (ms) 'tab$' F1 'tab$' F2 'tab$' F3 'newline$'

files = Create Strings as file list: "wavs", indir$
selectObject: files
numFiles = Get number of strings

for fileNum from 1 to numFiles
	selectObject: files
	fileName$ = Get string: fileNum

	sound = Read from file: indir$ + "/" + fileName$
	dur = Get total duration
	durms = dur*1000

	formant = To Formant (burg): 0, 5, 5500, 0.025, 50
	f1 = Get mean: 1, 0, 0, "hertz"
	f2 = Get mean: 2, 0, 0, "hertz"
	f3 = Get mean: 3, 0, 0, "hertz"

	appendFileLine: outdir$ + outfile$, fileName$, tab$, durms, tab$, f1, tab$, f2, tab$, f3
	
	removeObject: sound, formant
endfor

removeObject: files