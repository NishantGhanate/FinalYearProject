import os
import sys

from PyQt5 import QtCore, QtGui, QtWidgets, uic
from PyQt5.QtCore import QTimer
from PyQt5.QtGui import QIcon, QImage, QPixmap

SCRIPT_DIR = os.path.dirname(os.path.realpath(__file__))

class WatcherUI(QtWidgets.QMainWindow):
    def __init__(self):
        super(WatcherUI,self).__init__()
        
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
            
        # Attach button Object to respected function 
        self.setWindowTitle('Smart Secuirty System')
        self.pushButtonStart.clicked.connect(self.starButton)
        self.pushButtonStop.clicked.connect(self.stopButton) 
        self.pushButtonVerify.clicked.connect(self.verifyButton)  
        self.pushButtonSaveLog.clicked.connect(self.saveLogButton)
        
    # not neceassy may be usefull in future 
    QtCore.pyqtSlot()   
    
    def starButton(self):
        print(self.radioButtonOffline.isChecked() )
        return 0
    
    def stopButton(self):
        pass
    
    def verifyButton(self):
        # self.pushButtonVerify.setEnabled(False)
        # check mode 
        pass
    
    def saveLogButton(self):
        pass
    
    
             
        
            
        
        
if __name__ == "__main__":
    app = QtWidgets.QApplication(sys.argv)
    watch = WatcherUI()
    watch.show()
    sys.exit(app.exec_())
