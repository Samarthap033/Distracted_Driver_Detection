# This Python file uses the following encoding: utf-8
import os
import re
import sys

import cv2
import numpy as np
import tensorflow as tf
from PyQt5.QtCore import QObject, QUrl, pyqtSlot
from PyQt5.QtQml import QQmlApplicationEngine
from PyQt5.QtWidgets import QApplication
from tensorflow import keras
from tensorflow.keras import models # type: ignore

import src


class SVM_test():

    def __init__(self):
        super().__init__()
        self.tags = {"C0": "Normal driving",
                     "C1": "Texting - right",
                     "C2": "Talking on the phone - right",
                     "C3": "Texting - left",
                     "C4": "Talking on the phone - left",
                     "C5": "Operating the radio",
                     "C6": "Drinking",
                     "C7": "Reaching behind",
                     "C8": "Hair and makeup",
                     "C9": "Talking to passenger"}
        self.dirPath = os.path.dirname(os.path.realpath(__file__))
        self.model = models.load_model(
            self.dirPath + '\\resources\model\IS.h5')
        self.model.summary()

    def get_image(self, path):
        img = cv2.imread(path)
        img = img[50:, 120:-50]
        img = cv2.resize(img, (224, 224))
        img = np.array(img).reshape(-1, 224, 224, 3)
        return img

    def predImage(self, imagePath):
        test = self.get_image(imagePath)
        index = self.model.predict(test)
        predicted_class = 'C' + \
            str(np.where(index[0] == np.amax(index[0]))[0][0])
        return self.tags[predicted_class]

    def prepareVideo(self, videoPath):
        cam = cv2.VideoCapture(videoPath)
        videoFolder = self.dirPath + "\data\\testVideo\\" + \
            os.path.splitext(os.path.basename(videoPath))[0]
        try:
            if not os.path.exists(videoFolder):
                os.makedirs(videoFolder)
        except OSError:
            print('Error: Creating directory of data')
        currentframe = 0

        while(True):
            ret, frame = cam.read()

            if ret:
                name = videoFolder + "\\frame" + str(currentframe) + ".jpg"
                cv2.imwrite(name, frame)
                currentframe += 1
            else:
                break
        cam.release()
        cv2.destroyAllWindows()


class Bridge(QObject):

    def __init__(self):
        super().__init__()
        self.SVM = SVM_test()
        self.dirPath = os.path.dirname(os.path.realpath(__file__))

    @pyqtSlot(result=list)
    def getImageList(self):
        imageList = []
        for image in os.listdir(self.dirPath + '\data\\testImage'):
            imageList.append('file:///' + self.dirPath +
                             '\\data\\testImage\\' + image)
        return imageList

    @pyqtSlot(str, result=str)
    def getImagePred(self, imagePath):
        return self.SVM.predImage(imagePath)

    @pyqtSlot(str, result=list)
    def prepareVideo(self, videoPath):
        self.SVM.prepareVideo(videoPath)
        videoFolder = self.dirPath + "\data\\testVideo\\" + \
            os.path.splitext(os.path.basename(videoPath))[0]
        imageVidList = []
        for imageVid in os.listdir(videoFolder):
            imageVidList.append('file:///' + videoFolder + "\\" + imageVid)
        imageVidList = sorted(imageVidList, key=lambda x: (
            int(re.sub('\D', '', x)), x))
        return imageVidList


if __name__ == "__main__":
    app = QApplication([])
    app.setOrganizationName("quantrancse")
    app.setOrganizationDomain("quantrancse")
    os.environ['QT_QUICK_CONTROLS_STYLE'] = 'Material'

    engine = QQmlApplicationEngine()
    engine.load(QUrl('qrc:/resources/main.qml'))

    # Bridge to GUI
    bridge = Bridge()

    # Expose the Python object to QML
    context = engine.rootContext()
    context.setContextProperty('con', bridge)

    sys.exit(app.exec_())
