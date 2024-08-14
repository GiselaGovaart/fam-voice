# This script plots the vowels that are within 2.5 MHD of the category mean (as analysed by the script mahaldist_75_25SD.praat)
# I used this script for S1, for S2 I adapted it for 2 MHD
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
Axes... 2800 1100 1000 200
Draw inner box
Marks right every... 1 200 yes yes no
Text right... yes F1 (Hertz)
Marks top every... 1 500 yes yes no
Text top... yes F2 (Hertz)

# Set dir
dire$ = "../Recordings/" + speaker$ + "/wavs/vowels/e/>75ms/"
diri$ = "../Recordings/" + speaker$ + "/wavs/vowels/i/>75ms/"

table_e = Read from file: "../Recordings/" + speaker$ + "/analyses/75_table_2SD_e_" + speaker$ + ".Table"
table_i = Read from file: "../Recordings/" + speaker$ + "/analyses/75_table_2SD_i_" + speaker$ + ".Table"

selectObject: table_e
numFiles = Get number of rows

for fileNum from 1 to numFiles
	selectObject: table_e
	fileName$ =	Get value: fileNum, "filename"
	sound = Read from file: dire$ + fileName$

	formant = To Formant (burg): 0, 5, 5500, 0.025, 50
	f1 = Get mean: 1, 0, 0, "hertz"
	f2 = Get mean: 2, 0, 0, "hertz"
	
	Red
	Text... f2 Centre f1 Half e

	removeObject: sound, formant
endfor
Text... 1500 Left 350 Half 'numFiles' e

selectObject: table_i
numFiles = Get number of rows

for fileNum from 1 to numFiles
	selectObject: table_i
	fileName$ =	Get value: fileNum, "filename"
	sound = Read from file: diri$ + fileName$

	formant = To Formant (burg): 0, 5, 5500, 0.025, 50
	f1 = Get mean: 1, 0, 0, "hertz"
	f2 = Get mean: 2, 0, 0, "hertz"
	
	Blue
	Text... f2 Centre f1 Half i

	removeObject: sound, formant
endfor
Text... 1500 Left 400 Half 'numFiles' i



