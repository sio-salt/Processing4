//float xoff2 = 10000;
float xyinc = 0.06;
float time = 0;
float timeinc = 0.0013;
float scale = 20;
int cols, rows;
int count = 10000;
float inivel = 0;
float forcelimit = 0.015;
float vellimit = 1.5;
float pointsize = 3;

Particle[] particles;
PVector[] ForceDir;

void setup() {

  size(1350, 900, P2D);
  cols = floor(height / scale) ;
  rows = floor(width / scale) ;
  //frameRate(10);

  ForceDir = new PVector[cols * rows];
  //ForceDir[cols * rows + 41] = PVector.random2D();
  //ForceDir[cols * rows + 40] = PVector.random2D();
  //ForceDir[cols * rows + 39] = PVector.random2D();
  //ForceDir[cols * rows + 38] = PVector.random2D();

  particles = new Particle[count];
  for (int i = 0; i < particles.length; i++) {
    particles[i] = new Particle(random(width), random(height));
  }
  //background(240);
}

void draw() {
  
  background(240, 100);


  float yoff = 1000;
  for (int y = 0; y < cols; y++) {
    float xoff = 0;
    for (int x = 0; x < rows; x++) {
      int index = x + y * rows;
      //float r = noise(xoff, yoff) * 255;

      float angle = noise(xoff, yoff, time) * TWO_PI * 2;
      ForceDir[index] = PVector.fromAngle(angle).limit(forcelimit);

      xoff += xyinc;
      //fill(r);
      //rect(x * scale, y * scale, scale, scale);

      //stroke(0);
      //strokeWeight(0.5);
      //push();
      //translate(x * scale + scale/2, y * scale + scale/2);
      //rotate(angle);
      //line(0, 0, scale, 0);
      //pop();
    }
    yoff += xyinc;
  }
  time += timeinc;
  xyinc = 0.03 * sin(time*0.5) + 0.06;

  strokeWeight(pointsize);
  for (Particle part : particles) {
    part.edges();
    part.applyForce();
    part.update();
    part.display();
  }


  println(floor(frameRate));
  //println(ForceDir[50].mag());
  //println(particles.length);
}
