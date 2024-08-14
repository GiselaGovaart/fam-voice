setwd("/Users/giselagovaart/ownCloud/PhD/Experiment1_FamVoice/Stimuli/Recordings/")
S1_i_erb <-read.table(file="Speaker1/analyses/75_table_25SD_i_ERBs_Speaker1.table",header=T, sep="\t")
S1_i_hz <-read.table(file="Speaker1/analyses/75_table_25SD_i_Speaker1.table",header=T, sep="\t")
S1_i_hz$filename %in% S1_i_erb$filename 
## all true

S2_e_erb <-read.table(file="Speaker2/analyses/75_table_2SD_e_ERBs_Speaker2.table",header=T, sep="\t")
S2_e_hz <-read.table(file="Speaker2/analyses/75_table_2SD_e_Speaker2.table",header=T, sep="\t")
S2_e_hz$filename %in% S2_e_erb$filename 
# all true


# ------- here the problem starts
# Speaker 1, fe
S1_e_erb <-read.table(file="Speaker1/analyses/75_table_25SD_e_ERBs_Speaker1.table",header=T, sep="\t")
S1_e_hz <-read.table(file="Speaker1/analyses/75_table_25SD_e_Speaker1.table",header=T, sep="\t")
S1_e_trainingstims_hz <-read.table(file="Speaker1/analyses/table_trainingstim_fe_Speaker1.table",header=T, sep="\t")
S1_e_trainingstims_erb <-read.table(file="Speaker1/analyses/table_trainingstim_fe_ERB_Speaker1.table",header=T, sep="\t")

S1_e_hz$filename %in% S1_e_erb$filename 
#not all true
S1_e_hz$filename[!S1_e_hz$filename %in% S1_e_erb$filename]
# "e30.wav" is not in the ERBs table, but is in the Hertz table

## now you still need to figure out what this stimulus is renamed like in the trainingstimuli:
# I did the following: 
# - I selected (randomly) the trainingstims, they are in: /Users/giselagovaart/ownCloud/PhD/Experiment1_FamVoice/Stimuli/Recordings/Speaker1/wavs/syllables/selected_syllables_fe
# those syllables were used as the input for concatenate-sounds-withISI.praat
# that textgrid was realigned and then split into single syllables again with explode-textgrid-tgutils.praat
# and the output of that is saved in /Users/giselagovaart/ownCloud/PhD/Experiment1_FamVoice/Stimuli/Recordings/Speaker1/syllables/orig/fe
# so if I want to know which file in "orig" the file fe30 in selected_syllables_fe corresponds to,
# I check at which order nummer, fe30 appears in selected_syllables_fe.
# fe30 is fe_18

## Replace:
# your options to replace are: the stimuli that are not in the training stims table but are in the ERBs table:
# check in /selected_syllables_fe/ which sound files are missing, and check whether they are in the ERBs table:
"e.wav" %in% S1_e_erb$filename 
"e1.wav" %in% S1_e_erb$filename 
"e9.wav" %in% S1_e_erb$filename # use this
"e10.wav" %in% S1_e_erb$filename 
"e11.wav" %in% S1_e_erb$filename 
"e12.wav" %in% S1_e_erb$filename 


# Speaker 2, fi

S2_i_erb <-read.table(file="Speaker2/analyses/75_table_2SD_i_ERBs_Speaker2.table",header=T, sep="\t")
S2_i_hz <-read.table(file="Speaker2/analyses/75_table_2SD_i_Speaker2.table",header=T, sep="\t")
S2_i_trainingstims <-read.table(file="Speaker2/analyses/table_trainingstim_fi_ERB_Speaker2.table",header=T, sep="\t")

S2_i_hz$filename %in% S2_i_erb$filename 
# not all true
S2_i_hz$filename[!S2_i_hz$filename %in% S2_i_erb$filename]
# "i15.wav" "i3.wav"  "i41.wav" are not in the ERBs table, but are in the Hertz table
# fi3 did not get picked for the final 166 trainingstims
# fi15 is fi_9
# fi41 is fi_23

# Options to replace:
"i6.wav" %in% S2_i_erb$filename 
"i12.wav" %in% S2_i_erb$filename # use this
"i19.wav" %in% S2_i_erb$filename # use this
"i32.wav" %in% S2_i_erb$filename 
"i36.wav" %in% S2_i_erb$filename 
"i38.wav" %in% S2_i_erb$filename 








##### TO DO
# Figure out how to match the stimuli from the trainingsstim table to the original table. This is difficult, because you renames all the stimuli
# after the manual realignment. 
# Ideas:
#   - find the script with which you made the long sound files and textgrids for sophia to realign. There you might figure out the order how they went in and outer
#   - have a look at 166_finalStim_e_Speaker1.Table. Maybe you used this order as the input for the long sound file? and then it came out as 1-166
#  in that example e_30 could be fe_98. BUT it's difficult to figure that out by listening, because the files are also normalized for duration
#   and maybe therefore sound different? (check this!)

# Replace the stimuli. See exchange_fi_158_S2.praat for an example of how you did this once before

# Old: not sure whether this helps me
# your options to replace are:
#S1_e_erb$filename[!S1_e_erb$filename %in% S1_e_hz$filename]
# "e123.wav" "e169.wav"

#### OLD
## This code does not help me, because I completely renames the stims after the manual realignment
# for (i in 1:nrow(S2_i_erb)){
#   x = S2_i_erb$filename[i]
#   x = gsub("i", "fi_", x)
#   print(x)
#   S2_i_erb$filename[i] = x
# }
# S2_i_trainingstims$filename[!S2_i_trainingstims$filename %in% S2_i_erb$filename]

## via the mahaldistance: not working, because the stimuli in the trainingsstims table are realigned, so their values are not exactly the same
# mahal = S1_e_hz$mahal[205]
# mahal = round(mahal, 6)
# 
# for (i in 1:nrow(S1_e_trainingstims_hz)){
#   x = S1_e_trainingstims_hz$mahal[i]
#   x = round(x, 6)
#   print(x)
#   S1_e_trainingstims_hz$mahal[i] = x
# }
# S1_e_trainingstims_hz[which(S1_e_trainingstims_hz$mahal == mahal), ]

