class BallSystem {
    ArrayList<Ball> balls;
    PVector forceField;
    PVector gravity;
    String cornerText;
    float airFric, coefRest;
    int maxUpdates, gridSize;
    ArrayList<Ball>[][] gridPartition;

    BallSystem(PVector gr, float af, float cr, int mu, int gs) {
        balls = new ArrayList<Ball>();
        forceField = new PVector(0, 0);
        gravity = gr;
        cornerText = "";
        airFric = af;
        coefRest = cr;
        maxUpdates = mu;
        gridSize = gs;
        gridPartition = new ArrayList[width / gridSize + 4][height / gridSize + 4];
    }

    PVector getGridPos(PVector pos) {
        return new PVector(floor(pos.x / gridSize) + 2, floor(pos.y / gridSize) + 2);
    }

    void addBallToGrid(Ball b) {
        PVector gridPos = getGridPos(b.pos);
        if (gridPartition[(int)(gridPos.x)][(int)(gridPos.y)] == null) {
            gridPartition[(int)(gridPos.x)][(int)(gridPos.y)] = new ArrayList<Ball>();
        }
        gridPartition[(int)gridPos.x][(int)gridPos.y].add(b);
    }

    void removeBallFromGrid(Ball b) {
        PVector gridPos = b.gridPos;
        if (gridPartition[(int)gridPos.x][(int)gridPos.y] != null)
            gridPartition[(int)gridPos.x][(int)gridPos.y].remove(b);
    }

    void updateGrid() {
        ArrayList<Ball>[][] newGridPartition = new ArrayList[width / gridSize + 10][height / gridSize + 10];
        for (int i = 0; i < balls.size(); i++) {
            Ball bi = balls.get(i);
            bi.gridPos = getGridPos(bi.pos);
            if (newGridPartition[(int)(bi.gridPos.x)][(int)(bi.gridPos.y)] == null) {
                newGridPartition[(int)(bi.gridPos.x)][(int)(bi.gridPos.y)] = new ArrayList<Ball>();
            }
            newGridPartition[(int)bi.gridPos.x][(int)bi.gridPos.y].add(bi);
        }
        gridPartition = newGridPartition;
    }

    void addBalls(int nBalls) {
        for (int i = 0; i < nBalls; i++) {
            color c = color(random(255), random(255), random(255));
            float speed = 0.5;
            balls.add(new Ball(random(width), random(height), random( -speed, speed), random( -speed, speed), random(20, 40), c));
        }
    }

    void addBall(Ball b) {
        balls.add(b);
    }

    void applyForceField(PVector force) {
        forceField.add(force);
    }

    void updateSystem() {
        for (int i = 0; i < balls.size(); i++) {
            Ball bi = balls.get(i);
            bi.applyForce(forceField);
            bi.applyForce(PVector.mult(bi.vel, -airFric * bi.r / 50));
            bi.applyGravity(gravity);
            bi.gridPos = getGridPos(bi.pos);
            bi.update();
            addBallToGrid(bi);
        }
        for (int numUpdate = 0; numUpdate < maxUpdates; numUpdate++) {
            for (int i = 0; i < balls.size(); i++) {
                Ball bi = balls.get(i);
                bi.boundaries(coefRest);
                PVector gridPos = bi.gridPos;
                for (int dx = -1; dx <= 1; dx++) for (int dy = -1; dy <= 1; dy++) {

                        if (!(gridPos.x + dx >= 0 && gridPos.x + dx < gridPartition.length && 
                            gridPos.y + dy >= 0 && gridPos.y + dy < gridPartition[0].length) || 
                            gridPartition[(int)gridPos.x + dx][(int)gridPos.y + dy] == null) {
                            continue;
                        }

                    int numBallsInGrid = gridPartition[(int)gridPos.x + dx][(int)gridPos.y + dy].size();
                    for (int j = 0; j < numBallsInGrid; j++) {

                        Ball bj = gridPartition[(int)gridPos.x + dx][(int)gridPos.y + dy].get(j);
                        if (numUpdate == 0) {
                            bi.ballCollisionWithCoef(bj, coefRest);
                        } else {
                            bi.ballCollisionWithCoef(bj, 1.0);
                        }
                    }
                }
            }
            updateGrid();
        }
    }

    void displaySystem() {
        for (int i = 0; i < balls.size(); i++) {
            balls.get(i).display();
        }
    }

    void displayTexts() {
        cornerText = displayFrameRate() + "\n" + displaySystemEnergy();
        fill(0);
        textSize(20);
        text(cornerText, 10, 20);
    }

    String displayFrameRate() {
        return "Frame Rate: " + frameRate + "\n" + "Number of Balls: " + balls.size();
    }

    String displaySystemEnergy() {
        float kineticEnergy = 0;
        float potentialEnergy = 0;
        for (int i = 0; i < balls.size(); i++) {
            kineticEnergy += 0.5 * balls.get(i).mass * balls.get(i).vel.magSq();
            potentialEnergy += balls.get(i).mass * gravity.y * (height - balls.get(i).pos.y);
        }

        return "Kinetic Energy: " + kineticEnergy + "\n" + "Potential Energy: " + potentialEnergy + "\n" + "Total Energy: " + (kineticEnergy + potentialEnergy);

    }
}
