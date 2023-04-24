# tell user to put zeros for no frication and ones for frication

#CREATES FORM WITH INSTRUCTIONS
form Start up instructions
	comment ----------------------------------------------------------------------------------------------------------------------------
	comment WELCOME!
	comment INSTRUCTIONS
	comment 1. Open the sound and texgrid files in the Praat Objects window.
	comment 2. In the Praat Objects window, assure the sound and textgrid files are selected.
	comment 3. Fill in the boxes below as instructed.
	comment ----------------------------------------------------------------------------------------------------------------------------
  	comment Enter the tier number from which you wish to extract data
	integer get_data_from_tier 3
	comment Formant analysis parameters
  	integer maximum_number_of_formants 5
 	positive maximum_formant 5500
  	positive window_length 0.025
  	real preemphasis_from 50
  	comment Pitch analysis parameters
  	positive pitch_time_step 0.01
  	positive minimum_pitch 75
  	positive maximum_pitch 500
	comment Intensity analysis parameters
	positive maximum_intensity 100
	positive int_time_step 0.01
	
endform

#ASSURES FILES ARE SELECTED
    if numberOfSelected ("Sound") <> 1 or numberOfSelected ("TextGrid") <> 1
       exitScript: "Please select a Sound and a TextGrid first."
    endif
    sound = selected ("Sound")
    textgrid = selected ("TextGrid")

    total_duration = 0
    selectObject: textgrid
    n = Get number of intervals: get_data_from_tier
    for i to n
       interval_label$ = Get label of interval: get_data_from_tier, i
       if interval_label$ <> ""
          t1 = Get starting point: get_data_from_tier, i
          t2 = Get end point: get_data_from_tier, i
	  dur = t2 - t1
	  total_duration = total_duration + dur
	  dur$ = fixed$ (dur,3)
       endif
    endfor


klattGrid = Create KlattGrid: "asamala", 0, total_duration, 6, 1, 1, 6, 1, 1, 1


#EXTRACTS AVERAGE PITCH, F1-F4, AND INTENSITY OF EACH INTERVAL THAT CONTAINS TEXT IN CHOSEN TIER
#(AN INTERVAL IS A SECTION BETWEEN BOUNDARIES)
# t1 AND t2 REFER TO START AND END TIME OF AN INTERVAL. "Hertz" AND "energy" REFER TO SETTINGS FOR F0, F1-F4, and INTENSITY.
    selectObject: sound
    pitch = To Pitch: pitch_time_step, minimum_pitch, maximum_pitch
    selectObject: sound
    intensity = To Intensity: maximum_intensity, int_time_step
    selectObject: sound
    formant = To Formant (burg): 0, maximum_number_of_formants, maximum_formant, window_length, preemphasis_from
    selectObject: textgrid
    n = Get number of intervals: get_data_from_tier
    for i to n
       interval_label$ = Get label of interval: get_data_from_tier, i
       if interval_label$ <> ""
          t1 = Get starting point: get_data_from_tier, i
          t2 = Get end point: get_data_from_tier, i
          selectObject: pitch
          f0 = Get mean: t1, t2, "Hertz"
	  f0 = round(f0)
	  f0$ = fixed$(f0,0)
	  selectObject: formant
	  f1 = Get mean: 1, t1, t2, "Hertz"
	  f2 = Get mean: 2, t1, t2, "Hertz"
	  f3 = Get mean: 3, t1, t2, "Hertz"
	  f4 = Get mean: 4, t1, t2, "Hertz"
	  selectObject: intensity
	  int = Get mean: t1, t2, "energy"

	  selectObject: klattGrid

	  Add pitch point: t1, f0
	  Add voicing amplitude point: t1, int

	if interval_label$ == "0"
	  Add frication amplitude point: t1, 5
	  Add frication bypass point: 0.5, t1
	elsif interval_label$ == "1"
	  Add frication amplitude point: t1, int*0.9
	  Add frication bypass point: 0.5, t1
	else
	  exitScript: "Please place zeros and ones in the frication tier."
	endif

	  Add oral formant frequency point: 1, t1, f1
	  Add oral formant bandwidth point: 1, t1, 137

	  Add oral formant frequency point: 2, t1, f2
	  Add oral formant bandwidth point: 2, t1, 147

	  Add oral formant frequency point: 3, t1, f3
	  Add oral formant bandwidth point: 3, t1, 277

	  Add oral formant frequency point: 4, t1, f4
	  Add oral formant bandwidth point: 4, t1, 751

	  selectObject: textgrid

       endif
    endfor  
selectObject: sound, textgrid
