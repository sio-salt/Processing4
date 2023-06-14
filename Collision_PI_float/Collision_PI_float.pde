int sizeW = 1200;
int sizeH = 800;
int wallorblock;
float ground = float(sizeH) / 1.5;
int digits = 6;
float mass = pow(100, float(digits));
int collisioncount = 0;
int checkcount = 20000;
int j = 0;

import processing.sound.*;
SoundFile file;

Block block1 = new Block(sizeW * 0.8, -2.0 / checkcount, mass, 120);
Block block2 = new Block(sizeW * 0.25, 0.0, 100.0, 50);


void settings() {   //size関数の中で変数を使いたいときにsettings関数が必要。
  size(sizeW, sizeH);
}

void setup() {
  file = new SoundFile(this, "click.wav");
  file.amp(0.4);
  rectMode(RADIUS);
  textSize(50);
}

void draw() {
  float ground = height/1.5;

  background(250);
  fill(200);
  rect(width / 2, ground + (height - ground) / 2, width / 2 + 1, (height - ground) / 2);

  fill(50, 50, 100);
  for (int i = 0; i < checkcount; i++) {
    block1.update();
    block2.update();
    block2.wallcollision();
    block1.collision(block2);
  }

  block1.display();
  block2.display();
  block1.finishcheck(block2);
  text(collisioncount, 50, 75);
  println((int)frameRate);
}
