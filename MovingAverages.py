import numpy as np
import math.floor as floor

def trailingAvg(movingList, frameSize = 3):
    avgList = []
    for k in range(len(movingList)):
        averageSum = 0
        divisor = 0
        for n in range(frameSize):
            if k-n >= 0:
                divisor += 1
                averageSum += movingList[k-n]
        avgList.append(averageSum/divisor)
        #print(avgList)

    return avgList

def middleAvg(movingList, frameSize = 3):
    if (frameSize % 2 == 0):
        frameSize += 1

    #avgList = []
    #for k in range(floor(frameSize/2)):
    #    avgList.append(movingList[k])
    avgList = []
    for k in range(len(movingList)):
        averageSum = 0
        divisor = 0
        for n in range(-floor(frameSize/2), floor(frameSize/2)):
            if k - n >= 0 and k-n<= len(movingList) -1:
                divisor += 1
                averageSum += movingList[k - n]
        avgList.append(averageSum / divisor)
        # print(avgList)

def printpi():
    print(math.pi)

def main():
    movingList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    frameSize = 3
    newAverage = middleAvg(movingList, frameSize)
    print(newAverage)


if __name__ == "__main__":
    main()