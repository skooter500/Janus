class Camera
{
  PVector pos;
  PVector forward;
  
  Camera()
  {
    pos = new PVector(0, 0, 500);
    forward = new PVector(0, 0, -1);    
  }
  
  void update()
  {
    //camera(0, 0, -500, 0, 0, -1, 0, 1, 0);
 
    camera(pos.x, pos.y, pos.z, pos.x + forward.x, pos.y + forward.y, pos.z + forward.z, 0, 1, 0);
  }
  
}