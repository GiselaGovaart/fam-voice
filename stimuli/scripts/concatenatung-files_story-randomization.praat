# This script concatenates the sound files for the voice familiarization phase per randomization group
#
# Written by Gisela Govaart (March 17, 2022)
# Latest revision: xx
#
# This script is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation, either version 3 of
# the License, or (at your option) any later version.
#
# A copy of the GNU General Public License is available at
# <http://www.gnu.org/licenses/>.

## Set dir
dir$ = "../Stimuli-final/Stories/"
table = Read Table from semicolon-separated file: dir$ + "randomizations.csv"

rows = Get number of rows
silence = Create Sound from formula: "sineWithNoise", 1, 0, 1, 44100, "0"

for i from 1 to rows
	selectObject: table
	day$ = Get value: i, "Day"
	group$ = Get value: i, "Group"
	filename_1$ = Get value: i, "File_1"
	filename_2$ = Get value: i, "File_2"

	file_1 = Read from file: dir$ + filename_1$ + ".wav"
	file_2 = Read from file: dir$ + filename_2$ + ".wav"

	selectObject: file_1, silence, file_2
	Concatenate
	Save as WAV file: dir$ + group$ + "/" + day$ + ".wav"

endfor


