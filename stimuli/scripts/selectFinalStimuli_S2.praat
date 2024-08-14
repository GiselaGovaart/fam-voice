table = Read from file: "../Recordings/Speaker2/analyses/75_table_2SD_e_Speaker2.Table"
selectObject: table

for i from 1 to 10
	min = Get minimum: "F1"
	row = Search column: "F1", "'min'"
	Remove row: row
endfor

Randomize rows
numFiles = Get number of rows
rowsdel = numFiles - 166
for j from 1 to rowsdel
	Remove row: 167
endfor

Save as tab-separated file: "../Recordings/Speaker2/analyses/166_finalStim_e_Speaker2.Table"


table = Read from file: "../Recordings/Speaker2/analyses/75_table_2SD_i_Speaker2.Table"
selectObject: table


for i from 1 to 7
	max = Get maximum: "F1"
	row = Search column: "F1", "'max'"
	Remove row: row
endfor


Randomize rows
numFiles = Get number of rows
rowsdel = numFiles - 166
for j from 1 to rowsdel
	Remove row: 167
endfor

Save as tab-separated file: "../Recordings/Speaker2/analyses/166_finalStim_i_Speaker2.Table"



