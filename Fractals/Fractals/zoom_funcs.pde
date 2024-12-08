void zoomFractal() {
  int mouse = 0;
  if (mouseButton == LEFT)
    mouse = 3;
  else if (mouseButton == RIGHT) 
    mouse = -3;
  else if (mouseButton == CENTER)
    mouse = -5;

  float percent = 1 - float(mouse) / 100;
  Complex mouseComp = pt2Comp(mouseY, mouseX);
  zoom(mouseComp, percent);
}

void zoom(Complex mouseComp, float percent) {
  transDrawRange(mouseComp);
  zoomDrawRange(percent);
  mouseComp.re *= -1;
  mouseComp.im *= -1;
  transDrawRange(mouseComp);
}

void transDrawRange(Complex trans) {
  xmin -= trans.re;
  xmax -= trans.re;
  ymin -= trans.im;
  ymax -= trans.im;
}

void zoomDrawRange(float percent) {
  xmin *= percent;
  xmax *= percent;
  ymin *= percent;
  ymax *= percent;
}
