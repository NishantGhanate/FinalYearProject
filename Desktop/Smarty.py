import os
import sys
import cv2
import numpy as np
import re 
import json 
import asyncio
import http.client as httplib
from datetime import datetime , timedelta
from PyQt5 import QtCore, QtGui, QtWidgets, uic
from PyQt5.QtCore import QTimer , QSize
from PyQt5.QtGui import QIcon, QImage, QPixmap , QPalette , QBrush
from Packages.firebase import Firebase
from Packages.bot import Bot

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
            
            # self.camerLabel_path =  cv2.imread(ui_path + os.path.sep + 'Assests'+ os.path.sep +'compute.png')
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
        self.pushButtonTelegram.clicked.connect(self.verifyTelegram)  
        self.pushButtonSaveLog.clicked.connect(self.saveLogButton)
        self.pushButtonClearLog.clicked.connect(self.clearLogsButton)
        self.logsCount = 0
        self.onlineMode = False
        self.userExists = False
        self.telegramExists = False
        self.labelMode.setText('OFFLINE-MODE')
        self.pastFrame = ''
        self.presentFrame = ''

        # Read write user config , load user.json file 
        userData = self.rdConfig(data='None',mode='r')
        if userData != None:
            if 'uid' in userData :
                self.lineEditUid.setText(userData['uid'])
            if 'token' in userData  :
                self.lineEditToken.setText(userData['token'])
        # Create instance for async ops
        self.__loop = asyncio.get_event_loop()
         # Init Firebase with Admin json key
        self.Firebase = Firebase(serviceKey = SERVICE_KEY)
        # Init Telegram Bot
        self.bot = Bot()
        self.load(self)
        self.foldersCheck()
    # Not neceassy will be usefull in future 
    QtCore.pyqtSlot()   
    
    @staticmethod
    def load(self):
        self.backgroundSubtracter = cv2.createBackgroundSubtractorMOG2()
        self.blackImage = np.zeros(shape=[480, 640], dtype=np.uint8)
        # Play with threashold value to match the sensitvity of motion 
        self.threshold = 1694200
        self.timeToday = datetime.now()
        self._codec = cv2.VideoWriter_fourcc('M','J','P','G')
        self._kernel = np.ones((3,3),np.uint8)
        self._kernelSmooth = np.ones( (25,25),np.float32 ) / 625
        self.__host = 'www.google.com'
        self.mode = False # i.e OFFLINE

    def foldersCheck(self):
        paths = ['Logs','Config','Media'+ os.sep +'Images','Media'+ os.sep+'Videos']
        for path in paths:
            p = SCRIPT_DIR + os.path.sep + path
            if not os.path.exists(p):
                os.makedirs(p)
        
    def starButton(self):
        self.cap = cv2.VideoCapture(0)
        ret , frame = self.cap.read()
        if ret:
            self.pastFrame = self.blackImage
            self.presentFrame = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        else:
            self.logsWidget('Check your camera connection : '+ str(self.timeToday))

        if self.radioButtonOnline.isChecked():
            # Check if user is online if yes proceed
            self.onlineMode = self.getPingTest() 
            if self.onlineMode and self.userExists or self.telegramExists:
                self.labelMode.setText('STATUS : ONLINE')
                self.pushButtonVerify.setEnabled(False)
                self.pushButtonTelegram.setEnabled(False)
                self.mode = True
                self.logsWidget('ONLINE  : '+ str(self.timeToday))
                self.startRecording()
            elif not self.userExists or not self.telegramExists:
                self.logsWidget('Please verify token first ')
            else:
                self.logsWidget('Please check your internet connection')
        if self.radioButtonOffline.isChecked():
            self.mode = False
            self.startRecording() 
            self.labelMode.setText('STATUS : OFFLINE ') 
            self.logsWidget('OFFLINE - MODE : '+ str(self.timeToday))

             
    def startRecording(self):          
        # Setting up camera req
        self.cap = cv2.VideoCapture(0)
        # self.cap.set(5, 24)
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
         
            
    def update_frame(self):
        ret,image = self.cap.read()
        timeStamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        timestampDay =  datetime.now().strftime("%A, %d. %B %Y %I:%M:%S %p")
        cv2.putText(image,timestampDay,(20,450),cv2.FONT_HERSHEY_SIMPLEX , 0.7,(0,0,0),2,cv2.LINE_AA)
        # # image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
        # ret = return if camera if working
        if ret:
            # self.displayImage(image,1)
            # self.videoWriter.write(image)
            # self.displayImage()
            # self.motionCapture(image)
            self.__loop.run_until_complete(self.displayImage(image,1))
            self.__loop.run_until_complete(self.motionCapture(image))

    async def displayImage(self,img,window=1):
        # qformat = QImage.Format_Indexed8
        qformat = QImage.Format_RGB888
        # # Since Opencv works on BGR we swap back to RBG channels
        outImage = QImage(img,img.shape[1],img.shape[0],img.strides[0],qformat) 
        outImage = outImage.rgbSwapped()   
        if window ==1:
            self.QlabelCamera.setPixmap(QPixmap.fromImage(outImage))
            self.QlabelCamera.setScaledContents(True)
    

    async def motionCapture(self,image):
        imgray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
        smoothed = cv2.filter2D(imgray,-1,self._kernelSmooth)
        fgmask = self.backgroundSubtracter.apply(imgray)
        # # dilation = cv2.dilate(fgmask,self._kernel,iterations = 2)
        erosion = cv2.erode(fgmask,self._kernel,iterations = 2)
        # # contours,hierachy=cv2.findContours(erosion,cv2.RETR_TREE,cv2.CHAIN_APPROX_SIMPLE)
        # # cv2.drawContours(image, contours, -1, (255,255,255), 2)
        # # cv2.imshow('Backend', erosion )
        
        # # Calcute the image difference if greater than Threshold store the image
        
        diff = cv2.absdiff(self.pastFrame,self.presentFrame)
        diff = diff.sum()
        print(' diff = {} ,  threshold = {} '.format(diff,self.threshold))
        currentTime =  datetime.now() 

        if diff > self.threshold  and currentTime.second != self.timeToday.second :
            # print(' diff = {} ,  threshold = {} '.format(diff,self.threshold))
            self.logsWidget(' diff = {} ,  threshold = {} '.format(diff,self.threshold) )
            
            self.timeToday = currentTime
            timestampDay =  datetime.now().strftime("%A %d %B %Y %I-%M-%S-%p")
            self.logsWidget(timestampDay)

            capturedImage = IMAGE_PATH + timestampDay + '.jpg'
            cv2.imwrite(capturedImage , image)
            
            self.logsWidget('Image saved = {}\n'.format(capturedImage) )
           
            if self.mode :
                self.notifyUser(capturedImage,timestampDay)
                # self.__loop.run_until_complete(self.notifyUser(capturedImage,timestampDay))
        self.pastFrame , self.presentFrame  = self.presentFrame , erosion
                     
    def notifyUser(self,capturedImage,timestampDay):
        if self.getPingTest():
            if self.userExists:
                self.Firebase.setImageFireStore(capturedImage,timestampDay)
                self.Firebase.setNotification(timestampDay)
            if self.telegramExists:
                self.bot.sendImageTelegram(capturedImage)
        else:
            self.logsWidget("Offline : " + timestampDay )
                     
    def stopButton(self): 
        # # Release the camera resources and stop camera
        self.timer.stop()
        # self.videoWriter.release()
        self.cap.release()
        cv2.destroyAllWindows()
        self.pushButtonStart.setEnabled(True)
        self.pushButtonVerify.setEnabled(True)
        self.pushButtonTelegram.setEnabled(True)
        self.pushButtonStop.setEnabled(False)

    def verifyButton(self):
        uid = self.lineEditUid.text()
        # print(uid)
        self.logsWidget('Verifying user please wait ....')
        if  self.getPingTest():
            if len(uid) > 25 and uid.isalnum():
                # Call firebase and verify user 
                self.userExists = self.Firebase.verifyUser(uid)
                if self.userExists:
                    self.logsWidget('User Verified =  '+ str(uid))
                    self.labelMode.setText('STATUS : ONLINE ') 
                    Data = {'uid' : uid}
                    self.rdConfig(data = Data , mode='w')
                else:
                    self.userExists = False
                    self.logsWidget('Invalid UID : '+ str(uid))               
        else:
            self.userExists = False
            timestampDay =  datetime.now().strftime("%A, %d. %B %Y %I:%M:%S %p")
            self.logsWidget('Please check your internet connection '.format(timestampDay)) 
   
    def verifyTelegram(self):
        token = self.lineEditToken.text()
        valid = re.search('^[0-9]{9}:[a-zA-Z0-9]{34}',token)    
        self.logsWidget('Verifying token please wait ....')
        print(valid)
        if not valid :
            self.logsWidget('Invalid Token : '+ str(token))
            return 
        if  self.getPingTest():
            self.telegramExists = self.bot.verifyBot(token)
            print(self.telegramExists)
            if self.telegramExists:
                    self.logsWidget('Token Verified {} : '.format(token))
                    Data = {'token' : token}
                    self.rdConfig(data = Data , mode='w')
            else:
                self.telegramExists = False
                self.logsWidget('Invalid Token : '+ str(token)) 
        else: 
            self.telegramExists = False           
            timestampDay =  datetime.now().strftime("%A, %d. %B %Y %I:%M:%S %p")
            self.logsWidget('Please check your internet connection '.format(timestampDay))

    def getPingTest(self):
        conn = httplib.HTTPConnection(self.__host, timeout=5)
        try:
            conn.request("HEAD", "/")
            conn.close()
            return True
        except:
            conn.close()
            return False

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
    
    def clearLogsButton(self):
        self.listWidgetLogs.clear()
        

        
    # ReadWrite user congig jsON                   
    def rdConfig(self,data,mode):
        # print(data)
        uid = ''
        token = ''
        if 'uid' in data :
            uid = data['uid']
        if 'token' in data:
            token = data['token']
         
        Data = {'token' : token , 'uid' : uid } 
        try:
            if mode == 'w':
                with open(USER_CONFIG, 'w') as f:  # writing JSON object
                    # print(data)
                    json.dump(Data, f)
            if mode == 'r':
                with open(USER_CONFIG, 'r') as f:
                    return json.load(f)          
        except FileNotFoundError as e:
            self.logsWidget('Before starting verify uid')
            print('{}'.format(e))
    

                   
                     
if __name__ == "__main__":
    app = QtWidgets.QApplication(sys.argv)
    smartSystemUI = SmartSystemUI()
    smartSystemUI.show()
    sys.exit(app.exec_())



# If Warning about opencv :
# open cmd paste setx OPENCV_VIDEOIO_PRIORITY_MSMF 0  , then enter 
