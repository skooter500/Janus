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

long previous = 0;
long timeDelta = 0;
bool needsReset;

void resetBase()
{
  float servoCurrent = base.read();  
  float distance = servoCurrent - baseDefault;
  while(abs(distance) > 10.0f)
  {
    base.write(servoCurrent + (distance > 0) ? -1 : 1);  
    servoCurrent = base.read();    
    distance = servoCurrent - baseDefault;  
  }
  
  
  /*long now = millis();
  timeDelta = now - previous;
  previous = now;

  float servoCurrent = base.read();
  float distance = baseDefault - servoCurrent;
  if (distance < 1.0f)
  {
    needsReset = false;
    return;
  }
  else
  {
    // How far to travel this loop
    float distThisDelta = (timeDelta / 1000) * aspeed;
    base.write(servoCurrent + distThisDelta);
  }
  */
}

void setup() {

  Serial.begin(9600);

  grip.attach(3);
  grip.write(0); 
                                                                                         
  wristZ.attach(5);
  wristZ.write(110); 

  wristX.attach(11);
  wristX.write(90);
  
  elbow.attach(6);
  elbow.write(90); 

  shoulder1.attach(9);
  shoulder1.write(110);
   
  base.attach(10);
  base.write(baseDefault);
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
      //resetBase();
    }
  }
}
