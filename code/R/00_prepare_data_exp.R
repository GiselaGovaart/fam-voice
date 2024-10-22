# In this file, write the R-code necessary to load your original data file
# (e.g., an SPSS, Excel, or SAS-file), and convert it to a data.frame. Then,
# use the function open_data(your_data_frame) or closed_data(your_data_frame)
# to store the data.

# load packages --------------------------------------------------------------------
library(worcs)
library(here)
library(tidyr)
library(dplyr)
here()

# EXPERIMENTAL DATA ---------------------------------------------------------------------
## ACQUISTION --------------------------------------------------------------------
### TIME WINDOW prereg: 200 ms around peak --------------------------------------------------------------------

# Read csv amplitude
t = read.delim(here("data", "amplitudes_acq_200ms-peak.txt"), header = TRUE, sep = "\t", dec = ".")

# Combine 101 and 102, call it 101
t[is.na(t)] <- 0
t[1,] = t[1,] + t[2,]
t[1,1] = 101
t=t[-2,]

# Combine 221 and 222, call it 221
t[4,] = t[4,] + t[5,]
t[4,1] = 221
t=t[-5,]

# Combine 231 and 232, call it 231
t[7,] = t[7,] + t[8,]
t[7,1] = 231
t=t[-8,]

# compute MMR: deviant minus standard, and rename the conditions. 1 = TrainVoice (S1 or S2), 3 = FamNonTrainVoice (S3), 4 = NovelVoice (S4)
t[1,] = t[1,] - (t[4,]+t[7,])/2
t[1,1] = 1

t[2,] = t[2,] - (t[5,]+t[8,])/2
t[2,1] = 3

t[3,] = t[3,] - (t[6,]+t[9,])/2
t[3,1] = 4

t=t[-9,]
t=t[-8,]
t=t[-7,]
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

# take out the zeros from the subject names
t$Subj <- sub("^0", "", t$Subj)

# Read csv demographics
t_demo = read.delim(here("data", "demographic_data_FamVoice_exp.csv"), header = TRUE, sep = ",", dec = ".")

# Create the new column MMR in t_demo
t_demo <- t_demo %>%
  mutate(MMR = NA)  # Initialize MMR column with NA

# Fill the MMR column based on values from t
for (i in 1:nrow(t_demo)) {
  subjnr <- t_demo$Subj[i]
  speaker <- t_demo$Testspeaker[i]
  
  # Check if the combination exists in t
  if (subjnr %in% t$Subj && speaker %in% colnames(t)) {
    t_demo$MMR[i] <- t[t$Subj == subjnr, speaker]
  }
}

# Move MMR to the second column
t_demo <- t_demo %>%
  select(Subj, MMR, everything())  













# The arguments to gather():
# - data: Data object
# - key: Name of new key column (made from names of data columns)
# - value: Name of new value column
# - ...: Names of source columns that contain values
# - factor_key: Treat the new key column as a factor (instead of character vector)
data_long = gather(t, TestSpeaker, MMR, "S1":"S4", factor_key=TRUE)

# Save data
data_pilot <- data_long
setwd(here("data"))
# do the following only once
# worcs:::write_worcsfile(".worcs")
open_data(data_pilot, worcs_directory = ".")
setwd(here())


# Experimental data ---------------------------------------------------------
### ACQUISTION ----------------------------------------------------------------------------------------
## ADD

### RECOGNITION ----------------------------------------------------------------------------------------
## ADD

