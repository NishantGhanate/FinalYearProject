import os
import sys
import cv2
import numpy as np

from datetime import datetime , timedelta
from PyQt5 import QtCore, QtGui, QtWidgets, uic
from PyQt5.QtCore import QTimer
from PyQt5.QtGui import QIcon, QImage, QPixmap
from Packages.firebase import Firebase

SCRIPT_DIR = os.path.dirname(os.path.realpath(__file__))

# Setting up firebase service account into to env path
SericeKey = SCRIPT_DIR + os.path.sep + 'Config' + os.path.sep + 'Service.json'
os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = SericeKey

class SmartSystemUI(QtWidgets.QMainWindow):
    
    def __init__(self):
        super(SmartSystemUI,self).__init__()
        
        try: 
            # Load UI and Assests path 
            ui_path = SCRIPT_DIR + os.path.sep + 'UI' + os.path.sep
            icon_path = ui_path + os.path.sep + 'Assests'+ os.path.sep +'Tau.png'
            uic.loadUi(ui_path +'Design1.ui',self)
            self.setWindowIcon(QIcon(icon_path))  
            # raise Exception('UI file not found ' + str(ui_path) )   
        except Exception as e :
            print('{}'.format(e))
            exit()
        
        # File paths in current working Directory / Folder     
        self.videoPath =  SCRIPT_DIR + os.path.sep + 'Media' + os.path.sep + 'Videos' + os.path.sep
        self.imagePath =  SCRIPT_DIR + os.path.sep + 'Media' + os.path.sep + 'Images' + os.path.sep
        self.logsPath = SCRIPT_DIR + os.path.sep + 'Logs' + os.path.sep 
        
        # Attach button Object to respected function 
        self.setWindowTitle('Smart Secuirty System')
        self.pushButtonStart.clicked.connect(self.starButton)
        self.pushButtonStop.clicked.connect(self.stopButton) 
        self.pushButtonVerify.clicked.connect(self.verifyButton)  
        self.pushButtonSaveLog.clicked.connect(self.saveLogButton)
        self.logsCount = 0
        self.onlineMode = False
        self.userExists = False
        self.labelMode.setText('OFFLINE-MODE')
        self.Firebase =  Firebase()
        self.load(self)
    
    # Not neceassy will be usefull in future 
    QtCore.pyqtSlot()   
    
    @staticmethod
    def load(self):
        self.backgroundSubtracter = cv2.createBackgroundSubtractorMOG2()
        self.blackImage = np.zeros(shape=[480, 640], dtype=np.uint8)
        self.kernelSmooth = np.ones( (25,25),np.float32 ) / 625
        self.threshold = 7650000
        self.timeToday = datetime.now()
        self._codec = cv2.VideoWriter_fourcc('M','J','P','G')
        
    def starButton(self):
        if self.radioButtonOnline.isChecked():
            # Check if user is online if yes proceed
            self.onlineMode = self.Firebase.getPingTest()
            if self.onlineMode and self.checks:
                self.labelMode.setText('STATUS : ONLINE')
                self.pushButtonVerify.setEnabled(False)
                self.startRecording()  
            else:
                self.listWidgetLogs.addItem('Please check your internet connection')
        self.startRecording() 
        self.labelMode.setText('STATUS : OFFLINE ') 
        self.listWidgetLogs.addItem('OFFLINE - MODE : '+ self.timeToday)
        
    def startRecording(self):          
        # Setting up camera req
        self.cap = cv2.VideoCapture(0)
        self.cap.set(cv2.CAP_PROP_FRAME_HEIGHT,480)
        self.cap.set(cv2.CAP_PROP_FRAME_WIDTH,640)
        timestampDay =  datetime.now().strftime("%A- %d- %B %Y %I-%M-%S")
        # self.videoWriter = cv2.VideoWriter(self.videoPath + timestampDay + '.avi',self._codec, 15, ( 640,480) )
        # Setting up QLabel Timer On start init the  Update frame 
        self.timer = QTimer(self)
        self.timer.timeout.connect(self.update_frame)
        self.timer.start(0.1)
        self.pushButtonStart.setEnabled(False)
        self.pushButtonStop.setEnabled(True)
         
    # @staticmethod           
    def update_frame(self):
        ret,image = self.cap.read()
        
        timeStamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        timestampDay =  datetime.now().strftime("%A, %d. %B %Y %I:%M:%S %p")
        cv2.putText(image,timestampDay,(200,450),cv2.FONT_HERSHEY_SIMPLEX , 0.7,(255,100,100),2,cv2.LINE_AA)
        
        # # image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
        self.displayImage(image,1)
        self.motionCapture(image)
        # self.videoWriter.write(image)
             
    def displayImage(self,img,window=1):
        qformat = QImage.Format_Indexed8
        qformat = QImage.Format_RGB888
        # # Since Opencv works on BGR we swap back to RBG channels
        outImage = QImage(img,img.shape[1],img.shape[0],img.strides[0],qformat) 
        outImage = outImage.rgbSwapped()   
        if window ==1:
            self.QlabelCamera.setPixmap(QPixmap.fromImage(outImage))
            self.QlabelCamera.setScaledContents(True)
    
    def motionCapture(self,image):
        imgray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
        smoothed = cv2.filter2D(imgray,-1,self.kernelSmooth)
        fgmask = self.backgroundSubtracter.apply(smoothed)
        
        # # Both Image should have same size and channels 
        # print(type(smoothed) , len(smoothed[0]) , len(smoothed))
        # print(type(self.blackImage) , len(self.blackImage[0]) , len(self.blackImage))
        # print(smoothed.shape)
        # print(self.blackImage.shape)
        
        # # Calcute the image difference if greater than Threshold store the image
        diff = cv2.absdiff(self.blackImage,fgmask)
        diff = diff.sum()
        currentTime =  datetime.now() 
        if diff > self.threshold  and currentTime.second != self.timeToday.second:
            print(' diff = {} , self.threshold = {} '.format(diff,self.threshold))
            self.timeToday = currentTime
            timestampDay =  datetime.now().strftime("%A %d %B %Y %I-%M-%S-%p")
            self.logsCount += 1
            self.lcdNumber.display(self.logsCount)
            self.listWidgetLogs.addItem(timestampDay)
            # # Since Opencv read and writes in BGR format 
            image = cv2.cvtColor(image,cv2.COLOR_RGB2BGR)
            capturedImage = self.imagePath + timestampDay + '.jpg'
            # # cv2.imwrite(capturedImage , image) 
            print('Image saved = {}'.format(capturedImage))
            if self.Firebase.getPingTest() and self.userExists:
                # self.Firebase.setImageFireStore(capturedImage)
                # self.Firebase.setNotification() 
        cv2.imshow(' frame mask ' , fgmask)
                
    def stopButton(self): 
        # # Release the camera resources and stop camera 
        self.cap.release()
        # self.videoWriter.release()
        self.timer.stop()
        self.pushButtonStart.setEnabled(True)
        self.pushButtonVerify.setEnabled(True)
        self.pushButtonStop.setEnabled(False)
        
    def verifyButton(self):
        # # check mode 
        uid = self.lineEditUid.text()
        if uid not None:
            # Call firebase and verify user 
            user = self.Firebase.verifyUser(uid)
            if user:
                self.userExists = True
            else:
                self.userExists = False
                    

    def saveLogButton(self):
        try:
            time = self.timeToday.strftime("%A_%d_%B_%Y_%I-%M-%S-%p")
            file = open(self.logsPath + time +'.txt','a+')
            for i in range(len(self.listWidgetLogs)):
                log = self.listWidgetLogs.item(i).text()     
                file.write(log +'\n') 
            file.close()
            print('Logs saved Sucessfully to location = {} '.format(self.logsPath + time +'.txt'))
        except Exception as e :
            print('{}'.format(e))
        return None
          
if __name__ == "__main__":
    app = QtWidgets.QApplication(sys.argv)
    smartSystemUI = SmartSystemUI()
    smartSystemUI.show()
    sys.exit(app.exec_())
