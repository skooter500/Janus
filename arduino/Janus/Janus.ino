#include <Servo.h>

Servo grip;  // create servo object to control a servo
Servo wristZ;  // create servo object to control a servo
Servo wristX;  // create servo object to control a servo
Servo elbow;  // create servo object to control a servo
Servo shoulder1;  // create servo object to control a servo
Servo base;  // create servo object to control a servo

// twelve servo objects can be created on most boards

int pos = 0;    // variable to store the servo position

void setup() {

  Serial.begin(9600);

  grip.attach(3);
  grip.write(0); 
                                                                                         
  wristZ.attach(5);
  wristZ.write(110); 

  wristX.attach(11);
  wristX.write(90);
  
  elbow.attach(6);
  elbow.write(100); 

  shoulder1.attach(9);
  shoulder1.write(110); 

  base.attach(10);
  base.write(138);

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
    
  }
}
