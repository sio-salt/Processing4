class Ball {
    PVector pos, vel, acc, gridPos;
    float r, mass;
    color c;
    
    Ball(float x, float y, float vx, float vy, float rad, color col) {
        pos = new PVector(x, y);
        vel = new PVector(vx, vy);
        acc = new PVector(0, 0);
        gridPos = new PVector(0, 0);
        r = rad;
        mass = PI * rad * rad / 25;
        c = col;
    }
    
    void applyForce(PVector force) {
        PVector a = PVector.div(force, mass);
        acc.add(a);
    }
    
    void applyGravity(PVector gravity) {
        acc.add(gravity);
    }
    
    
    void update() {
        vel.add(acc);
        pos.add(vel);
        acc.mult(0);
    }
    
    void display() {
        noStroke();
        fill(c);
        ellipse(pos.x, pos.y, r * 2, r * 2);
        // momentumArrow();
    }
    
    void momentumArrow() {
        PVector momentum = PVector.mult(vel, mass);
        stroke(0);
        strokeWeight(2);
        float arrowResizer = 0.02;
        PVector arrowHead = PVector.add(pos, PVector.mult(momentum, arrowResizer));
        line(pos.x, pos.y, arrowHead.x, arrowHead.y);
    }
    
    void boundaries(float coefRest) {
        if (pos.x > width - r) {
            pos.x = width - r;
            vel.x *= -coefRest;
        } else if (pos.x < r) {
            pos.x = r;
            vel.x *= -coefRest;
        }

        if (pos.y > height - r) {
            pos.y = height - r;
            vel.y *= -coefRest;
        } else if (pos.y < r) {
            pos.y = r;
            vel.y *= -coefRest;
        }
    }
    
    void ballCollisionWithCoef(Ball other, float coefRest) {
        PVector posDiff = PVector.sub(pos, other.pos);
        float distance = posDiff.mag();
        float overlap = r + other.r - distance;
        // check overlap
        if (overlap <= 0)
            return;
        
        // resolve overlap
        PVector nomal = posDiff.setMag(1);
        PVector move = PVector.mult(nomal, overlap / 2);
        pos.add(move);
        other.pos.sub(move);
        
        // calculate new velocities with coefficient of restitution
        // https://en.wikipedia.org/wiki/Inelastic_collision
        float harmonicMeanMass = mass * other.mass / (mass + other.mass);
        PVector velDiff = PVector.sub(vel, other.vel);

        float nomalImpulse = -harmonicMeanMass * (1 + coefRest) * PVector.dot(velDiff, nomal);
        
        PVector dv = PVector.mult(nomal, nomalImpulse / mass);
        PVector dvOther = PVector.mult(nomal, -nomalImpulse / other.mass);
        
        vel.add(dv);
        other.vel.add(dvOther); 
    }
    
    
    void ballCollisionNoCoef(Ball other) {
        PVector posDiff = PVector.sub(pos, other.pos);
        float distance = posDiff.mag();
        float overlap = r + other.r - distance;
        // check overlap
        if (overlap <= 0)
            return;
        
        // resolve overlap
        PVector move = posDiff.setMag(overlap / 2);
        pos.add(move);
        other.pos.sub(move);
        
        // calculate new velocities
        float sumMass = mass + other.mass;
        PVector velDiff = PVector.sub(vel, other.vel);
        float posVelDot = PVector.dot(posDiff, velDiff);
        float factor = (1 / sumMass) * (posVelDot / posDiff.magSq());
        PVector newVel = PVector.sub(vel, PVector.mult(posDiff, 2 * other.mass * factor));
        PVector newVelOther = PVector.sub(other.vel, PVector.mult(posDiff, -2 * mass * factor));
        
        vel = newVel;
        other.vel = newVelOther;
    }
}
