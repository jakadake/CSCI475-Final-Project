#############################################################################
#
#   analysis.py
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

def generate_waveforms(orig: str, auto: str):
    sounds = [pm.Sound(orig),
              pm.Sound(auto)]
    plt.figure(figsize=(38.4, 21.6))

    for i, snd in enumerate(sounds):
        plt.subplot(3, 1, i+1)
        plt.plot(snd.xs(), snd.values.T)
        plt.xlim([snd.xmin, snd.xmax])
        if i == 0:
            plt.title(orig.replace(".wav", ""), fontsize=40)
        else:
            plt.title(auto.replace(".wav", ""), fontsize=40)
        plt.xlabel("time [s]", fontsize=40)
        plt.xticks(fontsize=20)
        plt.ylabel("amplitude [Hz]", fontsize=40)
        plt.yticks(fontsize=20)
    plt.tight_layout()
    plt.savefig("waveforms.png", bbox_inches='tight')
    return True
def generate_spectrograms(orig: str, auto: str, d_r = 70):
    sounds = [pm.Sound(orig),
              pm.Sound(auto)]

    plt.figure(figsize=(38.4, 21.6))

    for i, snd in enumerate(sounds):
        plt.subplot(3, 1, i+1)
        spect = sounds[i].to_spectrogram()
        X, Y = spect.x_grid(), spect.y_grid()
        sg_db = 10 * np.log10(spect.values)
        plt.pcolormesh(X, Y, sg_db, vmin=sg_db.max() - d_r, label="spect", cmap='magma', alpha=0.7)
        plt.ylim([spect.ymin, 5000])
        if i == 0:
            plt.title(orig.replace(".wav", ""), fontsize=40)
        else:
            plt.title(auto.replace(".wav", ""), fontsize=40)
        plt.xlabel("time [s]", fontsize=40)
        plt.xticks(fontsize=20)
        plt.ylabel("frequency [Hz]", fontsize=40)
        plt.yticks(fontsize=20)
    # end for
    plt.tight_layout()
    plt.savefig("spectrograms.png", bbox_inches='tight')

def main():
    orig = "original.wav"
    auto = "automated.wav"

    exist = path.exists(orig) \
            and path.exists(auto)
    corr_format = orig.endswith(".wav") \
                  and auto.endswith(".wav")

    if exist and corr_format:
        generate_spectrograms(orig, auto)
        generate_waveforms(orig, auto)
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
