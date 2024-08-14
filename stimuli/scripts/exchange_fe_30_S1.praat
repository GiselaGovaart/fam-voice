
table_166 = Read from file: "../Recordings/Speaker1/analyses/166_finalStim_e_Speaker1.Table"
table_all = Read from file: "../Recordings/Speaker1/analyses/75_table_all_e_Speaker1.Table"

selectObject: table_166
rownr = Search column: "filename", "e30.wav"
Remove row: rownr

selectObject: table_all
row = Extract rows where column (text): "filename", "is equal to", "e9.wav"
selectObject: table_166, row

table_new = Append
Save as tab-separated file: "../Recordings/Speaker1/analyses/166_finalStim_e_Speaker1.Table"

