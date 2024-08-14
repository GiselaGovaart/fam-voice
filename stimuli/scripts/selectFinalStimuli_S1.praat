table = Read from file: "../Recordings/Speaker1/analyses/75_table_25SD_e_Speaker1.Table"
selectObject: table

Randomize rows
numFiles = Get number of rows
rowsdel = numFiles - 166
for j from 1 to rowsdel
	Remove row: 167
endfor

Save as tab-separated file: "../Recordings/Speaker1/analyses/166_finalStim_e_Speaker1.Table"


table = Read from file: "../Recordings/Speaker1/analyses/75_table_25SD_i_Speaker1.Table"
selectObject: table

Randomize rows
numFiles = Get number of rows
rowsdel = numFiles - 166
for j from 1 to rowsdel
	Remove row: 167
endfor

Save as tab-separated file: "../Recordings/Speaker1/analyses/166_finalStim_i_Speaker1.Table"



;for i from 1 to 5
;	max = Get maximum: "F1"
;	row = Search column: "F1", "'max'"
;	Remove row: row
;endfor
