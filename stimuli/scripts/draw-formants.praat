# This script plots the i's and e's in a set folder
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

# Settings for the Picture window
Erase all
Select outer viewport... 0 11 0 8
18
Axes... 2800 1100 1000 200
Draw inner box
Marks right every... 1 200 yes yes no
Text right... yes F1 (Hertz)
Marks top every... 1 500 yes yes no
Text top... yes F2 (Hertz)


# Set dirs
dire$ = "../Recordings/SpeakerX/wavs/vowels/e/>75ms/"
diri$ = "../Recordings/SpeakerX/wavs/vowels/i/>75ms/"


wavList_e = Create Strings as file list: "wavList_e", dire$
wavList_i = Create Strings as file list: "wavList_i", diri$

selectObject: wavList_e
numFiles = Get number of strings
for fileNum from 1 to numFiles
	selectObject: wavList_e
	fileName$ = Get string: fileNum
	sound = Read from file: dire$ + fileName$

	formant = To Formant (burg): 0, 5, 5500, 0.025, 50
	f1 = Get mean: 1, 0, 0, "hertz"
	f2 = Get mean: 2, 0, 0, "hertz"
	
	Red
	Text... f2 Centre f1 Half e

	removeObject: sound, formant
endfor

selectObject: wavList_i
numFiles = Get number of strings
for fileNum from 1 to numFiles
	selectObject: wavList_i
	fileName$ = Get string: fileNum
	sound = Read from file: diri$ + fileName$
	formant = To Formant (burg): 0, 5, 5500, 0.025, 50
	f1 = Get mean: 1, 0, 0, "hertz"
	f2 = Get mean: 2, 0, 0, "hertz"

	Blue
	Text... f2 Centre f1 Half i

	removeObject: sound, formant

endfor

removeObject: wavList_e, wavList_i
