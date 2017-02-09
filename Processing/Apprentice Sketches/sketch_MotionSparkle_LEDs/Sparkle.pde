class Sparkle {

  float x, y;
  float r;
  color c;
  int flashrate = (int)random(250, 500);
  float q, r_;

  // for circles around a point
  // the point is at (x2, y2)
  // the sparkle should be within a distance r2 from the center point
  Sparkle(float x2, float y2, float r2) {
    q = random(-1, 1) * (TWO_PI);
    r_ = sqrt(random(1));
    x = (r2 * r_) * cos(q) + x2;
    y = (r2 * r_) * sin(q) + y2;
    r = random(20, 40);
    // brightness is low bc the LEDs r rly bright!!
    c = color(random(255), 100, 50);
  }

  void display() {
    noStroke();
    // blink
    if (!(millis()%(2*flashrate)<flashrate)) {
      fill(c);
      // idk how to make the ellipses look better
      ellipse(x, y, 2*r, 2*r);
    }
  }
  
  void update(float x2, float y2, float r2) {
    x = (r2 * r_) * cos(q) + x2;
    y = (r2 * r_) * sin(q) + y2;
  }
}