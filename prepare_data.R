# In this file, write the R-code necessary to load your original data file
# (e.g., an SPSS, Excel, or SAS-file), and convert it to a data.frame. Then,
# use the function open_data(your_data_frame) or closed_data(your_data_frame)
# to store the data.

library(worcs)
library(here)

here()

# Read csv
t=read.delim(here("/data/amplitudes.txt"), header = TRUE, sep = "\t", dec = ".")




# Combine 101 and 102 
t[is.na(t)] <- 0
t[1,] = t[1,] + t[2,]
t[1,1] = 101
t=t[-2,]

t[4,] = t[4,] + t[5,]
t[4,1] = 231
t=t[-5,]

write.csv(t, here("amplitudes_pilot_famvoice.csv"), row.names=FALSE)
