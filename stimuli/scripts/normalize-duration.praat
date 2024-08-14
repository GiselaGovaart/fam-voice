# This script normalizes the duration (and intensity) of the fi-fe syllables
# It first changes the duration of the vowel to 75 ms, and the duration of the fricative to 65 ms.
# As an input it takes the wav files of 'fi' and 'fe', and the corresponding TGs. These are extracted 
# with explode-texgrid-tgutils.praat, from the TextGrids that have been automatically annotated
# and then checked by SR. In these textgrids, there were only the 332 prespecified syllables that will be used for the training.
#
# Written by Gisela Govaart (November, 2020)
# With code adapted from Katerina Chladkova
# Latest revision: November 6, 2020
#
# This script is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation, either version 3 of
# the License, or (at your option) any later version.
#
# A copy of the GNU General Public License is available at
# <http://www.gnu.org/licenses/>.


# Set start values
speaker$ = "Speaker2"

cDurNew = 0.065
vDurNew = 0.075

clearinfo

## Set the names for the dirs 
indir$ = "../Recordings/" + speaker$ + "/syllables/orig/"
outdir$ = "../Recordings/" + speaker$ + "/syllables/normalized/"

files = Create Strings as file list: "tgs", indir$ + "*.TextGrid"
numFiles = Get number of strings

for i from 1 to numFiles
	# open textgrid
	selectObject: files
	fileName_tg$ = Get string: i
	grid = Read from file: indir$ + fileName_tg$

	# make filename wav and open wav
	fileName_wav$ = (fileName_tg$ - ".TextGrid") + ".wav"
	sound = Read from file: indir$ + fileName_wav$

	selectObject: grid

	cBeg = Get start time of interval: 2, 1
	cEnd = Get end time of interval: 2, 1
	cDurOrig = cEnd - cBeg

	vBeg = Get start time of interval: 2, 2
	vEnd = Get end time of interval: 2, 2
	vDurOrig = vEnd - vBeg

	select sound
	man = To Manipulation: 0.01, 75, 600
	durTier = Extract duration tier
	shortenedTier = Copy: "shortened"

	Add point: cBeg, 1
	Add point: cBeg + 0.001, cDurNew/cDurOrig
	Add point: cEnd - 0.001, cDurNew/cDurOrig
	Add point: cEnd, 1

	Add point: vBeg, 1
	Add point: vBeg + 0.001, vDurNew/vDurOrig
	Add point: vEnd, vDurNew/vDurOrig
	Add point: vEnd, 1

	select man
	plus shortenedTier
	Replace duration tier
	select man
	shiftedSound = Get resynthesis (overlap-add)

	# Scale intensity
	Scale intensity: 65

	Save as WAV file: outdir$ + fileName_wav$

	removeObject: grid, sound, durTier, shortenedTier, man, shiftedSound

endfor
