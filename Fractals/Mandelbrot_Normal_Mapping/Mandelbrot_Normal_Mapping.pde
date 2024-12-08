int maxIteration = 200;
double escapeRadius = 1000.0;
double xmin = -2;
double xmax = 1;
double ymin = -1.5;
double ymax = 1.5;

static final int canvasWidth = 300;
static final int canvasHeight = 300;

float zoomFactor = 1.005;

void settings() {
  size(canvasWidth, canvasHeight);
}

void setup() {
  loadPixels();
  drawMandelbrot();
  updatePixels();
}

void draw() {
  if (mousePressed) {
    zoomFractal();
    drawMandelbrot();
    updatePixels();
  }
}

void keyPressed() {
  if (keyCode == UP) {
    maxIteration = (int)max(maxIteration+1, maxIteration * zoomFactor);
    println(maxIteration);
  } else if (keyCode == DOWN) {
    maxIteration = (int)min(maxIteration-1, maxIteration / zoomFactor);
    println(maxIteration);
  }
}

void keyReleased() {
  if (keyCode == UP || keyCode == DOWN) {
    drawMandelbrot();
    updatePixels();
  }
}

double doublemap(double in, double minin, double maxin, double minout, double maxout) {
  return ((in - minin) / (maxin - minin)) * (maxout - minout) + minout;
}

Complex pt2Comp(int y, int x) {
  double re = doublemap(x, 0, width, xmin, xmax);
  double im = doublemap(y, 0, height, ymin, ymax);
  return new Complex(re, im);
}

void drawMandelbrot() {
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      Complex c = pt2Comp(y, x);
      color col = computeColor(c);
      int index = x + y * width;
      pixels[index] = col;
    }
  }
}

color computeColor(Complex c) {
  double reflection = giveReflection(c);
  color col;
  if (reflection == 0.0) {
    col = color(0, 0, 127);
  } else {
    int b = (int)(255 * reflection);
    col = color(b, b, b);
  }
  return col;
}

double giveReflection(Complex c) {
  Complex z = new Complex(0.0, 0.0);
  Complex dc = new Complex(0.0, 0.0);
  Complex one = new Complex(1.0, 0.0);
  double reflection = 0.0;
  double h2 = 1.5;  // height factor of the incoming light
  float angle = 45.0;  // incoming direction of light
  Complex v = new Complex(0.0, angle * PI / 180.0).exp();  // unit 2D vector in this direction
  // incoming light 3D vector = (v.re, v.im, h2)
  
  for (int i = 0; i < maxIteration; i++) {
    dc = dc.mul(z).scholorMul(2.0).add(one);
    z = z.mul(z).add(c);
    if (z.normsq() > escapeRadius*escapeRadius) {
      Complex u = z.div(dc);
      u = u.scholorMul(1.0 / u.norm());
      reflection = u.dot(v) + h2;    // 0 < u.dot(v) < 1
      reflection /= 1 + h2;          // abs(reflection) < 1
      if (reflection < 0.0) {
        reflection = 0.0;
      }
      break;
    }
  }
  return reflection;
}
