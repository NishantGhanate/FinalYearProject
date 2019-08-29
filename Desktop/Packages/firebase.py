import os
import http.client as httplib


from firebase_admin import credentials
from firebase_admin import db
from firebase_admin import firestore
from firebase_admin import storage as fb_storage
from firebase_admin import messaging

# Setting up firebase service account
SCRIPT_DIR = os.path.dirname(os.path.realpath(__file__))


# SericeKey = SCRIPT_DIR + os.path.sep + 'Config' + os.path.sep + 'Service.json'
# print(SericeKey)
# os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = SericeKey

class Firebase():
    
    def __init__(self):
        self.__host = 'www.google.com'
        self.__user = 'users'
        #self.getFcmToken()
        self.firestoreClient = firestore.Client()
        
    def getPingTest(self):
        conn = httplib.HTTPConnection(self.__host, timeout=5)
        try:
            conn.request("HEAD", "/")
            conn.close()
            return True
        except:
            conn.close()
            return False
        
    def verifyUser(self,uid):
        self.__uid = uid
        try :
            db = self.firestoreClient
            doc_ref = db.collection(self.__user).document(self.__uid)
            self.__fcmToken = doc_ref.stream()
            if self.__fcmToken:
                return True
        return False
    
    def getUserAction(self):
        pass
    
    
    def setNotification(self):
        message = messaging.Message(
        data={
            'score': '850',
            'time': '2:45',
        },
        token=self.getFcmToken,
        )
        
        # Send a message to the device corresponding to the provided
        # registration token.
        response = messaging.send(message)
        # Response is a message ID string.
        print('Successfully sent message:', response)
                
    def setImageFireStore(self,path):
       # Add a new document
        db = self.firestoreClient
        doc_ref = db.collection(self.__user).document(self.__uid).collection('Images')
        file = open(path, 'rb')
        blob = file.read()
        file.close()
        # doc_ref.set({"blob":blob})
     
    
    
    



