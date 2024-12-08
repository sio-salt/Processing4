class Particle {
  PVector Pos;
  PVector Vel;
  PVector Acc;
  PVector Force = new PVector(3,1);
  
  Particle(float x, float y) {
    Pos = new PVector(x,y);
    Vel = PVector.random2D().mult(inivel);
    Acc = new PVector(0,0);
  }
  
  void update() {
    Vel.add(Acc).limit(vellimit);
    Pos.add(Vel);
    Acc.mult(0);
  }
  
  void applyForce() {
    int x = floor((Pos.x / scale)*0.99);
    int y = floor((Pos.y / scale)*0.99);
    int forceindex = x + y * rows;
    Acc.add(ForceDir[forceindex]);
  }
  
  void followForce() {
    
  }
  
  void display() {
    stroke(0,70);
    point(Pos.x, Pos.y);
  }
  
  void edges() {
    if(Pos.x < 0) Pos.x = width;
    if(Pos.x > width) Pos.x = 0;
    if(Pos.y < 0) Pos.y = height;
    if(Pos.y > height) Pos.y = 0;
  }
  
}
