import java.util.Map;
HashMap<Integer, Integer> balls2ImgColor = new HashMap<Integer, Integer>();

PImage img;
//boolean showImage = true;
boolean showImage = false;

float airFric = 0.16;
float coefRest = 0.28;
PVector gravity = new PVector(0, 0.2);
int maxUpdates = 14;
int maxBalls = 1100;
int gridSize = 100;
int extraLoopCnt = 70;
int finalLoopCnt;
int framesAfterStop;
boolean reachedMaxBalls;


BallSystem bs;


void setup() {
     //size(750*3/2, 450*3/2);
    size(500*5/4, 400*5/4);
    colorMode(HSB, 360, 100, 100, 100);

    bs = new BallSystem(gravity, airFric, coefRest, maxUpdates, gridSize);

    img = loadImage("./image/Kirby_official.png");
    img.resize(width, height);



    reachedMaxBalls = false;
    framesAfterStop = Integer.MAX_VALUE;
    int whileLoopCnt = 0;
    boolean updating = true;
    int seed = 0;
    randomSeed(seed);
    while(updating) {
        whileLoopCnt++;
        updating = simulateBallSystem(true, whileLoopCnt, extraLoopCnt);
    }
    finalLoopCnt = whileLoopCnt;
    // println("finalLoopCnt: " + finalLoopCnt);

    // create a mapping from ball index to image color
    for (int i = 0; i < bs.balls.size(); i++) {
        Ball b = bs.balls.get(i);

        // check overlap with image
        if (!(img != null && img.width > 0 && img.height > 0 && 
            b.pos.x > 0 && b.pos.x < img.width && b.pos.y > 0 && b.pos.y < img.height)) {
            continue;
        }

        int imgColor = img.get((int)b.pos.x,(int)b.pos.y);
        if (alpha(imgColor) < 4) {
            balls2ImgColor.put(i, b.c);
        } else {
            balls2ImgColor.put(i, imgColor);
        }
    }

    reachedMaxBalls = false;
    framesAfterStop = Integer.MAX_VALUE;
    randomSeed(seed);
    bs = new BallSystem(gravity, airFric, coefRest, maxUpdates, gridSize);
}


void draw() {
    boolean updating = simulateBallSystem(false, frameCount, extraLoopCnt);

    background(0,0,100);

    if (showImage) {
        image(img, 0, 0);
    }

    if (updating) { 
        bs.displaySystem();
        bs.displayTexts();
    } else {
        bs.displaySystem();
        noLoop();
        println("stopped");
    }
}


// toggle image display with space key
void keyPressed() {
    if (key == ' ') {
        showImage = !showImage;
    }
}


boolean simulateBallSystem(boolean preRun, int loopCnt, int extraLoopCnt) {
    int systemSize = bs.balls.size();
    if (systemSize >= maxBalls && !reachedMaxBalls) {
        reachedMaxBalls = true;
        framesAfterStop = loopCnt;
    }

    boolean updating = loopCnt - framesAfterStop < extraLoopCnt;
    if (updating) {
        bs.updateSystem();
    }

    // int numBallSpawner = floor(loopCnt / 800) + 1;
    int numBallSpawner = 1;
    for (int i = 0; i < numBallSpawner; i++) {
        color c;
        if (!preRun && balls2ImgColor.containsKey(systemSize)) {
            c = balls2ImgColor.get(systemSize);
        } else {
            c = color(loopCnt % 360, 100, 100);
        }

        float bx = width * 0.8 * pow(sin(loopCnt * 0.01 + i * PI / 3), 2) + width * 0.1;
        float by = 20;
        float r = random(5, 15);
        float ballSpeed = 15;
        PVector target = new PVector(width / 2, height / 2);
        PVector initVel = new PVector(target.x - bx, target.y).setMag(ballSpeed);

        if (!reachedMaxBalls) {
            // change the sppeed of adding balls depending on the ball size
            if (loopCnt % (int)((2 * r / ballSpeed) * 2.5) == 0) {
                bs.addBall(new Ball(bx, by, initVel.x, initVel.y, r, c));
            }
        }

        if (!reachedMaxBalls && !preRun) {
            fill(0, 0, 0); ellipse(bx, by, 30, 30);
            fill(loopCnt % 360, 100, 100); ellipse(bx, by, 29, 29);
        }
    }

    return updating;
}
