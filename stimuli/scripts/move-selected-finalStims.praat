# This script moves the selected fi and fe wavs to seperate folders
# ! You need to create the folders beforehand!
#
# Written by Gisela Govaart (May 18, 2020)
# Latest revision: May 18, 2020
#
# This script is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation, either version 3 of
# the License, or (at your option) any later version.
#
# A copy of the GNU General Public License is available at
# <http://www.gnu.org/licenses/>.

speaker$ = "Speakerx"

## Set the names for the dir 
indir$ = "../Recordings/" + speaker$ + "/wavs/syllables/"
;files = Create Strings as file list: "wavs", indir$

## open tables
table_e = Read from file: "../Recordings/" + speaker$ + "/analyses/166_finalStim_e_" + speaker$ + ".Table"
table_i = Read from file: "../Recordings/" + speaker$ + "/analyses/166_finalStim_i_" + speaker$ + ".Table"


selectObject: table_e
for i from 1 to 166
	filename$ = Get value: i, "filename"
	filename$ = "f'filename$'"
	sound = Read from file: indir$ + filename$
	Save as WAV file: indir$ + "selected_syllables_fe/" + filename$
	removeObject: sound
	selectObject: table_e
endfor

selectObject: table_i
for i from 1 to 166
	filename$ = Get value: i, "filename"
	filename$ = "f'filename$'"
	sound = Read from file: indir$ + filename$
	Save as WAV file: indir$ + "selected_syllables_fi/" + filename$
	removeObject: sound
	selectObject: table_i
endfor