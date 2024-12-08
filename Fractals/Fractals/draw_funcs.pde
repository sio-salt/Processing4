Complex pt2Comp(int y, int x) {
  double re = doublemap(x, 0, width, xmin, xmax);
  double im = doublemap(y, 0, height, ymin, ymax);
  return new Complex(re, im);
}

void drawFractal() {
  for (int y = 0; y < height; y += 1) {
    for (int x = 0; x < width; x += 1) {
      Complex c = pt2Comp(y, x);
      IntComp ic = numIterFractal(c);
      int numIter = ic.n;
      Complex z = ic.z;

      color col = colorFractal(numIter, z);
      int index = x + y * width;
      pixels[index] = col;
    }
  }
  updatePixels();
  coordInfo();
}

double doublemap(double in, double minin, double maxin, double minout, double maxout) {
  return ((in - minin) / (maxin - minin)) * (maxout - minout) + minout;
}

interface Fractal {
  void apply(Complex z, Complex c);
}
Fractal mandelbrot = (z, c) -> {
  Complex zTemp = z.mul(z).add(c);
  z.re = zTemp.re;
  z.im = zTemp.im;
};
Fractal burningShip = (z, c) -> {
  Complex zTemp = new Complex(Math.abs(z.re), Math.abs(z.im));
  zTemp = zTemp.mul(zTemp).add(c);
  z.re = zTemp.re;
  z.im = zTemp.im;
};
Fractal feather = (z, c) -> {
  Complex z2 = new Complex(z.re*z.re + 1.0, z.im*z.im);
  Complex zTemp = z.mul(z).mul(z).div(z2).add(c);
  z.re = zTemp.re;
  z.im = zTemp.im;
};
Fractal sfx = (z, c) -> {
  Complex c2 = new Complex(c.re*c.re, c.im* c.im);
  Complex zTemp = z.scholorMul(z.normsq()).add(z.mul(c2));
  z.re = zTemp.re;
  z.im = zTemp.im;
};
Fractal[] all_fractals = {
  mandelbrot,
  burningShip,
  feather,
  sfx,
};


IntComp numIterFractal(Complex c) {
  int numIter = 0;
  Complex z = new Complex(0, 0);

  while (numIter < maxIteration && z.normsq() < Math.pow(escapeRadius, 2.0)) {
    all_fractals[fractalType].apply(z, c);
    numIter++;
  }

  return new IntComp(numIter, z);
}

class IntComp {
  int n;
  Complex z;

  IntComp(int n, Complex z) {
    this.n = n;
    this.z = z;
  }
}

void coordInfo() {
  double mapmousex = doublemap(mouseX, 0, width, xmin, xmax);
  double mapmousey = doublemap(mouseY, 0, height, ymin, ymax);
  Complex zMouse = new Complex(mapmousex, mapmousey);
  IntComp ic = numIterFractal(zMouse);
  int n = ic.n;
  Complex z = ic.z;
  String coord_iter_frame_zoom = zMouse.toString()
    + "    num of iter = " + n
    //+ "    final z = " + z
    //+ "    log2 = " + log2(log2(z.norm()))
    + "    framerate = " + frameRate;
  println(coord_iter_frame_zoom);
}
