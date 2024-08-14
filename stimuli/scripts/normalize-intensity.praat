# This script scales the intensity of sound objects. 
# To see what it does, see https://www.fon.hum.uva.nl/praat/manual/Sound__Scale_intensity___.html
#
# Written by Gisela Govaart (Aug 17, 2020)
# Latest revision: 
#
# This script is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation, either version 3 of
# the License, or (at your option) any later version.
#
# A copy of the GNU General Public License is available at
# <http://www.gnu.org/licenses/>.

speaker$ = "SpeakerX"

## Set the names for the dirs 
indir$ = "../Recordings/" + speaker$ + "/sentence/"
outdir$ = "../Recordings/" + speaker$ + "/sentence/normalized-intensity/"

files = Create Strings as file list: "wavs", indir$
selectObject: files
numFiles = Get number of strings

for fileNum from 1 to numFiles
	selectObject: files
	fileName$ = Get string: fileNum
	# Get file name without .wav
		fileNameLength = length(fileName$)
		fileNameMinusWav$ = left$(fileName$, fileNameLength - 4)
	sound = Read from file: indir$ + fileName$
	Scale intensity: 65
	Save as WAV file: outdir$ + fileNameMinusWav$ + "_65dB.wav"
endfor



