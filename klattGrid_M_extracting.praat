pitch# = {0.620969,   117.745359,
...0.630969,   118.091246,
...0.640969,   119.186479,
...0.650969,   122.157241,
...0.660969,   122.242414,
...0.670969,   122.954229,
...0.680969,   124.380015,
...0.690969,   125.253278,
...0.700969,   129.001194,
...0.710969,   131.299989,
...0.720969,   133.322639,
...0.730969,   135.203846}

intensity# = {0.622667,   80.347733,
...0.633333,   77.659404,
...0.644000,  76.968778,
...0.654667,   76.993582,
...0.665333,   77.340863,
...0.676000,   78.130284,
...0.686667,   78.832734,
...0.697333,   79.094637,
...0.708000,   79.088316,
...0.718667,   79.671605,
...0.729333,   81.704176}

# ASSURES FILES ARE SELECTED
    if numberOfSelected ("Sound") <> 1
       exitScript: "Please select a Sound object."
    endif
    sound = selected ("Sound")

# CREATES PITCH, FORMANT, AND INTENSITY OBJECTS
pitch_time_step = 0.01
minimum_pitch = 75
maximum_pitch = 500
selectObject: sound
pitch = To Pitch: pitch_time_step, minimum_pitch, maximum_pitch
maximum_number_of_formants = 5
maximum_formant = 5500
window_length = 0.025
preemphasis_from = 50
selectObject: sound
formant = To Formant (burg): 0, maximum_number_of_formants, maximum_formant, window_length, preemphasis_from
minimum_int_pitch = 100
int_time_step = 0.0
selectObject: sound
intensity = To Intensity: minimum_int_pitch, int_time_step

# CREATES KLATT GRID
# PARAMETERS:
# Create KlattGrid... name startTime endTime ??????????
klattGrid = Create KlattGrid... m  0 0.115 6 1 1 6 1 1 1

# CREATES PITCH POINTS
# PARAMETERS: 
# Add pitch point... time pitch@time
pitchTimeStep = 0.01
for step from 0 to 11
	Add pitch point... step*pitchTimeStep pitch# [2+2*step]
endfor

# CREATES INTENSITY POINTS
# PARAMETERS: 
# Add voicing amplitude point... time intensity@time
intTimeStep = pitchTimeStep
for step from 0 to 10
	Add voicing amplitude point... step*intTimeStep intensity# [2+2*step]
endfor

# CREATES FORMANT POINTS
# PARAMETERS:
# f1-4 = Get value at time: formantNumber time unit interpolation
formantTimeStep = 0.006
startTime = 0
endTime = 0.115
selectObject: formant
f1_mean = Get mean: 1, startTime, endTime, "Hertz"
f2_mean = Get mean: 2, startTime, endTime, "Hertz"
f3_mean = Get mean: 3, startTime, endTime, "Hertz"
f4_mean = Get mean: 4, startTime, endTime, "Hertz"
# if formant is undefined, set to mean value
for step from 0 to 18
	time = step*formantTimeStep
	selectObject: formant
	f1 = Get value at time: 1, time, "hertz", "linear"
	f2 = Get value at time: 2, time, "hertz", "linear"
	f3 = Get value at time: 3, time, "hertz", "linear"
	f4 = Get value at time: 4, time, "hertz", "linear"
	selectObject: klattGrid
	Add oral formant frequency point... 1 time f1
	Add oral formant bandwidth point... 1 time f1*0.20
	Add oral formant frequency point... 2 time f2
	Add oral formant bandwidth point... 2 time f2*0.20
	Add oral formant frequency point... 3 time f3
	Add oral formant bandwidth point... 3 time f3*0.20
	Add oral formant frequency point... 4 time f4
	Add oral formant bandwidth point... 4 time f4*0.20
endfor

Play