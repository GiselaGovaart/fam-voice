# This script analyzes the mahalanobis distance (to the center of the distribution) of all the vowels in a dir, 
# and saves the results in a table.
# !! This script analyzes only females voices. If you want to analyze male voices, set the max formant to 5000 
# instead of 5500 (formant = To Formant (burg): 0, 5, 5500, 0.025, 50).
#
# Written by Gisela Govaart (March 2, 2020)
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

# Set the outdirs

clearinfo

# Set the indirs
for dir from 1 to 2
	if dir = 1
		indir$ = "../Recordings/" + speaker$ + "/wavs/syllables/selected_syllables_fi/"
	else
		indir$ = "../Recordings/" + speaker$ + "/wavs/syllables/selected_syllables_fe/"
	endif

	if dir = 1
		indir_vowel$ = "../Recordings/" + speaker$ + "/wavs/vowels/i/>75ms/"
	else
		indir_vowel$ = "../Recordings/" + speaker$ + "/wavs/vowels/e/>75ms/"
	endif

	# Compute the F1 and F2 for each file, and put the outcomes in a table with column names F1 and F2

	files = Create Strings as file list: "wavs", indir$ + "*.wav"
	numFiles = Get number of strings

	# Set up the table
	table_all = Create Table with column names: "table_all", numFiles, "F1 F2"

	# Loop through the wavs in the dir, get their f1 and f2, and put those in the table
	
	for fileNum from 1 to numFiles
		selectObject: files
		fileName$ = Get string: fileNum
		len = length(fileName$) - 1
		fileNameVowel$ = right$(fileName$, len)
		sound = Read from file: indir_vowel$ + fileNameVowel$

		formant = To Formant (burg): 0, 5, 5500, 0.025, 50
		f1 = Get mean: 1, 0, 0, "hertz"
		f2 = Get mean: 2, 0, 0, "hertz"

		selectObject: table_all
  		Set numeric value: fileNum, "F1", f1
  		Set numeric value: fileNum, "F2", f2
		
		selectObject: sound, formant
		Remove

	endfor

	# Make the covariance matrix for this table
	selectObject: table_all
	Down to TableOfReal: ""
	cov = To Covariance

	# Append columns to store filename and to store mahaldist later. Cannot do this before because then we can't make the cov matrix.
	selectObject: table_all
	Append column: "mahal"
	Insert column: 1, "filename"
	for fileNum from 1 to numFiles
		selectObject: files
		fileName$ = Get string: fileNum
		selectObject: table_all
  		Set string value: fileNum, "filename", fileName$
	endfor

	# Now we use the covariance matrix to determine the mahalanobis distance to the center of the category for each individual vowel.

	# Start a for loop for all the files in the dir
	for fileNum from 1 to numFiles

		# Open a file, extract F1 and F2 from table, and save as vars
		selectObject: table_all

		f1 = Get value: fileNum, "F1"
		f2 = Get value: fileNum, "F2"

		# Create a table for the current vowel
		table_one = Create Table with column names: "table_one", 1, "F1 F2"
		Set numeric value: 1, "F1", f1
		Set numeric value: 1, "F2", f2
		selectObject: table_one
		tor_one = Down to TableOfReal: ""
		selectObject: cov, tor_one
		table_mal = To TableOfReal (mahalanobis): "no"
		mahaladist = Get value: 1,1
		selectObject: table_one, tor_one, table_mal
		Remove

		# Add the mahal dist to the table_all
		selectObject: table_all
  		Set numeric value: fileNum, "mahal", mahaladist

	endfor

	# open the table, sort on the bases of mahal dist, and then take the 166 vowels with the smallest mahal dist
	selectObject: table_all
	Sort rows: "mahal"
	teststim$ = Get value: 1, "filename"
	appendInfoLine: "Teststim for " + speaker$ + " = " + teststim$

	# Save the tables with all the vowels
	if dir = 1
		selectObject: table_all
		Save as tab-separated file: "../Recordings/" + speaker$ + "/analyses/table_trainingstim_fi_" + speaker$ + ".Table"
	else
		selectObject: table_all
		Save as tab-separated file: "../Recordings/" + speaker$ + "/analyses/table_trainingstim_fe_" + speaker$ + ".Table"
	endif

endfor
