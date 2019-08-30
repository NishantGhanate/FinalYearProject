#include <Servo.h>

class SerialCom
{
    int pirSenorPin, ldrPin , buzzerPin;
    int pirVlaue , ldrValue , buzzValue = 0;
    Servo myservoX , myservoY; 

    public:
    SerialCom(int p , int l, int b , int x , int y)
    {
        pirSenorPin = p;
        ldrPin = l;
        buzzerPin = b;

        pinMode(pirSenorPin,INPUT);
        pinMode(ldrPin,INPUT);
        pinMode(ldrPin,OUTPUT);
        myservoX.attach(x);
        myservoY.attach(y);
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

// Pass pin numbers
SerialCom serialCom( p = 1, l = 2 , b = 3, x = 4 ,y = 5 );
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

