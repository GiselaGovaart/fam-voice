# This script analyzes the mahalanobis distance (to the center of the distribution) of each of the mother's vowel to the distribution of the respective
# testspeaker, and then takes the mean. it then again averages over the two vowels, such then we get a mean for each mum per testspeaker


# !! This script analyzes only females voices. If you want to analyze male voices, set the max formant to 5000 instead of 5500 (formant = To Formant (burg): 0, 5, 5500, 0.025, 50).
#
# Written by Gisela Govaart (June 6, 2024)
# Latest revision: June 17, 2024
#
# This script is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation, either version 3 of
# the License, or (at your option) any later version.
#
# A copy of the GNU General Public License is available at
# <http://www.gnu.org/licenses/>.


# we want the MD for each mother to each speaker

# Make the covariance matrices from the stored tables of the testspeakers
table_s1_fe = Read from file: "table_trainingstim_fe_ERB_Speaker1.Table"
Remove column: "filename"
Remove column: "mahal"
Down to TableOfReal: ""
cov_s1_fe = To Covariance
table_s1_fi = Read from file: "table_trainingstim_fi_ERB_Speaker1.Table"
Remove column: "filename"
Remove column: "mahal"
Down to TableOfReal: ""
cov_s1_fi = To Covariance

table_s2_fe = Read from file: "table_trainingstim_fe_ERB_Speaker2.Table"
Remove column: "filename"
Remove column: "mahal"
Down to TableOfReal: ""
cov_s2_fe = To Covariance
table_s2_fi = Read from file: "table_trainingstim_fi_ERB_Speaker2.Table"
Remove column: "filename"
Remove column: "mahal"
Down to TableOfReal: ""
cov_s2_fi = To Covariance

table_s3_fe = Read from file: "table_trainingstim_fe_ERB_Speaker3.Table"
Remove column: "filename"
Remove column: "mahal"
Down to TableOfReal: ""
cov_s3_fe = To Covariance
table_s3_fi = Read from file: "table_trainingstim_fi_ERB_Speaker3.Table"
Remove column: "filename"
Remove column: "mahal"
Down to TableOfReal: ""
cov_s3_fi = To Covariance

table_s4_fe = Read from file: "table_trainingstim_fe_ERB_Speaker4.Table"
Remove column: "filename"
Remove column: "mahal"
Down to TableOfReal: ""
cov_s4_fe = To Covariance
table_s4_fi = Read from file: "table_trainingstim_fi_ERB_Speaker4.Table"
Remove column: "filename"
Remove column: "mahal"
Down to TableOfReal: ""
cov_s4_fi = To Covariance

# This is the output of the corrected WAVfiles, which is used here as an input
directoryList = Create Strings as directory list: "directoryList", "../Output"

selectObject: directoryList
numDirs = Get number of strings

for j from 1 to numDirs
	selectObject: directoryList
	vp$ = Get string: j
    # Set the directory you want to take the wavs from
    for dir from 1 to 2
        if dir = 1
            indir$ = "/data/p_02453/vowels_mums/" + vp$ + "/fi/"
        else
            indir$ = "/data/p_02453/vowels_mums/" + vp$ + "/fe/"
        endif

        # Compute the F1 and F2 for each file, and put the outcomes in a table with column names F1 and F2
        files = Create Strings as file list: "wavs", indir$
        selectObject: files
        numFiles = Get number of strings

        # Set up the table
        table_all = Create Table with column names: "table_all", numFiles, "F1 F2 Duration"

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

			  # get duration
			  selectObject: sound
			  dur = Get total duration

			  
            selectObject: table_all
            Set numeric value: fileNum, "F1", f1
            Set numeric value: fileNum, "F2", f2
            Set numeric value: fileNum, "Duration", dur
            
            selectObject: sound, formant
            Remove
        endfor

		# Remove values we want to exclude based on duration (> 20 ms) and update nrRows
		selectObject: table_all
		table_all = Extract rows where column (number): "Duration", "greater than or equal to", 0.02
		numFiles = Get number of rows

		# Create cov of mum's own vowels, to be able to determine mahal for each vowel to own category middle
		table_own = table_all
		Remove column: "Duration"
		Down to TableOfReal: ""
		cov_own = To Covariance

        # Append columns to store filename and to store mahaldist later
        selectObject: table_all
        Append column: "mahal_s1"
        Append column: "mahal_s2"
        Append column: "mahal_s3"
        Append column: "mahal_s4"
        Append column: "mahal_own"

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
					# own
				   selectObject: cov_own, tor_one
                table_mal = To TableOfReal (mahalanobis): "no"
                mahaladist_own_fi = Get value: 1,1
                selectObject: table_all
                Set numeric value: fileNum, "mahal_own", mahaladist_own_fi
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
					# own
				   selectObject: cov_own, tor_one
                table_mal = To TableOfReal (mahalanobis): "no"
                mahaladist_own_fe = Get value: 1,1
                selectObject: table_all
                Set numeric value: fileNum, "mahal_own", mahaladist_own_fe
            endif

            selectObject: table_one, tor_one, table_mal
            Remove
        endfor

		# Remove the rows where the mahal to own category center is > 2.5 SD
		selectObject: table_all
		sd = Get standard deviation: "mahal_own"
		sd_cutoff = sd * 2.5
		mean = Get mean: "mahal_own"
		min_mahal = mean - sd_cutoff
		max_mahal = mean + sd_cutoff

		table_all = Extract rows where column (number): "mahal_own", "greater than or equal to", min_mahal
		table_all = Extract rows where column (number): "mahal_own", "less than or equal to", max_mahal

        # Save the tables with all the vowels
        if dir = 1
            selectObject: table_all
            Save as tab-separated file: "output/" + vp$ + "_fi_" + "mahal_mum.Table"
        else
            selectObject: table_all
            Save as tab-separated file: "output/" + vp$ + "_fe_" + "mahal_mum.Table"
        endif
    endfor
