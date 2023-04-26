#############################################################################
#
#   main.py
#
#       Desc: A script meant for visualizing audio data from .wav files
#
#       Pre: sounds labeled original.wav, automated.wav, and manual.wav exist
#           in the same folder as this .py script
#
#       post: two .png format images are generated, one showing the waveforms
#           and the other showing the spectrograms for all three sounds
#           stacked vertically
#
#############################################################################

import parselmouth as pm
import numpy as np
import matplotlib.pyplot as plt
import os.path as path

def generate_waveforms(orig: str, auto: str, man: str)
    return True
def generate_spectrograms(orig: str, auto: str, man: str):
        sounds = [pm.Sound(orig),
                  pm.Sound(auto),
                  pm.Sound(man)]

        plt.figure(figsize=(10.8, 19.2))

        for i, snd in enumerate(sounds):
            plt.subplot(3, 1, i+1)
            spect = sounds[i].to_spect()
            X, Y = spect.x_grid(), spect.y_grid()
            sg_db = 10 * np.log10(spect.values)
            plt.pcolormesh(X, Y, sg_db, vmin=sg_db.max() - dynamic_range, label="spect", cmap='binary', alpha=0.7)
            plt.ylim([spect.ymin, 5000])
            plt.xlabel("time [s]")
            plt.ylabel("frequency [Hz]")


def main():
    orig = "original.wav"
    auto = "automatic.wav"
    man = "manual.wav"

    exist = path.exists(orig) \
            and path.exists(auto) \
            and path.exists(man)
    corr_format = orig.endswith(".wav") \
                  and auto.endswith(".wav") \
                  and man.endswith(".wav")

    if exist and corr_format:
        generate_spectrograms(orig, auto, man)
        generate_waveforms(orig, auto, man)
        return True
    else:
        print("Files not found.\n"
              "Make sure that all three wave files below exist in the source directory:\n"
              "original.wav\n"
              "automatic.wav\n"
              "manual.wav\n"
              "\n"
              "Exiting...")
        return False


if __name__ == '__main__':
    main()
