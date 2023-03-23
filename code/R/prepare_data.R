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

# Combine 101 and 102, call it 101
t[is.na(t)] <- 0
t[1,] = t[1,] + t[2,]
t[1,1] = 101
t=t[-2,]

# Combine 231 and 232, call it 231
t[4,] = t[4,] + t[5,]
t[4,1] = 231
t=t[-5,]

# transpose
t = t(t)

# fix row and columnnames
colnames(t) <- t[1,]
t <- t[-1, ] 
rownames(t) <- sub("X", "", rownames(t))
t <- cbind(rownames(t), data.frame(t, row.names=NULL))
colnames(t)[1]="subj"
t$subj <- factor(t$subj)
colnames(t) <- sub("X", "", colnames(t))

# The arguments to gather():
# - data: Data object
# - key: Name of new key column (made from names of data columns)
# - value: Name of new value column
# - ...: Names of source columns that contain values
# - factor_key: Treat the new key column as a factor (instead of character vector)
data_long = gather(t, condition, amplitude, "101":"234", factor_key=TRUE)

speaker = NA
data_long <- cbind(data_long[,1:2], speaker, data_long[,3]) 
colnames(data_long)[4]="amplitude"
data_long$condition = as.character(data_long$condition)

data_long$speaker = substr(data_long$condition, start = 3, stop = 3)
data_long$condition = substr(data_long$condition, 1, nchar(data_long$condition)-1)

# Save data
data_pilot <- data_long

setwd(here("data"))
# do the following only once
# worcs:::write_worcsfile(".worcs")
open_data(data_pilot, worcs_directory = ".")
setwd(here())



