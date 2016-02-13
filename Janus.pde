import com.leapmotion.leap.Controller;
import com.leapmotion.leap.*;
import com.leapmotion.leap.processing.LeapMotion;

import controlP5.*;
import processing.serial.*;
 
ControlP5 cp5;
Serial arduino;

LeapMotion leap;

float[] ypr = new float[3];

Camera camera;
HashMap<String, Joint> joints = new HashMap<String, Joint>();

void setup() {
  size(500,500);
  arduino = new Serial(this, Serial.list()[0], 9600);
  
  joints.put("G", new Joint("G", 0, 60, 0, 1, 0, 60, 0));
  joints.put("W", new Joint("W", 17, 185, 110, 1.0f, -1.0f, 17, 185));
  
  
  joints.put("E", new Joint("E", 20, 120, 60, 150, 500, 40, 120));  
  joints.put("S", new Joint("S", 0, 130, 80, 130, -50, 80, 130));
  
  joints.put("B", new Joint("B", 10, 180, 100, -150, 150, 180, 10));
  joints.put("X", new Joint("X", 0, 150, 90, -1.5f, 0.4f, 50, 150));
  cp5 = new ControlP5(this);  
  int i = 0;
  for (String key: joints.keySet())
  {
    Joint j = joints.get(key);
    cp5.addSlider(j.id, j.idle, j.inputLow, j.inputHigh, 10, 10 + (50 * (i ++)), 470, 40);
  }
  
  leap = new LeapMotion(this);
  
  camera = new Camera();
}

PVector thumbPos = new PVector();
PVector indexPos = new PVector();
PVector handDir = new PVector();
PVector palmPos = new PVector();

float pinchStrength = 0;

void getHandInfo(Frame frame)
{
  Hand hand = frame.hands().rightmost();
  pinchStrength = hand.pinchStrength();
  
  for (Finger finger : hand.fingers())
  {    
    if (finger.type() == Finger.Type.TYPE_THUMB)
    {
      thumbPos.x = finger.tipPosition().getX();
      thumbPos.y = finger.tipPosition().getY();
      thumbPos.z = finger.tipPosition().getZ();
    }
    
    if (finger.type() == Finger.Type.TYPE_INDEX)
    {
      indexPos.x = finger.tipPosition().getX();
      indexPos.y = finger.tipPosition().getY();
      indexPos.z = finger.tipPosition().getZ();
    }
        
    Vector handD = hand.direction();
    handDir.x = handD.getX();
    handDir.y = handD.getY();
    handDir.z = handD.getZ();    
    
    Vector palmP = hand.palmPosition();
    palmPos.x = palmP.getX();
    palmPos.y = palmP.getY();
    palmPos.z = palmP.getZ();
    
    ypr[0] = hand.direction().yaw();;
    ypr[1] = hand.direction().pitch();
    ypr[2] = hand.palmNormal().roll();
  }
}

void drawDirections(float[] directions)
{  
  float gap = (float) width / (float) (directions.length + 1);
  for (int i = 0 ; i < directions.length ; i ++)
  {
    float x = (i + 1) * gap;
    float y = 400;
    pushMatrix();
    translate(x, y);
    rotate(directions[i]);
    stroke(0, 255, 255);
    line(0, 0, 0, -40);
    line(-5, -30, 0, -40);
    line(+5, -30, 0, -40);
    ellipse(0, 0, 80, 80);
    popMatrix();
  }
}

void draw()
{
  background(0);
  stroke(255, 255, 255);
  noFill();
  camera.update();    
  
  Controller controller = leap.controller();
  if (controller.isConnected())
  {     
     Frame frame = controller.frame();
     
     InteractionBox ib = frame.interactionBox();
     float scale = 1.0f;
     float thumbX = Float.MAX_VALUE;
     float indexX = Float.MAX_VALUE;
     boolean tracked = false;
     
     for (Finger finger : frame.fingers())
     {              
       tracked = true;
       float x = leap.leapToSketchX(finger.tipPosition().getX());
       float y = leap.leapToSketchY(finger.tipPosition().getY());     
       if (thumbX == Float.MAX_VALUE && indexX == Float.MAX_VALUE)
       {
         thumbX = x;
       }
       else if (indexX == Float.MAX_VALUE)
       {
         indexX = x;
       }
       ellipse(
         x
         ,y
         , 10, 10
         );
     }
     if (tracked)
     {
       getHandInfo(frame);
       float thumbIndexGap = PVector.dist(thumbPos, indexPos);
       
       joints.get("G").track(pinchStrength);
       joints.get("W").track(ypr[2]);
       joints.get("B").track(palmPos.x);
       joints.get("S").track(palmPos.z);
       joints.get("E").track(palmPos.y);
       joints.get("X").track(ypr[1]);
       
       //cp5.getController("G").setValue(map(thumbIndexGap, 7, 125, 60, 0));
       //cp5.getController("W").setValue(map(roll, .32, -2.49, 17, 185));
       //cp5.getController("B").setValue(map(palmPos.x, -150, 150, 180, 10));
       //cp5.getController("S").setValue(map(palmPos.y, 80, 260, 126, 64));
       //cp5.getController("E").setValue(map(pitch, -1.9, -1.19, 20, 40));
       //-2 -0.5
       
       handDir.mult(100);
       line(0, 0, 0, handDir.x, handDir.y, handDir.z); 
       //println(indexPos);       
       pushMatrix();
       translate(thumbPos.x, thumbPos.y, thumbPos.z);
       sphere(5);
       popMatrix();
     }
     println(palmPos.z);     
     drawDirections(ypr);
   }
   
  if (arduino.available() > 0)
  {
    String msg = arduino.readString();
    println(msg);
  }
}

 
void controlEvent(ControlEvent theEvent) 
{
  if(theEvent.isController()) 
  {
   float val = theEvent.getController().getValue();
   String servoCode = theEvent.getController().getName(); 
   arduino.write(servoCode + val); 
 }
}

void onInit(final Controller controller)
{
  println("Initialized");
}

void onConnect(final Controller controller)
{
  println("Connected");
}

void onDisconnect(final Controller controller)
{
  println("Disconnected");
}

void onExit(final Controller controller)
{
  println("Exited");
}

void onFrame(final Controller controller)
{/*
  
  if (controller.isConnected())
  {
    Frame frame = controller.frame();
    if (!frame.hands().isEmpty())
    {
      pushMatrix();
      for (Hand hand : frame.hands())
      {
        for (Finger finger : hand.fingers()) 
        {
          for(Bone.Type boneType : Bone.Type.values()) 
          {
            Bone bone = finger.bone(boneType);
            Vector pos = bone.center();
            //vertex(
            translate(pos.getX(), pos.getY(), pos.getZ());   
            box(1);
          }
        }
      }
      
      popMatrix();
    }
  }
  */
}