import pyautogui as pt
from time import sleep
import os

def check_measures():
    try:
        while True:
            x, y = pt.position()
            print(x, y)
            sleep(1)
    except KeyboardInterrupt:
        pass



def ok():
    position = None
    while position is None:
        position = pt.locateOnScreen('icons/ok.png', confidence=.9)
    x, y = position[0], position[1]
    pt.moveTo(x + 10, y + 10)
    pt.click()
    sleep(1)


def pop_newset():
    position = None
    while position is None:
        position = pt.locateOnScreen('icons/pop_newset.png', confidence=.9)
    x, y = position[0], position[1]
    pt.moveTo(x + 5, y + 5)
    pt.click()
    ok()


def load_file():
    position = pt.locateOnScreen('icons/command.png', confidence=.6)
    x, y = position[0], position[1]
    pt.moveTo(x + 50, y + 50)
    pt.click()

    pt.typewrite('eeglab', interval=.01)
    pt.press('enter')

    position = None
    while position is None:
        position = pt.locateOnScreen('icons/eeglab.png', confidence=.6)
    x, y = position[0], position[1]
    sleep(1)
    pt.moveTo(x, y)

    # Open load box
    pt.moveTo(x + 8, y + 50)
    pt.click()
    pt.moveTo(x + 104, y + 77)
    sleep(0.25)
    pt.moveTo(x + 372, y + 77)
    sleep(0.25)
    pt.moveTo(x + 674, y + 107)
    sleep(0.25)
    pt.click()

    position = None
    while position is None:
        position = pt.locateOnScreen('icons/pop_importdata.png', confidence=.6)
    x, y = position[0], position[1]

    pt.moveTo(x + 662, y + 74)
    pt.click()
    pt.moveTo(x + 667, y + 140)
    pt.click()

    pt.moveTo(x + 935, y + 72)
    pt.click()
    pt.typewrite("C:\\Users\\Milton\\PycharmProjects\\Neuro\\data\\raw\\txt\\{}".format(data), interval=.01)

    pt.moveTo(x + 869, y + 103)
    pt.click()
    pt.typewrite(data.split('.txt')[0], interval=.01)

    pt.moveTo(x + 604, y + 170)
    pt.click()
    pt.press('del')
    pt.typewrite('250', interval=.01)

    pt.moveTo(x + 1177, y + 528)
    pt.click()

    ok()


def assign_channlocs():
    pt.moveTo(960, 860)
    pt.click()
    pt.typewrite("load('chanlocs.mat');", interval=.01)
    pt.press('enter')
    pt.typewrite('EEG.chanlocs = chanlocs;', interval=.01)
    pt.press('enter')

    pt.keyDown('alt')
    sleep(.2)
    pt.press('tab')
    sleep(.2)
    pt.keyUp('alt')
    

def fir():
    position = pt.locateOnScreen('icons/eeglab.png', confidence=.5)
    x, y = position[0], position[1]
    pt.moveTo(x + 915 - 811, y + 310 - 262)
    pt.click()
    pt.moveTo(x + 1050 - 811, y + 393 - 262)
    sleep(0.25)
    pt.moveTo(x + 1385 - 811, y + 393 - 262)
    pt.click()

    position = None
    while position is None:
        position = pt.locateOnScreen('icons/pop_eegfiltnew.png', confidence=.5)
    x, y = position[0], position[1]
    pt.moveTo(x + 1240 - 552, y + 262 - 188)
    pt.click()
    pt.typewrite('0.1', interval=.01)

    pt.moveTo(x + 1243 - 552, y + 294 - 188)
    pt.click()
    pt.typewrite('50', interval=.01)

    pt.moveTo(x + 600 - 552, y + 490 - 188)
    pt.click()

    ok()
    pop_newset()


def prep():
    position = pt.locateOnScreen('icons/eeglab.png', confidence=.5)
    x, y = position[0], position[1]
    pt.moveTo(x + 705 - 598, y + 345 - 290)
    pt.click()
    pt.moveTo(x + 700 - 598, y + 720 - 290)
    pt.click()

    ok()
    pop_newset()


def asr():
    position = pt.locateOnScreen('icons/eeglab.png', confidence=.5)
    x, y = position[0], position[1]
    pt.moveTo(x + 440 - 333, y + 400 - 348)
    pt.click()
    pt.moveTo(x + 440 - 333, y + 573 - 348)
    pt.click()

    position = None
    while position is None:
        position = pt.locateOnScreen('icons/pop_clean_rawdata.png', confidence=.5)
    x, y = position[0], position[1]
    pt.moveTo(x + 605 - 560, y + 167 - 90)
    pt.click()
    pt.moveTo(x + 605 - 560, y + 240 - 90)
    pt.click()
    pt.moveTo(x + 655 - 560, y + 475 - 90)
    pt.click()
    pt.moveTo(x + 605 - 560, y + 515 - 90)
    pt.click()
    pt.moveTo(x + 605 - 560, y + 625 - 90)
    pt.click()

    ok()
    pop_newset()


def ica():
    position = pt.locateOnScreen('icons/eeglab.png', confidence=.5)
    x, y = position[0], position[1]
    pt.moveTo(x + 440 - 333, y + 400 - 348)
    pt.click()
    pt.moveTo(x + 440 - 333, y + 600 - 348)
    pt.click()

    ok()

    position = None
    while position is None:
        position = pt.locateOnScreen('icons/doneICA.png', confidence=.5)


def save_file():
    position = pt.locateOnScreen('icons/eeglab.png', confidence=.5)
    x, y = position[0], position[1]
    pt.moveTo(x + 880 - 860, y + 334 - 283)
    pt.click()
    sleep(0.25)
    pt.moveTo(x + 880 - 860, y + 515 - 283)
    pt.click()

    position = None
    while position is None:
        position = pt.locateOnScreen('icons/pop_saveset.png', confidence=.5)
    x, y = position[0], position[1]
    pt.moveTo(x + 1595 - 870, y + 785 - 320)
    pt.click()
    pt.typewrite(data[:(len(data) - 4)], interval=.01)
    sleep(0.5)

    pt.moveTo(x + 1595 - 870, y + 880 - 320)
    pt.click()


def closeEEG():
    position = pt.locateOnScreen('icons/eeglab.png', confidence=.5)
    x, y = position[0], position[1]
    pt.moveTo(x + 1475 - 863, y + 300 - 284)
    pt.click()
    sleep(0.5)

    pt.moveTo(960, 860)
    pt.click()
    pt.typewrite('clearvars', interval=.01)
    pt.press('enter')
    pt.typewrite('clc', interval=.01)
    pt.press('enter')

    pt.moveTo(960, 400)
    pt.click()


# check_measures()
sleep(5)

# Skipping P26
for data in os.listdir('data/raw/txt/'):
    if int(data[1:3]) != 26:
        continue
    # Abre Matlab y abre eeglab
    load_file()
    sleep(3)
    assign_channlocs()
    sleep(2)

    # PREP
    prep()
    sleep(3)

    # FIR 0.1 - 50 Hz
    fir()
    sleep(2)

    # Drift & ASR
    asr()
    sleep(2)

    exit()

    # ICA
    ica()
    sleep(2)

    save_file()
    sleep(5)

    closeEEG()
    sleep(2)
