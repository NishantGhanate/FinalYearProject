

#include<SoftwareSerial.h>

// Setting up Esp wifi
// 1. Guide : https://github.com/NishantGhanate/Ardiuno/tree/master/Wifi

#include <ESP8266WiFi.h>

// Libray download : https://www.arduinolibraries.info/libraries/firebase-esp8266-client
// Libray owner : https://github.com/mobizt/Firebase-ESP8266
// 2.  My implementation : https://github.com/NishantGhanate/Ardiuno/tree/master/EspFirebase/Firebase_New

#include <FirebaseESP8266.h>
#include <FirebaseESP8266HTTPClient.h>
#include <FirebaseJson.h>
#include <jsmn.h>

// https://randomnerdtutorials.com/esp8266-ds18b20-temperature-sensor-web-server-with-arduino-ide/
#include <OneWire.h>
#include <DallasTemperature.h>


FirebaseData firebaseData;
// Firebase path e.g users/uid/sensors/name
String ldrPath = "users/3shcyGOhrdMgI4PLZTCf66y0wMZ2/sensors/ldr";
String pirPath = "users/3shcyGOhrdMgI4PLZTCf66y0wMZ2/sensors/pir";
String tempPath = "users/3shcyGOhrdMgI4PLZTCf66y0wMZ2/sensors/temp";
String buzzPath = "users/3shcyGOhrdMgI4PLZTCf66y0wMZ2/sensors/buzz";

const int buzzerStatus = 12;  // Digital pin D6 on Esp8266 , GPIO where the BUZZER is connected to 
const int pirSensor = 13;  // Digital pin D7 on Esp8266 , GPIO where the PIRSENSOR is connected to 
const int oneWireBus = 4;  // Digital pin D7 on Esp8266 , GPIO where the DS18B20 is connected to 

// Guide : https://randomnerdtutorials.com/esp8266-ds18b20-temperature-sensor-web-server-with-arduino-ide/

OneWire oneWire(oneWireBus); // Setup a oneWire instance to communicate with any OneWire devices
// Pass our oneWire reference to Dallas Temperature sensor 
DallasTemperature sensors(&oneWire);

void setWifi()
{
   // Setup Esp8266 wifi
  const char* WIFI_SSD     = "SSID";         // The SSID (name) of the Wi-Fi network you want to connect to
  const char* WIFI_PASSWORD = "PASSWORD";     // The password of the Wi-Fi network
  WiFi.begin(WIFI_SSD, WIFI_PASSWORD);
  Serial.print("connecting");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(500);
  }
  Serial.println();
  Serial.print("connected: ");
  Serial.println(WiFi.localIP());
}

void setFirebase()
{
  // 4. Setup Firebase credential in setup() got to step 2. comment 
  Firebase.begin("https://smartsecurity-38229.firebaseio.com/", "bx5oEHYlFiNAatcISAVoyVhlYLDncoNIkqTi8XNt");
  Firebase.reconnectWiFi(true);
  // 6. Optional, set number of error retry
  Firebase.setMaxRetry(firebaseData, 5);
}

SoftwareSerial gsm(2,3); // Rx and Tx pin on ESP8266
void sendSMS()
{
  gsm.println("AT+CMGS=\+918692947192\"\r"); // Add your phone numner here
  gsm.println("Smart security alert !");  
  gsm.println((char)26); // Exit the sms
}

void notifyUser()
{
   String FIREBASE_FCM_DEVICE_TOKEN;
 if ( Firebase.getString(firebaseData,"users/3shcyGOhrdMgI4PLZTCf66y0wMZ2/fcmtoken"))
 {
     FIREBASE_FCM_DEVICE_TOKEN = firebaseData.stringData(); 
     
 }
  
  // https://stackoverflow.com/questions/37427709/firebase-messaging-where-to-get-server-key
  String SERVER_TOKEN = "AAAAZO2W-fI:APA91bG9OOHHBkh-VLc0XBHVYFs9vV0Bg4YWRYsu1NYSBc7xfF1t9YtLryacTOR6su3XhOunShHhONhyclapCOe__SK97cXYd6gRdPBgtnsmKG1JlyRurnLCygnjpZ63O5nxGJHNIBAU";

  firebaseData.fcm.begin(SERVER_TOKEN);
  
  firebaseData.fcm.addDeviceToken(FIREBASE_FCM_DEVICE_TOKEN); //Prvide one or more the recipient registered token or instant ID token
  
  firebaseData.fcm.setPriority("normal"); //Provide the priority (optional)

  firebaseData.fcm.setTimeToLive(5000); //Provide the time to live (optional)
  
  firebaseData.fcm.setNotifyMessage("Notification", "Hello World!", "firebase-logo.png", "http://www.google.com"); //Set the notification message data
  
  firebaseData.fcm.setDataMessage("{\"myData\":\"myValue\"}"); //Set the custom message data
  
  if (Firebase.sendMessage(firebaseData, 1)) //Send message to one recipient with inddex 1 (index starts from 0)
  {
    Serial.println(firebaseData.fcm.getSendResult()); //Success, print the result returned from server
  }
  else
  {
    Serial.println(firebaseData.errorReason());  //Failed, print the error reason
  }

}


void setup() {
  
  Serial.begin(115200); // put your setup code here, to run once:
  setWifi();
  setFirebase();

  gsm.begin(9600);  
  gsm.println("AT+CMGF=1"); //Set gsm to sms mode

  sensors.begin();  // Start the DS18B20 sensor
  
  pinMode(pirSensor, INPUT);   // 5. Setting up pin number and mode  // declare pirSensor as input
  pinMode(buzzerStatus, OUTPUT);  // declare Buzzer as output

}


void loop() {

  sensors.requestTemperatures();  // put your main code here, to run repeatedly:
  float temperatureC = sensors.getTempCByIndex(0);
  int pirState = digitalRead(pirSensor);
  int ldrValue = analogRead(A0);     // read the input on analog pin 0
  float voltage = ldrValue * (5.0 / 1023.0);   // Convert the analog reading (which goes from 0 - 1023) to a voltage (0 - 5V)  
  if ( pirState == HIGH || temperatureC > 45.00  )
  {
      digitalWrite (buzzerStatus, HIGH);
      Serial.println("Motion detected!");
        if(WiFi.status() == WL_CONNECTED)
        {
          Firebase.setFloat(firebaseData,tempPath,temperatureC);
          Firebase.setFloat(firebaseData,ldrPath,voltage);
          Firebase.setFloat(firebaseData,pirPath,pirState);
          notifyUser();
        }
        else{
          sendSMS();
        } 
      delay(1000);
  }
  else
  {
    digitalWrite (buzzerStatus, LOW);
    delay(1000);
  }

}
