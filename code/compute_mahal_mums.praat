# This script analyzes the mahalanobis distance (to the center of the distribution) of each of the mother's vowel to the distribution of the respective
# testspeaker, and then takes the mean. it then again averages over the two vowels, such then we get a mean for each mum per testspeaker


# !! This script analyzes only females voices. If you want to analyze male voices, set the max formant to 5000 instead of 5500 (formant = To Formant (burg): 0, 5, 5500, 0.025, 50).
#
# Written by Gisela Govaart (June 6, 2024)
# Latest revision: 
#
# This script is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation, either version 3 of
# the License, or (at your option) any later version.
#
# A copy of the GNU General Public License is available at
# <http://www.gnu.org/licenses/>.


# we want the MD for each mother to each speaker
;for i from 1 to 4
;	if i=1
;		speaker$ = "Speaker1"
;	elsif	i=2
;		speaker$ = "Speaker2"
;	elsif i=3		
;;		speaker$ = "Speaker3"
	;else 		
	;	speaker$ = "Speaker4"
	;endif



# Make the covariance matrices from the stored tables of the testspeakers
table_s1_fe = Read from file: "table_trainingstim_fe_ERB_Speaker1.Table"
Down to TableOfReal: ""
cov_s1_fe = To Covariance
table_s1_fi = Read from file: "table_trainingstim_fi_ERB_Speaker1.Table"
Down to TableOfReal: ""
cov_s1_fi = To Covariance

table_s2_fe = Read from file: "table_trainingstim_fe_ERB_Speaker2.Table"
Down to TableOfReal: ""
cov_s2_fe = To Covariance
table_s2_fi = Read from file: "table_trainingstim_fi_ERB_Speaker2.Table"
Down to TableOfReal: ""
cov_s2_fi = To Covariance

table_s3_fe = Read from file: "table_trainingstim_fe_ERB_Speaker3.Table"
Down to TableOfReal: ""
cov_s3_fe = To Covariance
table_s3_fi = Read from file: "table_trainingstim_fi_ERB_Speaker3.Table"
Down to TableOfReal: ""
cov_s3_fi = To Covariance

table_s4_fe = Read from file: "table_trainingstim_fe_ERB_Speaker4.Table"
Down to TableOfReal: ""
cov_s4_fe = To Covariance
table_s4_fi = Read from file: "table_trainingstim_fi_ERB_Speaker4.Table"
Down to TableOfReal: ""
cov_s4_fi = To Covariance


# here you still need to check whether the mums are indeed called 1, 2, etc, or 01,02,03 etc. otherwise add the 0 with another small loop that adds a 0 if j < 10
for j from 1 to 80
# Set the directory you want to take the wavs from
for dir from 1 to 2
	if dir = 1
		indir$ = "vowels_mums/" + "j" + "/fi"
	else
		indir$ = "vowels_mums/" + "j" + "/fe"
	endif

	# Compute the F1 and F2 for each file, and put the outcomes in a table with column names F1 and F2

	files = Create Strings as file list: "wavs", indir$
	selectObject: files
	numFiles = Get number of strings

	# Set up the table
	table_all = Create Table with column names: "table_all", numFiles, "F1 F2"

	# Loop through the wavs in the dir, get their f1 and f2, and put those in the table
	for fileNum from 1 to numFiles
		selectObject: files
		fileName$ = Get string: fileNum
		sound = Read from file: indir$ + fileName$
		formant = To Formant (burg): 0, 5, 5500, 0.025, 50
		f1 = Get mean: 1, 0, 0, "hertz"
		f2 = Get mean: 2, 0, 0, "hertz"
		# convert to ERBs
		f1 = hertzToErb(f1)
		f2 = hertzToErb(f2)

		selectObject: table_all
  		Set numeric value: fileNum, "F1", f1
  		Set numeric value: fileNum, "F2", f2
		
		selectObject: sound, formant
		Remove

	endfor

	# Append columns to store filename and to store mahaldist later. Cannot do this before because then we can't make the cov matrix.
	selectObject: table_all
	Append column: "mahal_s1"
	Append column: "mahal_s2"
	Append column: "mahal_s3"
	Append column: "mahal_s4"


	selectObject: table_all
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

		# Open a file, compute F1 and F2, and save as vars
		selectObject: table_all

		f1 = Get value: fileNum, "F1"
		f2 = Get value: fileNum, "F2"

		# Create a table for the current vowel
		table_one = Create Table with column names: "table_one", 1, "F1 F2"
		Set numeric value: 1, "F1", f1
		Set numeric value: 1, "F2", f2
		selectObject: table_one
		tor_one = Down to TableOfReal: ""

		# now we compute mahal per speaker
		if dir = 1
			# for fi 
			# s1
			selectObject: cov_s1_fi, tor_one
			table_mal = To TableOfReal (mahalanobis): "no"
			mahaladist_s1_fi = Get value: 1,1
			selectObject: table_all
  			Set numeric value: fileNum, "mahal_s1", mahaladist_s1_fi
			# s2			
			selectObject: cov_s2_fi, tor_one
			table_mal = To TableOfReal (mahalanobis): "no"
			mahaladist_s2_fi = Get value: 1,1
			selectObject: table_all
  			Set numeric value: fileNum, "mahal_s2", mahaladist_s2_fi
			# s3		
			selectObject: cov_s3_fi, tor_one
			table_mal = To TableOfReal (mahalanobis): "no"
			mahaladist_s3_fi = Get value: 1,1
			selectObject: table_all
  			Set numeric value: fileNum, "mahal_s3", mahaladist_s3_fi
			# s4			
			selectObject: cov_s4_fi, tor_one
			table_mal = To TableOfReal (mahalanobis): "no"
			mahaladist_s4_fi = Get value: 1,1
			selectObject: table_all
  			Set numeric value: fileNum, "mahal_s4", mahaladist_s4_fi
		else
			# for fe
			# s1
			selectObject: cov_s1_fe, tor_one
			table_mal = To TableOfReal (mahalanobis): "no"
			mahaladist_s1_fe = Get value: 1,1
			selectObject: table_all
  			Set numeric value: fileNum, "mahal_s1", mahaladist_s1_fe
			# s2			
			selectObject: cov_s2_fe, tor_one
			table_mal = To TableOfReal (mahalanobis): "no"
			mahaladist_s2_fe = Get value: 1,1
			selectObject: table_all
  			Set numeric value: fileNum, "mahal_s2", mahaladist_s2_fe
			# s3		
			selectObject: cov_s3_fe, tor_one
			table_mal = To TableOfReal (mahalanobis): "no"
			mahaladist_s3_fe = Get value: 1,1
			selectObject: table_all
  			Set numeric value: fileNum, "mahal_s3", mahaladist_s3_fe
			# s4			
			selectObject: cov_s4_fe, tor_one
			table_mal = To TableOfReal (mahalanobis): "no"
			mahaladist_s4_fe = Get value: 1,1
			selectObject: table_all
  			Set numeric value: fileNum, "mahal_s4", mahaladist_s4_fe
		endif

		selectObject: table_one, tor_one, table_mal
		Remove

	endfor


	# Save the tables with all the vowels
	if dir = 1
		selectObject: table_all
		Save as tab-separated file: "vowels_mum/Tables/" + j + "_fi_" + "mahal_mum.Table"
	else
		selectObject: table_all
		Save as tab-separated file: "vowels_mum/Tables/" + j + "_fe_" + "mahal_mum.Table"
	endif



endfor
endfor



open all tables in the folder Tables, compute the mean per column (speaker) for "fi" and for "fe", and take the mean of that. then make a new table where you save those values




