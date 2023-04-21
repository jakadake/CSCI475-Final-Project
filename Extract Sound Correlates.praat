
# EXTRACT SOUND CORRELATES

# DESCRIPTION OF PROGRAM
    # This script extracts F0, F1-F4, duration, and intensity from a sound file in Praat.
    # To extract data with this script, you need a sound file with a textgrid, in which one tier contains boundaries around each
    # segment and each segment in that tier has text in it. Choose this tier number when the script asks for it.
    # To run the script, click Run > Run on the menu at the top of this window.

# CREDITS
    # This script was created by Hannah Loukusa in 2023 in Praat, Version 6.1.38
    # The following sources were used in the scripting process:
    # 1. https://www.fon.hum.uva.nl/praat/manual/Script_for_analysing_pitch_with_a_TextGrid.html
    # 2. https://aherrerodeharo.files.wordpress.com/2021/08/praat-script.-f1-f2-duration-pitch-intensity.docx?force_download=true
    #    Created by Dr. Alfredo Herrero de Haro, University of Wollongong, Australia (Aug, 2020) by modifying a scrip by Shigeto Kawahara (3 Feb 2010).

# ACCURACY OF THIS SCRIPTING PROCESS
    # Average error values for this script are as follows:
    # F0 = 1.63%   F1 = 0.33%   F2 = 0.49%   F3 = 0.44%   F4 = 0.48%   Dur = 0.22%   Int = 0.69%
    # The following formula was used to calculate error:
    # Error = 100 * (accepted value - experimental value) / accepted value
    # Error values were based on the mean differences between data collected manually (accepted value) and using this script (experimental value)
    # from two sound files in Praat. The sound files contained a total of 4473 data points.

# -------------------------------------------------------------

# Extract Sound Correlates (the code begins here dun dun dun)

#CREATES FORM WITH INSTRUCTIONS
form Start up instructions
	comment ----------------------------------------------------------------------------------------------------------------------------
	comment WELCOME!
	comment INSTRUCTIONS
	comment 1. Open the sound and texgrid files in the Praat Objects window.
	comment 2. In the Praat Objects window, assure the sound and textgrid files are selected.
	comment 3. Fill in the boxes below as instructed.
	comment ----------------------------------------------------------------------------------------------------------------------------
	comment Enter the path of the folder where you want to store your csv file, 
	comment Then add a / or \ followed by your desired file name and then .csv
	comment Format for mac: location/filename.csv | Format for windows: location\filename.csv
  	text resultsfile C:\Users\Hannah\Downloads\YourFileName.csv
  	comment Enter the tier number from which you wish to extract data
	integer get_data_from_tier 4
	comment Formant analysis parameters
  	integer maximum_number_of_formants 5
 	positive maximum_formant 5500
  	positive window_length 0.025
  	real preemphasis_from 50
  	comment Pitch analysis parameters
  	positive time_step 0.01
  	positive minimum_pitch 75
  	positive maximum_pitch 500
	#comment Center of Gravity parameters
	positive power 2
endform

#ASSURES FILES ARE SELECTED
    if numberOfSelected ("Sound") <> 1 or numberOfSelected ("TextGrid") <> 1
       exitScript: "Please select a Sound and a TextGrid first."
    endif
    sound = selected ("Sound")
    textgrid = selected ("TextGrid")


# CHECK IF RESULTS FILE ALREADY EXISTS
if fileReadable (resultsfile$)
	pause The file 'resultsfile$' already exists! Do you want to overwrite it? 
	pause If overwriting the file, make sure the file is not open on your computer
	filedelete 'resultsfile$'
endif


#CREATES CSV FILE
    outFile4$ = "'resultsfile$'"
    sep$ = tab$

#EXTRACTS AVERAGE PITCH, F1-F4, DURATION, INTENSITY, JITTER, SHIMMER AND HNR OF EACH INTERVAL THAT CONTAINS TEXT IN CHOSEN TIER
#(AN INTERVAL IS A SECTION BETWEEN BOUNDARIES)
# t1 AND t2 REFER TO START AND END TIME OF AN INTERVAL. "Hertz" AND "energy" REFER TO SETTINGS FOR F0, F1-F4, and INTENSITY.
    writeFileLine: outFile4$, "segment, F0, F1, F2, F3, F4, Dur, Int, Jit, Shim, HNR"
    selectObject: sound
    pitch = To Pitch: time_step, minimum_pitch, maximum_pitch
    selectObject: sound
    intensity = To Intensity: 100, 0
    selectObject: sound
    formant = To Formant (burg): 0, maximum_number_of_formants, maximum_formant, window_length, preemphasis_from
    selectObject: sound
    pitch_cc = To Pitch (cc): 0.0, 75.0, 15, "no", 0.03, 0.45, 0.01, 0.35, 0.14, 500.0
    selectObject: sound, pitch_cc
    pointProcess = To PointProcess (cc)
    #periodicity = To PointProcess (periodic, peaks): 75, 500, "yes", "no"
    selectObject: sound
    harmonicity = To Harmonicity (ac): 0.01, 75.0, 0.1, 4.5
    selectObject: sound
    spectro = To Spectrogram: 0.005, 5000, 0.002, 20, "Gaussian"
    selectObject: textgrid
    n = Get number of intervals: get_data_from_tier
    for i to n
       tekst$ = Get label of interval: get_data_from_tier, i
       if tekst$ <> ""
	  rg$ = Get label of interval: get_data_from_tier, i
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
	  dur = t2 - t1
	  dur$ = fixed$ (dur,3)
	  selectObject: intensity
	  int = Get mean: t1, t2, "energy"

	  #selectObject: periodicity
	  selectObject: pointProcess
	  jit = Get jitter (local): t1, t2, 0.0001, 0.02, 1.3
	  jit = jit*100
	  jit$ = fixed$ (jit,2)
	  
	  #selectObject: periodicity, sound
	  selectObject: pointProcess, sound
	  shim = Get shimmer (local): t1, t2, 0.0001, 0.02, 1.3, 1.6
	  shim = shim*100
	  shim$ = fixed$ (shim,2)

	  selectObject: harmonicity
	  hnr = Get mean: t1, t2

          #selectObject: sound
    	  #spectrum = To Spectrum... Fast
	  #selectObject: spectrum
    	  #j=2*i
	  #time = (t1+t2)/2
	  #time$ = fixed(time,3)
	  #selectObject: spectro
	  #To Spectrum (slice): time

	  #selectObject: spectrum
	  #list$ = List: "yes", "yes", "no", "no", "no", "yes"
	  #writeLine: list$

   	  #cog = Get centre of gravity... 2

	 # Edit
	  #editor: sound
	  #  Move cursor to: number(time$)
   	  #  View spectral slice
	#  Close

          selectObject: textgrid
	  appendFileLine: outFile4$, rg$ ,",",
			...round(f0) ,",",
			...round(f1) ,",",
			...round(f2) ,",",
			...round(f3) ,",",
			...round(f4) ,",",
			...dur$ ,",",
			...round(int) ,",",
			...jit$ ,",",
			...shim$ ,",",
			...round(hnr)
       endif
    endfor  
selectObject: sound, textgrid