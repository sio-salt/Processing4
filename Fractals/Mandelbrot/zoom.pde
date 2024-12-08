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
  
