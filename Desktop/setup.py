import os
import sys
import cv2
import numpy as np
import re 
import json 

from datetime import datetime , timedelta
from PyQt5 import QtCore, QtGui, QtWidgets, uic
from PyQt5.QtCore import QTimer , QSize
from PyQt5.QtGui import QIcon, QImage, QPixmap , QPalette , QBrush
from Packages.firebase import Firebase


SCRIPT_DIR = os.path.dirname(os.path.realpath(__file__))

USER_CONFIG = SCRIPT_DIR + os.path.sep + 'Config' + os.path.sep + 'User.json'
# Setting up firebase service account into to env path 
SERVICE_KEY = SCRIPT_DIR + os.path.sep + 'Config' + os.path.sep + 'Service.json'

VIDEO_PATH = SCRIPT_DIR + os.path.sep + 'Media' + os.path.sep + 'Videos' + os.path.sep
IMAGE_PATH = SCRIPT_DIR + os.path.sep + 'Media' + os.path.sep + 'Images' + os.path.sep
LOGS_PATH =  SCRIPT_DIR + os.path.sep + 'Logs' + os.path.sep 

class SmartSystemUI(QtWidgets.QMainWindow):
    
    def __init__(self):
        super(SmartSystemUI,self).__init__()
        
        try: 
            # Load UI and Assests path 
            ui_path = SCRIPT_DIR + os.path.sep + 'UI' + os.path.sep
            icon_path = ui_path + os.path.sep + 'Assests'+ os.path.sep +'Tau.png'
            uic.loadUi(ui_path +'Design1.ui',self)
            self.setWindowIcon(QIcon(icon_path)) 
            
            # camerLabel_path =  ui_path + os.path.sep + 'Assests'+ os.path.sep +'compute.png'
            # pixmap = QPixmap(icon_path)
            # self.QlabelCamera.setPixmap(pixmap)

            backround = ui_path + os.path.sep + 'Assests'+ os.path.sep +'download.png'
            oImage = QImage(backround)
            palette = QPalette()
            sImage = oImage.scaled(QSize(1366,768))                   # resize Image to widgets size
            palette = QPalette()
            palette.setBrush(10, QBrush(sImage))                     # 10 = Windowrole
            self.setPalette(palette)
            
            # raise Exception('UI file not found ' + str(ui_path) )   
        except Exception as e :
            print('{}'.format(e))
            exit()
        
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
        self.load(self)
        user = self.rdConfig(data='None',mode='r')
        if user != None:
            self.lineEditUid.setText(user['uid'])
    
    # Not neceassy will be usefull in future 
    QtCore.pyqtSlot()   
    
    @staticmethod
    def load(self):
        self.backgroundSubtracter = cv2.createBackgroundSubtractorMOG2()
        self.blackImage = np.zeros(shape=[480, 640], dtype=np.uint8)
        # Play with threashold value to match the sensitvity of motion 
        self.threshold = 6942000
        self.timeToday = datetime.now()
        self._codec = cv2.VideoWriter_fourcc('M','J','P','G')
        self._kernel = np.ones((2,2),np.uint8)
        self._kernelSmooth = np.ones( (20,20),np.float32 ) / 400
        self.Firebase = Firebase(serviceKey = SERVICE_KEY)
         
    def starButton(self):
        if self.radioButtonOnline.isChecked():
            # Check if user is online if yes proceed
            self.onlineMode = self.Firebase.getPingTest()
            if self.onlineMode and self.userExists:
                self.labelMode.setText('STATUS : ONLINE')
                self.pushButtonVerify.setEnabled(False)
                self.startRecording()  
            else:
                self.listWidgetLogs.addItem('Please check your internet connection')
        self.startRecording() 
        self.labelMode.setText('STATUS : OFFLINE ') 
        self.listWidgetLogs.addItem('OFFLINE - MODE : '+ str(self.timeToday))
        
    def startRecording(self):          
        # Setting up camera req
        self.cap = cv2.VideoCapture(0)
        self.cap.set(cv2.CAP_PROP_FRAME_HEIGHT,480)
        self.cap.set(cv2.CAP_PROP_FRAME_WIDTH,640)
        timestampDay =  datetime.now().strftime("%A- %d- %B %Y %I-%M-%S")
        self.videoWriter = cv2.VideoWriter(VIDEO_PATH + timestampDay + '.avi',self._codec, 15, ( 640,480) )
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
        cv2.putText(image,timestampDay,(170,450),cv2.FONT_HERSHEY_SIMPLEX , 0.5,(255,100,100),2,cv2.LINE_AA)
        # # image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
        self.displayImage(image,1)
        self.motionCapture(image)
        self.videoWriter.write(image)
             
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
        smoothed = cv2.filter2D(imgray,-1,self._kernelSmooth)
        fgmask = self.backgroundSubtracter.apply(smoothed)
        # # Calcute the image difference if greater than Threshold store the image
        diff = cv2.absdiff(self.blackImage,fgmask)
        diff = diff.sum()
        # print("Threshold =  {} , Difference = {} ".format(self.threshold,diff))
        currentTime =  datetime.now() 
        if diff > self.threshold  and currentTime.second != self.timeToday.second:
            print(' diff = {} ,  threshold = {} '.format(diff,self.threshold))
            self.timeToday = currentTime
            timestampDay =  datetime.now().strftime("%A %d %B %Y %I-%M-%S-%p")
            self.logsWidget(timestampDay)
    
            capturedImage = IMAGE_PATH + timestampDay + '.jpg'
            cv2.imwrite(capturedImage , image) 
            print('Image saved = {}'.format(capturedImage))
            # if self.Firebase.getPingTest() and self.userExists:
            #     self.Firebase.setImageFireStore(capturedImage,timestampDay)
            #     self.Firebase.setNotification() 
        cv2.imshow('Backend', fgmask)
            
    def stopButton(self): 
        # # Release the camera resources and stop camera 
        self.cap.release()
        self.videoWriter.release()
        self.timer.stop()
        self.pushButtonStart.setEnabled(True)
        self.pushButtonVerify.setEnabled(True)
        self.pushButtonStop.setEnabled(False)
        
    def verifyButton(self):
        uid = self.lineEditUid.text()
        print(uid)
        if len(uid) > 25 and uid.isalnum():
            # Call firebase and verify user 
            self.logsWidget('Verifying user please wait ....')
            user = self.Firebase.verifyUser(uid)
            if user:
                self.userExists = True
                self.logsWidget('User Verified =  '+ str(uid)) 
                Data = {'uid' : uid}
                self.rdConfig(data = Data , mode='w')
            else:
                self.userExists = False
        else:
            self.logsWidget('Invalid UID '+ str(uid))         

    def logsWidget(self,msg):
        self.logsCount += 1
        self.lcdNumber.display(self.logsCount)
        self.listWidgetLogs.addItem(str(msg))   
            
    def saveLogButton(self):
        try:
            time = self.timeToday.strftime("%A_%d_%B_%Y_%I-%M-%S-%p")
            file = open(LOGS_PATH + time +'.txt','a+')
            for i in range(len(self.listWidgetLogs)):
                log = self.listWidgetLogs.item(i).text()     
                file.write(log +'\n') 
            file.close()
            msg = 'Logs saved Sucessfully to location = {} '.format(LOGS_PATH+ time +'.txt')
            self.logsWidget(msg)
            print(msg)
        except Exception as e :
            print('{}'.format(e))
        
    # ReadWrite user congig jsON                   
    def rdConfig(self,data,mode):
        print(data)
        try:
            if mode == 'w':
                with open(USER_CONFIG, 'w') as f:  # writing JSON object
                    # print(data)
                    json.dump(data, f)
            if mode == 'r':
                with open(USER_CONFIG, 'r') as f:
                    return json.load(f)          
        except OSError as e:
            self.logsWidget('Before starting verify uid')
            print('{}'.format(e))
           
            
              
if __name__ == "__main__":
    app = QtWidgets.QApplication(sys.argv)
    smartSystemUI = SmartSystemUI()
    smartSystemUI.show()
    sys.exit(app.exec_())
