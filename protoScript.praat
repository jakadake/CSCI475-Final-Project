sound = selected (Sound)
tg = selected (TextGrid)

time_step = 0.01
min_pitch = 75
max_pitch = 500
max_num_formants = 5
max_formant = 5500
window_length = 0.025
pre_empth_from = 50

selectObject: sound

pitch = To Pitch: time_step min_pitch max_pitch
formants = To Formant (burg): 0, max_num_formants, max_formant, window_length, pre_emph_from
intensity = To Intensity: min_pitch, time_step
int_start_times = tg