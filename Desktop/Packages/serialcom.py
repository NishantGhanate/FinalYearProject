import serial
import time

class SerialCom:
    incomingSerialData= None
    def __init__(self,baudRade,comPort):
       self.ser = serial.Serial(baudRade,comPort)
    
    def getData(self):
            incomingSerialData = self.ser.readline().decode()
            print(incomingSerialData)
                   
    def setData(self,data):
        self.ser.write(data.encode())
  
        
             
serialCom =  SerialCom('COM5',9600)

for i in range(20):
    serialCom.getData()
    time.sleep(1)
    serialCom.setData("400,200")  
    
     
        