endfor


## Make general table with means per speaker per vowel for each mum
# Initialize the table to store mean distances
table_mean_distances = Create Table with column names: "table_mean_distances", 80, "vp mean_s1_fi mean_s2_fi mean_s3_fi mean_s4_fi mean_s1_fe mean_s2_fe mean_s3_fe mean_s4_fe"

# Loop through each mum 
for j from 1 to numDirs
	selectObject: directoryList
	vp$ = Get string: j
    # Read the fi and fe tables
    table_fi = Read from file: "output/" + vp$ + "_fi_" + "mahal_mum.Table"
    table_fe = Read from file: "output/" + vp$ + "_fe_" + "mahal_mum.Table"

    # Compute the mean distance for each speaker for fi
    selectObject: table_fi
    mean_s1_fi = Get mean: "mahal_s1"
    mean_s2_fi = Get mean: "mahal_s2"
    mean_s3_fi = Get mean: "mahal_s3"
    mean_s4_fi = Get mean: "mahal_s4"

    # Compute the mean distance for each speaker for fe
    selectObject: table_fe
    mean_s1_fe = Get mean: "mahal_s1"
    mean_s2_fe = Get mean: "mahal_s2"
    mean_s3_fe = Get mean: "mahal_s3"
    mean_s4_fe = Get mean: "mahal_s4"

    # Store the means in the table
    selectObject: table_mean_distances
	 Set string value: j, "vp", vp$
    Set numeric value: j, "mean_s1_fi", mean_s1_fi
    Set numeric value: j, "mean_s2_fi", mean_s2_fi
    Set numeric value: j, "mean_s3_fi", mean_s3_fi
    Set numeric value: j, "mean_s4_fi", mean_s4_fi
    Set numeric value: j, "mean_s1_fe", mean_s1_fe
    Set numeric value: j, "mean_s2_fe", mean_s2_fe
    Set numeric value: j, "mean_s3_fe", mean_s3_fe
    Set numeric value: j, "mean_s4_fe", mean_s4_fe
endfor

# Save the table with mean distances
selectObject: table_mean_distances
Save as tab-separated file: "output/mean_distances_perVowel.Table"

## Make general table with means per speaker for the two vowels combined for each mum
# Initialize the table to store the mean of the means
table_mean_of_means = Create Table with column names: "table_mean_of_means", 80, "vp mean_s1 mean_s2 mean_s3 mean_s4"

# Loop through each mum 
for j from 1 to numDirs
	selectObject: directoryList
	vp$ = Get string: j
    # Compute the mean of the means for each speaker
	 selectObject: table_mean_distances
	 s1_fi = Get value: j, "mean_s1_fi"
	 s1_fe = Get value: j, "mean_s1_fe"
	 s2_fi = Get value: j, "mean_s2_fi"
	 s2_fe = Get value: j, "mean_s2_fe"
	 s3_fi = Get value: j, "mean_s3_fi"
	 s3_fe = Get value: j, "mean_s3_fe"
	 s4_fi = Get value: j, "mean_s4_fi"
	 s4_fe = Get value: j, "mean_s4_fe"

    mean_s1 = (s1_fi + s1_fe)/2
    mean_s2 = (s2_fi + s2_fe)/2
    mean_s3 = (s3_fi + s3_fe)/2
    mean_s4 = (s4_fi + s4_fe)/2


    # Store the means in the table
    selectObject: table_mean_of_means
	 Set string value: j, "vp", vp$
    Set numeric value: j, "mean_s1", mean_s1
    Set numeric value: j, "mean_s2", mean_s2
    Set numeric value: j, "mean_s3", mean_s3
    Set numeric value: j, "mean_s4", mean_s4
endfor

# Save the table with the mean of the means
selectObject: table_mean_of_means
Save as tab-separated file: "output/mean_of_means.Table"

