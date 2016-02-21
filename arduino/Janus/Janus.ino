#include <Servo.h>

Servo grip;  // create servo object to control a servo
Servo wristZ;  // create servo object to control a servo
Servo wristX;  // create servo object to control a servo
Servo elbow;  // create servo object to control a servo
Servo shoulder1;  // create servo object to control a servo
Servo base;  // create servo object to control a servo

// twelve servo objects can be created on most boards

int pos = 0;    // variable to store the servo position

float aspeed = 10.0f;

float baseDefault = 100.0f;
float gripDefault = 0.0f;
float wristZDefault = 110.0f;
float wristXDefault = 90.0f;
float elbowDefault= 90.0f;
float shoulderDefault = 110.0f;


long previous = 0;
long timeDelta = 0;
bool needsReset;


void reset()
{
  grip.write(gripDefault);
  wristX.write(wristXDefault);
  wristZ.write(wristZDefault);
  elbow.write(elbowDefault);
  shoulder1.write(shoulderDefault);
  base.write(baseDefault);
}

void setup() {

  Serial.begin(9600);

  grip.attach(3);                                                                                         
  wristZ.attach(5);  
  wristX.attach(11);  
  elbow.attach(6);
  shoulder1.attach(9);   
  base.attach(10);
  reset();
}

void loop() {    
  if (Serial.available() > 0)
  {
    int c = Serial.read();
    if (c == 'G')
    {
      float angle = Serial.parseFloat();
      grip.write(angle);
    }
    if (c == 'W')
    {
      float angle = Serial.parseFloat();
      wristZ.write(angle);
    }
    if (c == 'X')
    {
      float angle = Serial.parseFloat();
      wristX.write(angle);
    }

    if (c == 'E')
    {
      float angle = Serial.parseFloat();
      elbow.write(angle);
    }
    if (c == 'S')
    {
      float angle = Serial.parseFloat();
      shoulder1.write(angle);
    }
    if (c == 'B')
    {
      float angle = Serial.parseFloat();
      base.write(angle);
    }
    if (c == 'R')
    {
      base.write(baseDefault);      
      reset();
    }
  }
}
