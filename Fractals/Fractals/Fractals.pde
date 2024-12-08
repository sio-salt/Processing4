int fractalType = 1;      // 0: Mandelbrot set,  1: Burning Ship Fractal,  2: feather,  3: sfx
int coloringType = 1;     // 1 ~ 6 are available

static final int canvasWidth = 500;
static final int canvasHeight = 500;

int maxIteration = 100;   // UpArrow to increment and DownArrow to decrement
double escapeRadius = 20.0;
double xmin = -2;
double xmax = 1;
double ymin = -1.5;
double ymax = 1.5;

double doubler = 0.0;
float zoomFactor = 1.005;

void settings() {
  size(canvasWidth, canvasHeight);
}

void setup() {
  surface.setResizable(true);

  switch (coloringType) {
  case 1:
    colorMode(RGB);
    break;
  case 2:
    colorMode(HSB, 360, 100, 100);
    break;
  case 3:
    colorMode(RGB);
    break;
  default:
    colorMode(RGB);
    break;
  }
  loadPixels();
  drawFractal();
}

boolean firstDraw = true;
void draw() {
  if (mousePressed) {
    zoomFractal();
    drawFractal();
  }
  if (firstDraw) {
    zoomFractal();
    drawFractal();
    firstDraw = false;
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
    drawFractal();
  }
}
