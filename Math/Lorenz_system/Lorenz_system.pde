float x = 0.01;
float y = 0.2;
float z = 0.4;
float a = 10;
float b = 8.0/3.0;
float c = 28;

ArrayList<PVector> points = new ArrayList<PVector>();

//PeasyCam cam;

void mousePressed() { 
  x = 0.01;
  y = 0.2;
  z = 0.4;
  points.clear();
}

void setup() {
  size(800, 600, P3D);
  colorMode(HSB);
  //cam = new PeasyCam(this, 500);
}

void draw() {
  background(0);
  float dt = 0.01;
  float dx = a * (y - x) * dt;
  float dy = (x * (c - z) - y) * dt;
  float dz = (x * y - b * z) * dt;
  x = x + dx;
  y = y + dy;
  z = z + dz;

  points.add(new PVector(x, y, z));

  translate(width / 2, height / 2, 0);
  rotateY(frameCount / 2.0 / 60.0);
  strokeWeight(0.3);
  scale(3);
  noFill();
  float hu = 0;
  beginShape();
  for ( PVector v : points) {
    stroke(hu, 255, 255);
    vertex(v.x, v.y, v.z);
    hu += 0.1;
    if (hu > 255) {
      hu = 0;
    }
  }
  endShape();

  println(frameCount, x, y, z);
}
