
int MaxIteration = 500;
double inixmin = -2;
double inixmax = 1;
double iniymin = -1.5;
double iniymax = 1.5;

double doubler = 0;

double xmin = inixmin;
double xmax = inixmax;
double ymin = iniymin;
double ymax = iniymax;


void setup() {
  size(300, 300);
  colorMode(HSB, 360, 100, 100);
}

void draw() {

  loadPixels();
  //frameRate(60);


  //zoom機能
  int mouse = 0;
  double mapmousex = doublemap(mouseX, 0, width, xmin, xmax);
  double mapmousey = doublemap(mouseY, 0, height, ymin, ymax);
  if (mousePressed == true) {
    if (mouseButton == LEFT) {
      mouse = 3;
    } else if (mouseButton == RIGHT) {
      mouse = -3;
    } else if (mouseButton == CENTER) {
      mouse = -5;
    }

    float percent = 1 - float(mouse) / 100;     //caution! : mouseはintだからfloatをつけろ！
    zoom(mapmousex, mapmousey, percent);
    mouse = 0;
  }


  for (int y = 0; y < height; y += 1) {
    for (int x = 0; x < width; x += 1) {
      double a = doublemap(x, 0+doubler, width+doubler, xmin, xmax);
      double b = doublemap(y, 0+doubler, width+doubler, ymin, ymax);

      int n = CheckMandelbrot(a, b);
      int dark = 100;
      if (n == MaxIteration) {
        dark = 0;
      }
      float hu = MandelColor(n);
      float satu = map(n, 0, MaxIteration, 0, 50);

      int index = x + y * width;
      pixels[index] = color(hu, 100, dark);
    }
  }

  updatePixels();

  String coord_iter_frame_zoom = mapmousex +  "  " + mapmousey + "i"
    + "    num of iter = " + CheckMandelbrot(mapmousex, mapmousey)
    + "    framerate = " + frameRate;
  println(coord_iter_frame_zoom);
}



double doublemap(double in, double minin, double maxin, double minout, double maxout) {
  return ((in / (maxin - minin)) * (maxout - minout)) + minout;
}
