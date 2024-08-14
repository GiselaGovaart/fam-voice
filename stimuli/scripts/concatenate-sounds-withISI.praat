### concatWithPause.praat
#
# Description:
#   Concatenate sounds with a user defined pause (silence) duration between sounds
# Options:
#   - resampling of sounds if they have different sampling frequencies
#     (only copies are resampled, not the original sounds; choice of 7 (re-) sampling frequencies)
#   - custom order of sounds
#
# Usage:
#   - select 2 or more sounds
#   - start the script
#      - if selected sounds have different sampling frequencies you are asked
#        to specify a resampling frequency
#      - specify pause (silence) duration in seconds
#      - check option if you want to rearrange sounds (default: order of appearance in object list)
#      - if checked: specify custom order
#
### jm, 2013-11-17

# determine number of selected sounds
no_Snd = numberOfSelected ("Sound")

# check if 2 or more sounds are selected
if no_Snd = 0
	exit No Sound selected.
elsif no_Snd = 1
	exit Only one Sound selected.
endif

# get IDs and names of selected sounds
for i to no_Snd
	soundID [i] = selected ("Sound", i)
	soundName$ [i] = selected$ ("Sound", i)
endfor

# check for varying sampling frequencies (fs)
no_fs = 0
for i to no_Snd
	selectObject (soundID [i])
	fs = do ("Get sampling frequency")
	# get some fs at first pass 
	if no_fs = 0
		fsOcc [1] = fs
		no_fs = 1
	# get other fs if there are any
	# and count number of different fs (no_fs)
	else
		# assume we found a new fs
		newfs = 1
		for k to no_fs
			if fs = fsOcc [k]
				# if the new fs equals to an already occuring fs we didn't fins a new fs'
				newfs = 0
			endif
		endfor
		# if we indeed found a new fs increment counter and add new fs to array of occuring fs
		if newfs = 1
			no_fs = no_fs + 1
			fsOcc [no_fs] = fs
		endif
	endif
endfor

# get user input
beginPause ("Concatenate Sounds")
	# if varying fs occur ask for resampling frequency
	if no_fs > 1
		comment ("The Sounds you selected have different sampling frequencies")
		comment ("and can't be concatenated without resampling.")
		comment ("If you want to concatenate resampled copies of the original Sounds")
		comment ("you must choose a (re-) sampling frequency.")
		optionMenu ("Sampling frequency", 5)
			option ("8000")
			option ("10000")
			option ("11025")
			option ("16000")
			option ("22050")
			option ("44100")
			option ("48000")
		comment ("If you want to abort click Cancel.")
		comment ("")
		comment ("")
	endif
	# ask for pause/silence duration
	comment ("Specify the silence duration between Sounds.")
	real ("Silence duration (s)", 0.5)
	# shall we rearrange sounds?
	comment ("By default, Sounds are concatenated in the order they appear")
	comment ("in the list. Check below if you want to change the order.")
	boolean ("Change order", 0)
clicked = endPause ("Cancel", "OK", 2, 1)
if clicked = 1
	goto FINISH
endif

# for reordering we need a new array (see below); we'll use that new array for the
# default case (no reordering) too in order to stay consistent
if change_order = 0
	# simply copy old array to new array
	for i to no_Snd
		sound [i] = soundID [i]
	endfor
# in the case of reordering it's less simple...
elsif change_order = 1
	# ask the user for new order
	beginPause ("Reorder Sounds")
		for i to no_Snd
			optionMenu ("Sound 'i'", i)
			for k to no_Snd
				option (soundName$ [k])
			endfor
		endfor
	clicked = endPause ("Cancel", "OK", 2, 1)
	if clicked = 1
		goto FINISH
	else
		# use the numeric specification of the choosen option as index
		# for the old array to generate the new array
		for i to no_Snd
			sound [i] = soundID [sound_'i']
		endfor
	endif
endif

# asign the standard fs to a consistent variable;
# standard fs is either the fs of all sounds or the choosen resampling frequency
if no_fs = 1
	sampling_frequency = fsOcc [1]
else
	sampling_frequency = number (sampling_frequency$)
endif

# generate pause
silence = do ("Create Sound from formula...", "silence", 1, 0, silence_duration, sampling_frequency, "0")

# copy/resample sounds and pause to achieve desired order
for i to no_Snd
	selectObject (sound [i])
	thefs = do ("Get sampling frequency")
	# if resampling is on and sound needs resampling generate a resampled copy
	if no_fs > 1 && thefs <> sampling_frequency
		sound [i] = do ("Resample...", sampling_frequency, 50)
	# if sound doen't need resampling generate a simple copy'
	else
		sound [i] = do ("Copy...", "tmp")
	endif
	# generate a copy of pause after each sound (except the last)
	if i < no_Snd
		selectObject (silence)
		sil [i] = do ("Copy...", "tmp")
	endif
endfor
removeObject (silence)

# now everything is ready to go (correct order, consistent fs), so let's select it...
selectObject (sound [1])
for i to no_Snd - 1
	plusObject (sil [i])
	plusObject (sound [i+1])
endfor
# ... concatenate it ...
concat = do ("Concatenate")
do ("Rename...", "concatenated")
# ... and delete it
selectObject (sound [1])
for i to no_Snd - 1
	plusObject (sil [i])
	plusObject (sound [i+1])
endfor
do ("Remove")
selectObject (concat)

label FINISH
exit
