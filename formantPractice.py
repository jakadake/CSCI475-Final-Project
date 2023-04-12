import numpy as np
import parselmouth as pm
import matplotlib.pyplot as plt

snd = pm.Sound("Thats One Small.wav")

##plt.figure()
##plt.plot(snd.xs(), snd.values.T)
##plt.xlim([snd.xmin, snd.xmax])
##plt.xlabel("time [s]")
##plt.ylabel("amplitude")
##plt.show()

##sndInt = snd.to_intensity()
sndFormant = snd.to_formant_burg(time_step=0.01)

##print (sndFormant)
##timeStep = sndFormant.get_time_step()
#print(timeStep)
formantFrames = sndFormant.get_number_of_frames()
##print(formantFrames)
##intensityFrames = sndInt.get_number_of_frames()
##print(intensityFrames)
##print(sndFormant)
##print("-----------------------------------------------------------------------------")
##print(sndInt)
##

##sndFrames = snd.get_number_of_frames()

##print(sndFrames)




formant1 = []
timeSeq = []

for k in range(formantFrames):
    timeOfFrame = sndFormant.get_time_from_frame_number(k+1)
    timeSeq.append(timeOfFrame)
    formant1.append(sndFormant.get_value_at_time(1, timeOfFrame))
    ##print(len(formant1))
    #print(k)
    #print(timeOfFrame)
    #print(sndFormant.get_value_at_time(1, timeOfFrame))

plt.figure()
##plt.plot(snd.xs(), snd.values.T)
##plt.twinx()
plt.plot(timeSeq, formant1)
plt.xlim([snd.xmin, snd.xmax])
##plt.ylim([snd.ymin, snd.ymax])

plt.xlabel("time [s]")
plt.ylabel("amplitude")
plt.show()



