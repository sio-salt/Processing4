class Block {

  float pos, vel, mass, rad;

  Block(float x, float v, float m, float r) {
    pos = x;
    vel = v;
    mass = m;
    rad = log100(mass) * 20.0 + 20;
    //rad = r;
  }

  void collision(Block other) {
    //めり込み補正用。距離はすべて正方形の中心間。
    float mindistance = rad + other.rad;
    float distance = abs(pos - other.pos);

    if (distance < mindistance && wallorblock == 0) {
      wallorblock = 1;
      int sinkcorrectionmode = 0;
      if (sinkcorrectionmode == 1) {
        //下4行はめり込み補正
        float sinkcorrection = (mindistance - distance) / 2.0;
        float direction_normalized = (pos - other.pos) / distance;
        pos += direction_normalized * sinkcorrection;
        other.pos += direction_normalized * sinkcorrection;
      }

      //conservation of momentum
      float tempvel = vel;
      float tempothervel = other.vel;
      vel = ((mass - other.mass) * tempvel + 2 * other.mass * tempothervel) / (mass + other.mass);
      other.vel = (2 * mass * tempvel + (other.mass - mass) * tempothervel) / (mass + other.mass);

      file.stop();
      file.play();
      collisioncount++;
    }
  }

  void finishcheck(Block other) {
    float direction_normalized = (pos - other.pos) / abs(pos - other.pos); //otherが左に居るとき+1
    float veldiff = (vel - other.vel) * direction_normalized;
    if (vel >= 0 && other.vel >= 0 && veldiff >= 0 ) {
      j++;
      if (j > 30) {
        vel = 0;
        other.vel = 0;
        fill(130, 220, 130);
        textSize(80);
      }
    }
  }

  void wallcollision() {
    if (pos < rad && wallorblock == 1) {
      wallorblock = 0;
      vel *= -1;
      file.stop();
      file.play();
      collisioncount++;
    }
  }

  void soundplay() {
    file.stop();
    file.play();
  }

  void update() {
    pos += vel;
  }

  void display() {
    rect(pos, ground - rad, rad, rad);
  }

  void run() {
    this.wallcollision();
    this.update();
    this.display();
  }

  float log100(float x) {
    return log(x) / log(100.0);
  }
}
