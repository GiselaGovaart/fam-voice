# Readme <a href='https://osf.io/zcvbs/'><img src='worcs_icon.png' align="right" height="139" /></a>

This repository contains the scripts for two papers:
1. Govaart, G. H., Chladkova, K., Schettino, A., & Männel, C. (subm.). Does the Speaker Matter: EEG Evidence on the Influence of 
Voice Information on Phoneme Learning in Infancy.
2. Govaart, G. H., Chladkova, K., Schettino, A., & Männel, C. (in prep.). Is there a Voice-Familiarity Benefit for Phoneme Recognition in Infancy?

Scripts that are specific to paper 1 are marked with "acq" or "A", whereas scripts that are specific to paper 2 are marked with "rec" (or "recfam" for the exploratory analysis) or "R". In folders where this distinction applies, a dedicated README is included.

## Preregistration
Both papers were preregistered (under embargo) on 15 August 2024 on the OSF. Upon publication, the pregistration will become public.

The code for the preregistration can be found in prereg_codeData. Please note that also here, files that are specific to paper 1 are marked with "acq" or "A", whereas files that are specific to paper 2 are marked with "rec" or "R". 

## Where do I start?
You can load this project in RStudio by opening the file called 'FamVoiceWORCS.Rproj'.

## Project structure

<!--  You can add rows to this table, using "|" to separate columns.         -->
File                      | Description                      | Usage         
------------------------- | -------------------------------- | --------------
README.md                 | Description of project           | Human editable
FamVoiceWORCS.Rproj       | Project file                     | Loads project 
LICENSE                   | User permissions                 | Read only     
.worcs                    | WORCS metadata YAML              | Read only     
renv.lock                 | Reproducible R environment       | Read only     
code/                     | Matlab, R and praat code         | Human editable  
data/                     | input and output data            | Human editable  
stimuli/                  | stimuli used for the experiments | Read only  
materials/                | extra materials                  | Read only  


<!--  You can consider adding the following to this file:                    -->
<!--  * A citation reference for your project                                -->
<!--  * Contact information for questions/comments                           -->
<!--  * How people can offer to contribute to the project                    -->
<!--  * A contributor code of conduct, https://www.contributor-covenant.org/ -->

# Questions/Comments
Contact: g.h.govaart@gmail.com

# Reproducibility

This project uses the Workflow for Open Reproducible Code in Science (WORCS) to
ensure transparency and reproducibility. The workflow is designed to meet the
principles of Open Science throughout a research project. 

To learn how WORCS helps researchers meet the TOP-guidelines and FAIR principles,
read the preprint at https://osf.io/zcvbs/

## WORCS: Advice for readers

Please refer to the vignette on [reproducing a WORCS project](https://cjvanlissa.github.io/worcs/articles/reproduce.html) for step by step advice.
<!-- If your project deviates from the steps outlined in the vignette on     -->
<!-- reproducing a WORCS project, please provide your own advice for         -->
<!-- readers here.                                                           -->
