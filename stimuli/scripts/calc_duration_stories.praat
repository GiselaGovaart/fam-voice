
dir$ = "../Stimuli-final/Stories/"
speaker$ = "S3"

writeInfoLine: "Durations stories"

dur_tot_1 = 0
dur_tot_2 = 0

for i from 1 to 6
	sound = Read from file: dir$ + speaker$ + "_'i'.wav"
	selectObject: sound
	dur'i' = Get total duration
	;appendInfoLine: dur'i'
	dur_tot_1 = dur_tot_1 + dur'i'
endfor

mean_16_S1 = dur1 + dur6
mean_24_S1 = dur2 + dur4
mean_35_S1 = dur3 + dur5

appendInfoLine: " --- "
appendInfoLine: " 'speaker$' "

appendInfoLine: fixed$(dur1/60, 2)
appendInfoLine: fixed$(dur2/60, 2)
appendInfoLine: fixed$(dur3/60, 2)
appendInfoLine: fixed$(dur4/60, 2)
appendInfoLine: fixed$(dur5/60, 2)
appendInfoLine: fixed$(dur6/60, 2)



