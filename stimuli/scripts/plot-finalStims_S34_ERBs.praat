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

speaker$ = "Speaker4"

Erase all
Select outer viewport... 0 11 0 8
18
;Axes... 2800 1100 1000 200  # (orig Hertz axes)
# recalculation: axe_1 = 23.7229059971114, axe_2 = 16.03856691020761, axe_3 = 15.289091766447928, axe_4 = 5.363258207007583
Axes... 24 18 15 5
Draw inner box
Marks right every... 1 1 yes yes no
Text right... yes F1 (ERB)
Marks top every... 1 1 yes yes no
Text top... yes F2 (ERB)

# Set dir
table_e = Read from file: "../Recordings/" + speaker$ + "/analyses/table_trainingstim_fe_ERB_" + speaker$ + ".Table"
table_i = Read from file: "../Recordings/" + speaker$ + "/analyses/table_trainingstim_fi_ERB_" + speaker$ + ".Table"

# old Hertz
;table_e = Read from file: "../Recordings/" + speaker$ + "/analyses/table_trainingstim_fe_" + speaker$ + ".Table"
;table_i = Read from file: "../Recordings/" + speaker$ + "/analyses/table_trainingstim_fi_" + speaker$ + ".Table"
# in the tables below are the same stims, but hey have a different name: without the "f"
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

	if speaker$ = "Speaker3"
		if fileName$ = "fe148.wav"
			Black
			Text... f2 Centre f1 Half ##X#
		endif
	elsif speaker$ = "Speaker4"
		if fileName$ = "fe35.wav"
			Black
			Text... f2 Centre f1 Half ##X#
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
	if speaker$ = "Speaker3"
		if fileName$ = "fi160.wav"
			Black
			Text... f2 Centre f1 Half ##X#
		endif
	elsif speaker$ = "Speaker4"
		if fileName$ = "fi60.wav"
			Black
			Text... f2 Centre f1 Half ##X#
		endif
	endif

endfor
;Text... 1500 Left 400 Half 'numFiles' i

