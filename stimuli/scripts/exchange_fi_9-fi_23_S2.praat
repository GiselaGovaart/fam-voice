
table_166 = Read from file: "../Recordings/Speaker2/analyses/166_finalStim_i_Speaker2.Table"
table_all = Read from file: "../Recordings/Speaker2/analyses/75_table_all_i_Speaker2.Table"

selectObject: table_166
rownr = Search column: "filename", "i15.wav"
Remove row: rownr
selectObject: table_166
rownr = Search column: "filename", "i41.wav"
Remove row: rownr

selectObject: table_all
row1 = Extract rows where column (text): "filename", "is equal to", "i12.wav"
selectObject: table_all
row2 = Extract rows where column (text): "filename", "is equal to", "i19.wav"
selectObject: table_166, row1, row2

table_new = Append
Save as tab-separated file: "../Recordings/Speaker2/analyses/166_finalStim_i_Speaker2.Table"

