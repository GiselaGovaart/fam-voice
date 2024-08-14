

# For Speaker 3

table = Read from file: "../Recordings/Speaker3/analyses/75_table_2SD_e_Speaker3.Table"
selectObject: table

Randomize rows
numFiles = Get number of rows
rowsdel = numFiles - 166
for j from 1 to rowsdel
	Remove row: 167
endfor

Save as tab-separated file: "../Recordings/Speaker3/analyses/166_finalStim_e_Speaker3.Table"


table = Read from file: "../Recordings/Speaker3/analyses/75_table_2SD_i_Speaker3.Table"
selectObject: table

Randomize rows
numFiles = Get number of rows
rowsdel = numFiles - 166
for j from 1 to rowsdel
	Remove row: 167
endfor

Save as tab-separated file: "../Recordings/Speaker3/analyses/166_finalStim_i_Speaker3.Table"


# For speaker 4
## NB since S4 has only 167 i's that are longer than 75 ms, I take table_all instead of table_2SD for i

table = Read from file: "../Recordings/Speaker4/analyses/75_table_2SD_e_Speaker4.Table"
selectObject: table

Randomize rows
numFiles = Get number of rows
rowsdel = numFiles - 166
for j from 1 to rowsdel
	Remove row: 167
endfor

Save as tab-separated file: "../Recordings/Speaker4/analyses/166_finalStim_e_Speaker4.Table"


table = Read from file: "../Recordings/Speaker4/analyses/75_table_all_i_Speaker4.Table"
selectObject: table

Randomize rows
numFiles = Get number of rows
rowsdel = numFiles - 166
for j from 1 to rowsdel
	Remove row: 167
endfor

Save as tab-separated file: "../Recordings/Speaker4/analyses/166_finalStim_i_Speaker4.Table"


