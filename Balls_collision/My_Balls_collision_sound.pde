//Many balls colliding

import processing.sound.*;
SoundFile file;

int numballs = 10;
Ball[] balls = new Ball[numballs];


void setup() {
  size(1200, 800);
  for (int i = 0; i < numballs; i++) {
    balls[i] = new Ball(random(width), random(height), random(20, height / (numballs)));
  }
  
  file = new SoundFile(this, "../../data/click.wav");
  file.amp(0.4);
}

void draw() {
  background(50);
  
  for(Ball b : balls) {
    b.checkBoundary();
    b.update();
    b.display();
  }

    for(int j = 0; j < numballs; j++){
      for(int k = j + 1; k < numballs; k++){
        balls[j].checkCollision(balls[k]);
      }
    }
  
  println(frameRate);
}
