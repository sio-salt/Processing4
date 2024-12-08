PVector fernPoint = new PVector(0, 0);
color fernColor = color(34, 139, 34);
float[] prob = {0.01, 0.85, 0.07, 0.07};
float[][][] barnsley_hutchinson = {
    {{0, 0}, {0, 0.16}, {0, 0}},
    {{0.85, 0.04}, {-0.04, 0.85}, {0, 1.60}},
    {{0.20, -0.26}, {0.23, 0.22}, {0, 1.60}},
    {{-0.15, 0.28}, {0.26, 0.24}, {0, 0.44}}
};

PVector affineMap(float[][] mat, PVector vec) {
    PVector newVec = new PVector(0, 0);
    newVec.x = mat[0][0] * vec.x + mat[0][1] * vec.y + mat[2][0];
    newVec.y = mat[1][0] * vec.x + mat[1][1] * vec.y + mat[2][1];
    return newVec;
}

PVector affineMapSelector(PVector prevPoint) {
    float rand = random(1);
    for (int i = 0; i < prob.length - 1; i++) {
        if (rand < prob[i]) {
            return  affineMap(barnsley_hutchinson[i], prevPoint);
        }
        rand -= prob[i];
    }
    return affineMap(barnsley_hutchinson[prob.length - 1], prevPoint);
}

void drawFern() {
    stroke(fernColor);
    strokeWeight(1);
    // fern exists in -2.1820 < x < 2.6558 and 0 ≤ y < 9.9983
    float px = map(fernPoint.x, -2.1820, 2.6558, 0, width);
    float py = map(fernPoint.y, 0, 9.9983, height, 0);
    point(px, py);
    fernPoint = affineMapSelector(fernPoint);
}

void setup() {
    size(1600, 1200);
    background(255);
}

void draw() {
    for (int i = 0; i < 20000; i++) {
        drawFern();
    }
}
