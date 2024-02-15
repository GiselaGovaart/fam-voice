# In this file, write the R-code necessary to load your original data file
# (e.g., an SPSS, Excel, or SAS-file), and convert it to a data.frame. Then,
# use the function open_data(your_data_frame) or closed_data(your_data_frame)
# to store the data.

# install packages --------------------------------------------------------------------
# install.packages(worcs)
# install.packages(here)
# install.packages(tidyr)


# load packages --------------------------------------------------------------------
library(worcs)
library(here)
library(tidyr)

here()

# Read csv
t=read.delim(here("data", "amplitudes_fromMatlab.txt"), header = TRUE, sep = "\t", dec = ".")

# Set conditions:
FamGroup = c("01", "02", "04", "05", "06", "07")
UnfamGroup = c("08", "09", "10", "11", "12", "13", "15")

# Combine 101 and 102, call it 101
t[is.na(t)] <- 0
t[1,] = t[1,] + t[2,]
t[1,1] = 101
t=t[-2,]

# Combine 231 and 232, call it 231
t[4,] = t[4,] + t[5,]
t[4,1] = 231
t=t[-5,]

# compute MMR: deviant minus standard, and rename the conditions. 1 = TrainVoice (S1 or S2), 3 = FamNonTrainVoice (S3), 4 = NovelVoice (S4)
t[1,] = t[1,] - t[4,]
t[1,1] = 1

t[2,] = t[2,] - t[5,]
t[2,1] = 3

t[3,] = t[3,] - t[6,]
t[3,1] = 4

t=t[-6,]
t=t[-5,]
t=t[-4,]

# transpose
t = t(t)

# fix row and columnnames
colnames(t) <- t[1,]
t <- t[-1, ] 
rownames(t) <- sub("X", "", rownames(t))
t <- cbind(rownames(t), data.frame(t, row.names=NULL))
colnames(t)[1]="Subj"
t$Subj <- factor(t$Subj)
colnames(t) <- sub("X", "S", colnames(t))

# Add condition
t$Group = NA

for (i in 1:length(t$Subj)){
  if (t$Subj[i] %in% FamGroup){
    t$Group[i] = "fam"
  }else if (t$Subj[i] %in% UnfamGroup){
    t$Group[i] = "unfam"
  }
}

# The arguments to gather():
# - data: Data object
# - key: Name of new key column (made from names of data columns)
# - value: Name of new value column
# - ...: Names of source columns that contain values
# - factor_key: Treat the new key column as a factor (instead of character vector)
data_long = gather(t, TestSpeaker, MMR, "1":"4", factor_key=TRUE)

# Save data
data_pilot <- data_long
setwd(here("data"))
# do the following only once
# worcs:::write_worcsfile(".worcs")
open_data(data_pilot, worcs_directory = ".")
setwd(here())

# # make synthesized copy
# setwd(here("data/synth_data"))
# #worcs:::write_worcsfile(".worcs")
# closed_data(data_pilot, worcs_directory = ".")
# setwd(here())

