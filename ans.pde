import processing.opengl.*;

float r = 250;
int theta = 1;
int phi = 0;
float radTheta, radPhi;
float rotPow = 1;
Hand h, m, s;

void setup() {
  size(500, 500, OPENGL);
  frameRate(60);
  rectMode(CENTER);
  translate(width/2, height/2, 0);
  h = new Hand(50, 270, 0.1, #000000, 5);
  m = new Hand(70, 270, 1.2, #000000, 4);
  s = new Hand(70, 270, 36, #ff0000, 3);
}

void draw() {
  ambientLight(100, 100, 100);
  directionalLight(255, 255, 255, 0.5, 0.5, -1);
  background(0, 0, 0);

  myCamera();

  // 軸の描画
  // drawAxis();


  // 土台
  fill(#00ffff);
  drawPillar(0, 0, -10, 100, 100, 10, #00ffff, #2222ff);
  // 時計の数字
  fill(#000000);
  int num = 3;
  textAlign(CENTER);
  for(int deg = 0; deg < 360; deg+= 30) {
    text(num, 80*cos(deg2rad(deg))+1, 80*sin(deg2rad(deg))+5, 1);
    num += 1;
    if(num == 13) num = 1;
  }
  // 土台の上の円柱
  fill(#ffffff);
  drawPillar(0, 0, 0, 5, 5, 10, #ffffff, #ffffff);
  // 時計の針の描画
  h.update();
  h.display();
  m.update();
  m.display();
  s.update();
  s.display();
}


// 円柱の底面の中心の x, y, z 上面、下面の半径 高さ 上、側面の色
void drawPillar(int cx, int cy, int bz, int tR, int bR, int h, int tc, int sc) {
  noStroke();
  int x, y, tz = bz + h;
  beginShape(TRIANGLE_FAN);     // 下
  vertex(0, 0, bz);
  for(int deg = 0; deg <= 360; deg+=10) {
    x = int(cos(radians(deg)) * bR);
    y = int(sin(radians(deg)) * bR);
    vertex(x, y, bz);
  }
  endShape();
  fill(tc);                   // 上
  beginShape(TRIANGLE_FAN);
  vertex(0, 0, tz);
  for(int deg = 0; deg <= 360; deg+=10) {
    x = int(cos(radians(deg)) * tR);
    y = int(sin(radians(deg)) * tR);
    vertex(x, y, tz);
  }
  endShape();
  fill(sc);                   // 側面
  beginShape(TRIANGLE_STRIP);
  for(int deg = 0; deg <= 360; deg+=5) {
    x = int(cos(radians(deg)) * bR);
    y = int(sin(radians(deg)) * bR);
    vertex(x, y, bz);
    x = int(cos(radians(deg)) * tR);
    y = int(sin(radians(deg)) * tR);
    vertex(x, y, tz);
  }
  endShape();
}

float deg2rad(float deg) {
  return deg*PI/180;
}

void mouseDragged() {
  if(mouseButton == LEFT) {
    theta -= (mouseY - pmouseY);
    if(theta < 1) theta = 1;
    if(179 < theta) theta = 179;
    phi = (phi - mouseX + pmouseX) % 360;
  } else if(mouseButton == RIGHT) {
    r -= (mouseY - pmouseY);
  }
}

// マウススクロール
void mouseWheel(MouseEvent e) {
  if(e.getAmount() < 0) {
    rotPow += 0.5;
  } else {
    rotPow -= 0.5;
  }
  if(rotPow < 0) rotPow = 0;
}

// x y z 軸の描画
void drawAxis() {
  textSize(20);
  stroke(#ff0000);
  strokeWeight(2);
  fill(#ff0000);
  line(0, 0, 0, 200, 0, 0);
  text("X", 200, 0, 0);

  stroke(#00ff00);
  fill(#00ff00);
  line(0, 0, 0, 0, 200, 0);
  text("Y", 0, 200, 0);

  stroke(#0000ff);
  fill(#0000ff);
  line(0, 0, 0, 0, 0, 200);
  text("Z", 0, 0, 200);
}

void myCamera() {
  radTheta = deg2rad(theta);
  radPhi = deg2rad(phi);
  camera(int(r * sin(radTheta) * sin(radPhi)),
         int(r * sin(radTheta) * cos(radPhi)),
         int(r * cos(radTheta)),
         0, 0, 0,
         0, 0, -1);
}

class Hand {
  int length, weight;
  float phi, speed, c;

  Hand(int _length, float _phi, float _speed, float _c, int _weight) {
    length = _length;
    phi = _phi;
    speed = _speed;
    c = _c;
    weight = _weight;
  }

  void update() {
    phi += (speed * rotPow);
  }

  void display() {
    stroke(c);
    strokeWeight(weight);
    line(0, 0, 5, length*cos(deg2rad(phi)), length*sin(deg2rad(phi)), 5);
  }
}
