
import parselmouth
import numpy as np
from scipy.signal import medfilt
import matplotlib.pyplot as plt

def draw_spectrogram(spectrogram, dynamic_range = 70):
    X, Y = spectrogram.x_grid(), spectrogram.y_grid()
    sg_db = 10*np.log10(spectrogram.values)
    plt.pcolormesh(X, Y, sg_db, vmin=sg_db.max() - dynamic_range,label="spectrogram", cmap='binary', alpha=0.7)
    plt.ylim([spectrogram.ymin, 5000])
    plt.xlabel("time [s]")
    plt.ylabel("frequency [Hz]")

def draw_intensity(intensity):
    plt.plot(intensity.xs(), intensity.values.T, linewidth = 3, color = 'w')
    plt.plot(intensity.xs(), intensity.values.T, linewidth=1)
    plt.grid(True)
    plt.ylim(0, 100)
    plt.ylabel("intensity [dB]")

def clean_formants(pitch, formants, intensity):
    numFrames = formants.get_number_of_frames()

    pitch_values = []
    f1_values = []
    f2_values = []
    f3_values = []
    f4_values = []
    times = []
    intensity_values = []

    for k in range(numFrames):
        frameTime = formants.get_time_from_frame_number(k + 1)
        times.append(frameTime)
        intensityAtTime = intensity.get_value(frameTime)
        intensity_values.append(intensityAtTime)
        if intensityAtTime < 52:
            pitch_values.append(0)
            f1_values.append(0)
            f2_values.append(0)
            f3_values.append(0)
            f4_values.append(0)
        else:
            pitch_values.append(pitch.get_value_at_time(frameTime))
            f1_values.append(formants.get_value_at_time(1, frameTime))
            f2_values.append(formants.get_value_at_time(2, frameTime))
            f3_values.append(formants.get_value_at_time(3, frameTime))
            f4_values.append(formants.get_value_at_time(4, frameTime))
    return [pitch_values, f1_values, f2_values, f3_values, f4_values, times, intensity_values]

def smooth_formants(values, kernSize = 3):
    if kernSize%2 == 0:
        kernSize += 1

    filtered_pitch = medfilt(values[0], kernel_size=kernSize)
    filtered_f1 = medfilt(values[1], kernel_size=kernSize)
    filtered_f2 = medfilt(values[2], kernel_size=kernSize)
    filtered_f3 = medfilt(values[3], kernel_size=kernSize)
    filtered_f4 = medfilt(values[4], kernel_size=kernSize)
    return [filtered_pitch, filtered_f1, filtered_f2, filtered_f3, filtered_f4, values[5], values[6]]


def draw_values(values, spec, snd):  # Plot pitch, formants 1-4, intensity, and spectrogram
    fig = plt.figure(figsize=(12.8, 7.2))     #set figure to 1280x720

    draw_spectrogram(spec)  #plot spectrogram in background
    # pitch plotted in red
    plt.scatter(values[5], values[0], label='Pitch', color='r', linewidths=1)
    # F1 plotted in orange
    plt.scatter(values[5], values[1], label='F1', color='#FFA500', linewidths=1)
    # F2 plotted in yellow
    plt.scatter(values[5], values[2], label='F2', color='y', linewidths=1)
    # F3 plotted in green
    plt.scatter(values[5], values[3], label='F3', color='g', linewidths=1)
    # F4 plotted in blue
    plt.scatter(values[5], values[4], label='F4', color='b', linewidths=1)

    plt.xlim([snd.xmin, snd.xmax])  #limit x to only existing values in the sound

    #axis labels
    plt.xlabel("time [s]")
    plt.ylabel("frequency [Hz]")

    plt.legend() #show table of color to formant correspondance

    plt.twinx() #overlay a second graph w/ different y axis

    plt.ylabel("intensity [dB]") #set y axis label for second plot
    #graph intensity over time on top of formants
    plt.plot(values[5], values[6], label='Intensity')

    plt.xlim([snd.xmin, snd.xmax])  #restrict x in the new graph

    plt.legend()    #identify second graph as intensity
    return fig

def main():
    # Load the sound file
    snd = parselmouth.Sound("Thats One Small.wav")
    #get spectrogram
    spec = snd.to_spectrogram()
    #get intensity
    intensity = snd.to_intensity(time_step=0.005)
    # Get the formants
    formants = snd.to_formant_burg(time_step=0.005)
    # Get the pitch
    pitch = snd.to_pitch(time_step=0.005)

    # Extract the formant values and times
    values = clean_formants(pitch, formants, intensity)

    # Apply median filtering to denoise the formants
    filtered_values = smooth_formants(values)

    #draw unaltered values
    fig = draw_values(values, spec, snd)
    fig.show()

    #draw filtered values
    filtFig = draw_values(filtered_values, spec, snd)
    filtFig.show
    input("press any key to exit... ")
    return 0

if __name__ == "__main__":
    main()