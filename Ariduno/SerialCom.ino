#include <Servo.h>

class SerialCom
{
    int pirSenorPin, ldrPin , buzzerPin , tempPin;
    int pirVlaue , ldrValue , buzzValue , tempValue = 0;
    Servo myservoX , myservoY; 

    public:
    SerialCom(int pir , int ldr, int buzz ,int temp ,int servox , int servoy)
    {
        pirSenorPin = pir;
        ldrPin = ldr;
        buzzerPin = buzz;
        tempPin = temp;

        // Analog input 
        pinMode(pirSenorPin,INPUT);
        pinMode(ldrPin,INPUT);
        pinMode(tempPin,INPUT);

        // Digital pin modes
        pinMode(buzzerPin,OUTPUT);
        myservoX.attach(servox);
        myservoY.attach(servoy);
    }

    int getPirValue()
    {
        pirVlaue = analogRead(pirSenorPin);
        return pirVlaue;
    }

    int getLdrValue()
    {
        ldrValue = analogRead(pirSenorPin);
        return ldrValue;
    }

    int getTempValue(){
        tempValue = analogRead(pirSenorPin);
        return tempValue;
    }

    void getSerialInput()
    {
        if(Serial.available() > 0 )
        {
            incoming = Serial.readInt();
            Serial.print("Data from python recvievd : ");
            Serial.println(incoming);
            
        }
    }
    void setBuzzer(bool buzz)
    {
        if (buzz)
        {
            tone(buzzerPin, 1000);
        }
        noTone(buzzerPin);
        
    }
    void setServo(int posX , int posY)
    {
        myservoX.write(posX);
        myservoX.write(posY); 
    }
    
};

// Sensors pin numbers 

SerialCom serialCom( pir = 1, ldr = 2 , buzz = 3, temp = 5, x = 5 ,y = 6 );
int pirVlaue , intLdrValue ;
// Code execution starts fom here
void setup()
{
    // Setup baud reate 
    Serial.begin(9600);    
}

void loop()
{
    pirVlaue = serialCom.getPirValue();
    intLdrValue = serialCom.getLdrValue();
    // serialCom.getSerialInput();
}

