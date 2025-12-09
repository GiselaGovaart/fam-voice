# This script computes the Euclidean distance between the Testvowels for each speaker
#
# Written by Gisela Govaart (June 5th, 2024)
# Latest revision: 
#
# This script is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation, either version 3 of
# the License, or (at your option) any later version.
#
# A copy of the GNU General Public License is available at
# <http://www.gnu.org/licenses/>.# Define the formant frequencies for vowel1 and vowel2 for each speaker

# Read in the formant values
Read from file: "table_trainingstim_fe_ERB_Speaker1.Table"
s1_fe_F1 = Get value: 1, "F1"
s1_fe_F2 = Get value: 1, "F2"

Read from file: "table_trainingstim_fi_ERB_Speaker1.Table"
s1_fi_F1 = Get value: 1, "F1"
s1_fi_F2 = Get value: 1, "F2"

Read from file: "table_trainingstim_fe_ERB_Speaker2.Table"
s2_fe_F1 = Get value: 1, "F1"
s2_fe_F2 = Get value: 1, "F2"

Read from file: "table_trainingstim_fi_ERB_Speaker2.Table"
s2_fi_F1 = Get value: 1, "F1"
s2_fi_F2 = Get value: 1, "F2"

Read from file: "table_trainingstim_fe_ERB_Speaker3.Table"
s3_fe_F1 = Get value: 1, "F1"
s3_fe_F2 = Get value: 1, "F2"

Read from file: "table_trainingstim_fi_ERB_Speaker3.Table"
s3_fi_F1 = Get value: 1, "F1"
s3_fi_F2 = Get value: 1, "F2"

Read from file: "table_trainingstim_fe_ERB_Speaker4.Table"
s4_fe_F1 = Get value: 1, "F1"
s4_fe_F2 = Get value: 1, "F2"

Read from file: "table_trainingstim_fi_ERB_Speaker4.Table"
s4_fi_F1 = Get value: 1, "F1"
s4_fi_F2 = Get value: 1, "F2"


# Compute the distances
distance_speaker1 = sqrt((s1_fe_F1 - s1_fi_F1)^2 + (s1_fe_F2 - s1_fi_F2)^2)
distance_speaker2 = sqrt((s2_fe_F1 - s2_fi_F1)^2 + (s2_fe_F2 - s2_fi_F2)^2)
distance_speaker3 = sqrt((s3_fe_F1 - s3_fi_F1)^2 + (s3_fe_F2 - s3_fi_F2)^2)
distance_speaker4 = sqrt((s4_fe_F1 - s4_fi_F1)^2 + (s4_fe_F2 - s4_fi_F2)^2)

# Print the results
writeInfoLine: "Distance between vowels for Speaker 1: ", distance_speaker1
appendInfoLine: "Distance between vowels for Speaker 2: ", distance_speaker2
appendInfoLine: "Distance between vowels for Speaker 3: ", distance_speaker3
appendInfoLine: "Distance between vowels for Speaker 4: ", distance_speaker4