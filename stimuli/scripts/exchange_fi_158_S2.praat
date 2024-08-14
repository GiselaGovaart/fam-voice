
table_166 = Read from file: "../Recordings/Speaker2/analyses/166_finalStim_i_Speaker2.Table"
table_2sd = Read from file: "../Recordings/Speaker2/analyses/75_table_2SD_i_Speaker2.Table"

selectObject: table_166
rownr = Search column: "filename", "i291.wav"
Remove row: rownr

selectObject: table_2sd
row = Extract rows where column (text): "filename", "is equal to", "i109.wav"
selectObject: table_166, row

table_new = Append
Save as tab-separated file: "../Recordings/Speaker2/analyses/166_finalStim_i_Speaker2.Table"

