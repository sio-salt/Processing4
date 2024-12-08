color colorFractal(int numIter, Complex z) {
  color col;
  switch (coloringType) {
  case 1:
    col = normalizedIterationCount(numIter, z);
    break;
  case 2:
    col = redish(numIter);
  case 3:
    col = myColoring(numIter);
    break;
  case 4:
    col = simpleBlackWhite(numIter);
    break;
  case 5:
    col = exteriorCoord(numIter, z);
    break;
  case 6:
    col = blueCosine(numIter, z);
    break;
  default:
    col = color(0);
    break;
  }
  return col;
}


double log2(double i) {
  return Math.log(i) / Math.log(2.0);
}

color normalizedIterationCount(int numIter, Complex z) {
  if (numIter == maxIteration)
    return color(0, 0, 0);

  double v = log2(numIter + 1 - log2(log2(z.norm()))) / 5.0;
  color c;
  if (v < 1.0) {
    int r = (int)(Math.pow(v, 4) * 255);
    int g = (int)(Math.pow(v, 2.5) * 255);
    int b = (int)(v * 255);
    c = color(r, g, b);
  } else {
    v = Math.max(0.0, 2.0 - v);
    int r = (int)(Math.pow(v, 2) * 255);
    int g = (int)(Math.pow(v, 1.5) * 255);
    int b = (int)(Math.pow(v, 3) * 255);
    c = color(r, g, b);
  }
  return c;
}

color blueCosine(int numIter, Complex z) {
  if (numIter >= maxIteration) {
    return color(0, 0, 0);
  }
  double radiusSq = z.normsq();
  double LOG2 = Math.log(2);
  double nu = Math.log(Math.log(radiusSq) / 2.0 / LOG2) / LOG2;
  double density = 0.35;
  double alpha = Math.log((numIter + 1 - nu) * 0.05 * density + 1);
  double shift = 0.0;
  int r = (int)(Math.cos((alpha * 2.0 - 1.0 + shift) * PI) + 1.0);
  int g = (int)(Math.cos((alpha * 2.0 - 0.75 + shift) * PI) + 1.0);
  int b = (int)(Math.cos((alpha * 2.0 - 0.5 + shift) * PI) + 1.0);
  return color(r*255, g*255, b*255);
}

color redish(int numIter) {
  double fac = 3 * Math.log(maxIteration - numIter) / Math.log(maxIteration - 1.0);
  color col;
  if (fac < 1) {
    col = color((int)(255 * fac), 0, 0);
  } else if ( fac < 2 ) {
    col = color(255, (int)(255 * (fac - 1)), 0);
  } else {
    col = color(255, 255, (int)(255 * (fac - 2)));
  }
  return col;
}

color myColoring(int numIter) {
  float h = ((1000 * numIter / maxIteration) + 180) % 360;
  float s = 100;
  float b = 100;
  if (numIter == maxIteration) {
    b = 0;
  }
  //return hsbToRgb(h, s, b);
  return color(h, s, b);
}

color simpleBlackWhite(int numIter) {
  float b = map(numIter, 0, maxIteration, 0, 255);
  return color(b);
}

double fmod(double x, double y) {
  return x - y * Math.floor(x / y);
}
color exteriorCoord(int numIter, Complex z) {
  Complex c = new Complex(fmod(1 + z.arg() / (2 * PI), 1), (2 - Math.log(z.norm()) / Math.log(escapeRadius)));
  int b = (int)doublemap(c.normsq(), 0, 10, 0, 255);
  return color(b, b, b);
}
color hsbToRgb(float hue, float saturation, float brightness) {
  // normalize Hue
  float h = hue / 360.0;

  // 色相セクターを計算
  int i = floor(h * 6);
  float f = h * 6 - i;
  float p = brightness * (1 - saturation);
  float q = brightness * (1 - f * saturation);
  float t = brightness * (1 - (1 - f) * saturation);
  float r, g, b;

  switch (i % 6) {
  case 0:
    r = brightness;
    g = t;
    b = p;
    break;
  case 1:
    r = q;
    g = brightness;
    b = p;
    break;
  case 2:
    r = p;
    g = brightness;
    b = t;
    break;
  case 3:
    r = p;
    g = q;
    b = brightness;
    break;
  case 4:
    r = t;
    g = p;
    b = brightness;
    break;
  case 5:
    r = brightness;
    g = p;
    b = q;
    break;
  default:
    r = g = b = 0; // このケースは発生しないはず
  }

  // RGBを0-255の範囲に変換
  return color(r * 255, g * 255, b * 255);
}
