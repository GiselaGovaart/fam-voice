# This script plots the vowels that have been selected with the scripts selectFinalStimuli_S1/2
#
# Written by Gisela Govaart (March 3, 2020)
# Latest revision: May 18, 2020
#
# This script is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation, either version 3 of
# the License, or (at your option) any later version.
#
# A copy of the GNU General Public License is available at
# <http://www.gnu.org/licenses/>.

speaker$ = "Speaker1"

Erase all
Select outer viewport... 0 11 0 8
18
Axes... 2800 1100 1000 200
Draw inner box
Marks right every... 1 200 yes yes no
Text right... yes F1 (Hertz)
Marks top every... 1 500 yes yes no
Text top... yes F2 (Hertz)

# Set dir

table_e = Read from file: "../Recordings/" + speaker$ + "/analyses/table_trainingstim_fe_" + speaker$ + ".Table"
table_i = Read from file: "../Recordings/" + speaker$ + "/analyses/table_trainingstim_fi_" + speaker$ + ".Table"

;table_e = Read from file: "../Recordings/" + speaker$ + "/analyses/166_finalStim_e_" + speaker$ + ".Table"
;table_i = Read from file: "../Recordings/" + speaker$ + "/analyses/166_finalStim_i_" + speaker$ + ".Table"

selectObject: table_e
numFiles = Get number of rows

# Plot e's
for fileNum from 1 to numFiles
	selectObject: table_e
	fileName$ =	Get value: fileNum, "filename"

	f1 = Get value: fileNum, "F1"
	f2 = Get value: fileNum, "F2"
	
	Red
	Text... f2 Centre f1 Half e
	
endfor

# Plot prototype e
for fileNum from 1 to numFiles
	selectObject: table_e
	fileName$ =	Get value: fileNum, "filename"

	f1 = Get value: fileNum, "F1"
	f2 = Get value: fileNum, "F2"

	if speaker$ = "Speaker1"
		if fileName$ = "fe_49.wav"
			Black
			Text... f2 Centre f1 Half X
		endif
	elsif speaker$ = "Speaker2"
		if fileName$ = "fe_13.wav"
			Black
			Text... f2 Centre f1 Half X
		endif
	endif

endfor
;Text... 1500 Left 350 Half 'numFiles' e

# Plot i's
selectObject: table_i
numFiles = Get number of rows

for fileNum from 1 to numFiles
	selectObject: table_i
	fileName$ =	Get value: fileNum, "filename"
	
	f1 = Get value: fileNum, "F1"
	f2 = Get value: fileNum, "F2"

	Blue
	Text... f2 Centre f1 Half i
endfor

# Plot prototype i 
for fileNum from 1 to numFiles
	selectObject: table_i
	fileName$ =	Get value: fileNum, "filename"
	
	f1 = Get value: fileNum, "F1"
	f2 = Get value: fileNum, "F2"
	if speaker$ = "Speaker1"
		if fileName$ = "fi_5.wav"
			Black
			Text... f2 Centre f1 Half X
		endif
	elsif speaker$ = "Speaker2"
		if fileName$ = "fi_63.wav"
			Black
			Text... f2 Centre f1 Half X
		endif
	endif

endfor
;Text... 1500 Left 400 Half 'numFiles' i

