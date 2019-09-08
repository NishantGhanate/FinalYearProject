import os
import http.client as httplib


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
        self.db = firestore.Client()
        
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
        print('Recivied in Firebase '.format(uid))
        try :
            # db = firestore.Client()
            doc_ref = self.db.collection(self.__user).document(uid)
            self.__data = doc_ref.get()
            # for d in self.__data:
            #     print(u"{} u{}".format(d.id,d.to_dict() ))
            if self.__data:
                return True
        except Exception as e:
            return False

    def PostFireStore(self):
       # Add a new document
        db = firestore.Client()
        doc_ref = db.collection(u'Test').document(u'Image2')
        doc_ref.set({"blob":"blob"})

        # Then query for documents
        users_ref = db.collection(u'users')
        docs = users_ref.get()

        for doc in docs:
            print(u'{} => {}'.format(doc.id, doc.to_dict()))
            
    def getUserAction(self):
        pass
    
    
    def setNotification(self,timeStamp):
        # message = messaging.Message(
        # data={
        #     'score': '850',
        #     'time': '2:45',
        # },
        # token=self.getFcmToken, #  registration token
        # )
        
        # # Send a message to the device corresponding to the provided
        # response = messaging.send(message)
        # Response is a message ID string.
        # print('Successfully sent message:', response)
        doc_ref = self.db.collection(self.__user).document(self.__uid).collection('notifications').document(timeStamp)
        doc_ref.set({"title": "Alert ! " , "body":timeStamp})
        
               
    def setImageFireStore(self,path,timestampDay):
       # Add a new document
        # db = firestore.client()
        doc_ref = self.db.collection(self.__user).document(self.__uid).collection('images').document(timestampDay)
        file = open(path, 'rb')
        blob = file.read()
        file.close()
        doc_ref.set({"blob":blob})
     
    
    



