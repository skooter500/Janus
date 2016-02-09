class Joint
{
  String id;
  
  float idle;
  
  // Across the full range of input
  float inputLow; 
  float inputHigh;  

  // The leap range we want to track
  float trackLow;
  float trackHigh;  

  // The limit of the servo
  float servoLow;
  float servoHigh;
  
  public Joint(String id, float idle, float inputLow, float inputHigh, float trackLow, float trackHigh, float servoLow, float servoHigh)
  {
    this.id = id;
    this.idle = idle;
    this.inputLow = inputLow;
    this.inputHigh = inputHigh;
    this.trackLow = trackLow;
    this.trackHigh = trackHigh;
    this.servoLow = servoLow;
    this.servoHigh = servoHigh;
  }
   
  
  void track(float value)
  {
    float temp = norm(value, trackLow, trackHigh);
    if (temp < 0)
    {
      value = trackLow;
    }
    if (temp > 1)
    {
      value = trackHigh;
    }
    cp5.getController(id).setValue(map(value, trackLow, trackHigh, servoLow, servoHigh));       
  }
  
  
}