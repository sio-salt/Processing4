class Ball {
  PVector Pos;
  PVector Vel;
  //PVector acc;
  
  float rad, mass;
  
  
  Ball(float x, float y, float r) {
    Pos = new PVector(x, y);
    Vel = PVector.random2D().mult(5.0);
    rad = r;
    mass = 5 * rad;
  }


  void update() {
    Pos.add(Vel);
  }
  
  void checkBoundary() {
    if (Pos.x > width-rad) {
      Pos.x = width-rad;
      Vel.x *= -1;
      file.play();
    } else if(Pos.y > height-rad) {
      Pos.y = height-rad;
      Vel.y *= -1;
      file.play();
    } else if(Pos.x < rad) {
      Pos.x = rad;
      Vel.x *= -1;
      file.play();
    } else if(Pos.y < rad) {
      Pos.y = rad;
      Vel.y *= -1;
      file.play();
    }
  }

  
  void checkCollision(Ball other) {
    //This checkCollision concept is simple.
    //When you want to check whether ball[1] and ball[2(other)] is colliding or not, use this method like "ball[1].checkCollision(ball[2])"
    //And if you checked whether ball[1] and ball[2] (other) is colliding or not, there is no need to check ball[2] and ball[1].
    //First, this method creates new coordinate system which origin is ball[1] and x axis is head to ball[2].
    //Second, update velocity based on law of conservation of mechanical energy and conservation of momentum.
    //Finally, set back to normal coordinate system.
    
    //めり込み補正、if()チェック用ベクトルと定数
    PVector ToOther = PVector.sub(other.Pos, Pos);
    float distance = ToOther.mag();
    float minDistance = rad + other.rad;

    if (minDistance > distance) {
      //めり込み補正
      float merikomicorrection = (minDistance - distance) / 2.0;
      PVector correctionVector = ToOther.normalize().mult(merikomicorrection);
      Pos.sub(correctionVector);
      other.Pos.add(correctionVector);
      //
      //これからの計算で使う傾きとsine、cosine
      float angle = ToOther.heading();
      // float sine = sin(angle);
      // float cosine = cos(angle);
      
      //計算用の位置と速度のtemporaryベクトル,自分とother用に2つ定義。
      PVector[] pTemp = {
        new PVector(), new PVector()
      };
      PVector[] vTemp = {
        new PVector(), new PVector()
      };
      
      //傾ける。新座標の原点はpTemp[0],ここでの演算は2次元回転行列
      pTemp[1] = other.Pos.copy().rotate(-angle);
      vTemp[0] = Vel.copy().rotate(-angle);
      vTemp[1] = other.Vel.copy().rotate(-angle);

      
      //運動量保存則と力学的エネルギー保存則を考慮,二乗が面倒なので弾性衝突の式と運動量保存則の2つから解いた。yは変わらない。
      PVector[] vFinal = {
        new PVector(), new PVector()
      };
      vFinal[0].x = ((mass - other.mass) * vTemp[0].x + 2 * other.mass * vTemp[1].x) / (mass + other.mass);
      vFinal[0].y = vTemp[0].y;
      vFinal[1].x = (2 * mass * vTemp[0].x + (other.mass - mass) * vTemp[1].x) / (mass + other.mass);
      vFinal[1].y = vTemp[1].y;

      //hack to avoid clumping
      pTemp[0].x += vFinal[0].x;
      pTemp[1].x += vFinal[1].x;

      //速度の座標を元に戻す。位置はいじってないので変わらない。
      Vel = vFinal[0].rotate(angle);
      other.Vel = vFinal[1].rotate(angle);
     
     file.play();
     
    }
  }
  
  void display() {
    noStroke();
    fill(250);
    ellipse(Pos.x, Pos.y, rad*2, rad*2);
  }

  // void run(ball) {
  //   ball.checkBoundaryCollision();
  //   ball.update();
  //   ball.display();
  // }
}
