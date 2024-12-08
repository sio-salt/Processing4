
ArrayList<PVector> cornerPoints = new ArrayList<PVector>();
PVector prevPoint;
int cornerSetupCnt = 0;
color conerColor = color(0, 250, 0);
color gasketColor = color(0, 240, 0);

void setup() {
    size(900, 900);
    background(255);
}

void mousePressed() {
    if (cornerSetupCnt < 3) {
        stroke(conerColor);
        strokeWeight(12);
        point(mouseX, mouseY);
        PVector cornerPoint = new PVector(mouseX, mouseY);
        cornerPoints.add(cornerPoint);
        println("point", cornerSetupCnt + 1, "set on", mouseX, mouseY);
    }
    if (cornerSetupCnt == 3) {
        stroke(gasketColor);
        strokeWeight(2);
        point(mouseX, mouseY);
        prevPoint = new PVector(mouseX, mouseY);
        println("Sierpinski Gasket Start!!");
    }
    cornerSetupCnt++;
}

void draw() {
    for (int i = 0; i < 10; i++) {
        if (cornerSetupCnt > 3) {
            int cornerSelector = (int)random(3);
            PVector selectedCorner = cornerPoints.get(cornerSelector);
            PVector newPoint = PVector.sub(selectedCorner, prevPoint).mult(0.5).add(prevPoint);
            stroke(gasketColor);
            strokeWeight(2);
            point(newPoint.x, newPoint.y);
            prevPoint = newPoint;
        }
    }
}
