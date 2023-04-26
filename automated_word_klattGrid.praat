# automated_word_klattGrid.praat

# DESCRIPTION OF PROGRAM
    # This script creates a klattGrid from a sound file in Praat.
    # You will need a sound file with a textgrid, in which one tier contains boundaries around each
    # segment and each segment in that tier has a "1" or "0" if it is or is not a fricative, respectively.
    # Choose this tier number when the script asks for a tier number.
    # To run the script, click Run > Run on the menu at the top of this window.

# CREDITS
    # This script was created by Hannah Loukusa and Jacob Haapoja in 2023 in Praat, Version 6.1.38
    # The following sources were used in the scripting process:
    # We can list sources here...


#----------------------------------------------------------------------------------------------------------


#CREATES FORM WITH INSTRUCTIONS
form Start up instructions
	comment ----------------------------------------------------------------------------------------------------------------------------
	comment WELCOME!
	comment INSTRUCTIONS
	comment 1. Open the sound and texgrid files in the Praat Objects window.
	comment 2. In the Praat Objects window, assure the sound and textgrid files are selected.
	comment 3. Fill in the boxes below as instructed.
	comment ----------------------------------------------------------------------------------------------------------------------------
	comment Enter the tier number that contains ones and zeros
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

#EXTRACTS DURATION OF INTERVAL BEFORE WORD BEGINS, CALLED SILENCE DURATION
    selectObject: textgrid
       interval_label$ = Get label of interval: get_data_from_tier, 1
       if interval_label$ == ""
          t1 = Get starting point: get_data_from_tier, 1
          t2 = Get end point: get_data_from_tier, 1
	  silence_duration = t2 - t1
       else
	  silence_duration = 0.0
       endif

appendInfoLine: silence_duration

#CALCULATES DURATION OF WORD
    total_duration = 0.0
    selectObject: textgrid
	n = Get number of intervals: get_data_from_tier
	for i to n
	   interval_label$ = Get label of interval: get_data_from_tier, i
	   if interval_label$ <> ""
              t1 = Get starting point: get_data_from_tier, i
              t2 = Get end point: get_data_from_tier, i
	      dur = t2-t1
	      total_duration = total_duration + dur
	   endif
	endfor

appendInfoLine: total_duration

klattGrid = Create KlattGrid: "from your word", 0, total_duration, 6, 1, 1, 6, 1, 1, 1

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
	  t1_klatt = t1-silence_duration
          t2 = Get end point: get_data_from_tier, i
	  t2_klatt = t2-silence_duration
          selectObject: pitch
          f0 = Get mean: t1, t2, "Hertz"
	  f0 = round(f0)
	  f0$ = fixed$(f0,0)
	  selectObject: formant
	  f1 = Get mean: 1, t1, t2, "Hertz"
	  f2 = Get mean: 2, t1, t2, "Hertz"
	  f3 = Get mean: 3, t1, t2, "Hertz"
	  f4 = Get mean: 4, t1, t2, "Hertz"
	  f1$ = fixed$(f1,0)
	  f2$ = fixed$(f2,0)
	  f3$ = fixed$(f3,0)
	  f4$ = fixed$(f4,0)
	  selectObject: intensity
	  int = Get mean: t1, t2, "energy"
	  int$ = fixed$(int,0)

	  selectObject: klattGrid

	  Add pitch point: t1_klatt, f0
	  Add voicing amplitude point: t1_klatt, int

	if interval_label$ == "0"
	  Add frication amplitude point: t1_klatt, 5
	  Add frication bypass point: 0.5, t1_klatt
	elsif interval_label$ == "1"
	  Add frication amplitude point: t1_klatt, 60
	  Add frication bypass point: 0.5, t1_klatt
	  Add voicing amplitude point: t1_klatt+0.103, 0
	else
	  exitScript: "Please place zeros and ones in the frication tier."
	endif

	  Add oral formant frequency point: 1, t1_klatt, f1
	  Add oral formant bandwidth point: 1, t1_klatt, f1*0.2

	  Add oral formant frequency point: 2, t1_klatt, f2
	  Add oral formant bandwidth point: 2, t1_klatt, f2*0.2

	  Add oral formant frequency point: 3, t1_klatt, f3
	  Add oral formant bandwidth point: 3, t1_klatt, f3*0.2

	  Add oral formant frequency point: 4, t1_klatt, f4
	  Add oral formant bandwidth point: 4, t1_klatt, f4*0.2

	  selectObject: textgrid

       endif
    endfor  
selectObject: sound, textgrid
