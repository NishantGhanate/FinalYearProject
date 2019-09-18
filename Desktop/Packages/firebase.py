import os
import http.client as httplib
import cv2
import asyncio
import base64
from firebase_admin import credentials
from firebase_admin import db
from firebase_admin import firestore
from firebase_admin import storage as fb_storage
from firebase_admin import messaging
import firebase_admin

# Setting up firebase service account

class Firebase:
    
    def __init__(self,serviceKey):
        self.__host = 'www.google.com'
        self.__user = 'users'
        os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = serviceKey
        cred = credentials.Certificate(serviceKey)
        # As an admin, the app has access to read and write all data, regradless of Security Rules
        firebase_admin.initialize_app(cred, {
        'databaseURL': 'https://smartsecurity-38229.firebaseio.com/',
        'storageBucket': 'gs://smartsecurity-38229.appspot.com'
        })
        self._firestoreDb = firestore.Client()
        
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
        print('Recieved in Firebase '.format(uid))
        try :
            ref = db.reference('users/'+ uid)
            self.__data = ref.get()
            # print(self.__data)
            if self.__data:
                self.getToken()
                return True
            else:
                return False
        except Exception as e:
            return False

    def getToken(self):
        try:
            ref = db.reference('users/'+self.__uid+'/fcmtoken')
            self.__registrationToken = ref.get()
            print(self.__registrationToken)
        except Exception as e:
            print(e)
        
               
    def setNotification(self,timeStamp):
        messages = [
            messaging.Message(
                notification = messaging.Notification('Smart App', 'Alert !!!!!'),
                token =self.__registrationToken,
            )
        ]
        response = messaging.send_all(messages)
        # See the BatchResponse reference documentation
        # for the contents of response.
        print('{0} messages were sent successfully'.format(response.success_count))
        
        doc_ref = self._firestoreDb.collection(self.__user).document(self.__uid).collection('notifications').document(timeStamp)
        doc_ref.set({"title": "Alert ! " , "body":timeStamp})
        
               
    def setImageFireStore(self,path,timestampDay):
        # Add a new document
        doc_ref = self._firestoreDb.collection(self.__user).document(self.__uid).collection('images').document(timestampDay)
        img = cv2.imread(path)
        
        # Resize the image 40 % of the orginal  size
        scale_percent = 40 
        width = int(img.shape[1] * scale_percent / 100)
        height = int(img.shape[0] * scale_percent / 100)
        dim = (width, height)
        resized = cv2.resize(img, dim, interpolation = cv2.INTER_AREA)
        
        # Convert to base64 and post 
        retval, buffer = cv2.imencode('.jpg', resized)
        jpg_as_text = base64.b64encode(buffer)
        jpg_as_text = jpg_as_text.decode('utf-8')
        print(type(jpg_as_text))
        doc_ref.set({"blob":jpg_as_text })
     
    
    



