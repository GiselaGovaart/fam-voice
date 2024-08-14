#############
## wav files verplaatsen
## zet dit script in de map waar je de wavjes uit wilt halen
# Gisela Govaart, March 2016
#################

# NB: this script was never used from this folder location. 
# It can be found (in adapted versions) in the folders:
# Stimuli/Stimuli-final/Sentence
# Stimuli/Stimuli-final/TrainingSyllables/S1 and S2
# Stimuli/Stimuli-final/TestSyllables/S1 to S2

strings = Create Strings as file list: "fileList", "*.wav"
nrFiles = Get number of strings
writeInfoLine: "Nr of files is ", nrFiles

for i from 1 to nrFiles
	selectObject: strings 
	currentFile$ = Get string: i
	sound = Read from file: currentFile$
	objectName$ = selected$ ("Sound")
	Save as WAV file: "../../S1_train_'objectName$'.wav"
	appendInfoLine: "S1_train_'objectName$'"
endfor

select all
Remove


