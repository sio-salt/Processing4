void zoomFractal() {
  int mouse = 0;
  double mapmousex = doublemap(mouseX, 0, width, xmin, xmax);
  double mapmousey = doublemap(mouseY, 0, height, ymin, ymax);

  if (mouseButton == LEFT) {
    mouse = 3;
  } else if (mouseButton == RIGHT) {
    mouse = -3;
  } else if (mouseButton == CENTER) {
    mouse = -5;
  }

  float percent = 1 - float(mouse) / 100;
  zoom(mapmousex, mapmousey, percent);
}

void zoom(double mapmousex, double mapmousey, float percent) {
  translateAll(mapmousex, mapmousey);
  mulAll(percent);
  translateAll(-mapmousex, -mapmousey);
}

void translateAll(double tx, double ty) {
  xmin -= tx;
  xmax -= tx;
  ymin -= ty;
  ymax -= ty;
}

void mulAll(float percent) {
  xmin *= percent;
  xmax *= percent;
  ymin *= percent;
  ymax *= percent;
}
