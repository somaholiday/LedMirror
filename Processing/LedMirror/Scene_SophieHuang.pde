/*

 Gray Area CCA 2016 - NOW Hunters Point
 
 Sophie Huang
 
 */

class Scene_SophieHuang extends Scene {

  PImage prevFrame;
  float threshold = 50;

  ArrayList<Sparkle> sparkles;
  int sparkleLimit = 50;

  public Scene_SophieHuang() {
    super();
  }

  void _setup() {
    sparkles = new ArrayList<Sparkle>();
    prevFrame = createImage(video.width, video.height, RGB);
  }

  void _draw() {
    background(0);

    if (video.available()) {
      video.read();
      prevFrame.copy(video, 0, 0, video.width, video.height, 0, 0, video.width, video.height);
      prevFrame.updatePixels();  
      video.read();

      loadPixels();
      video.loadPixels();
      prevFrame.loadPixels();

      float sumX = 0;
      float sumY = 0;
      int motionCount = 0;

      for (int x = 0; x < video.width; x++ ) {
        for (int y = 0; y < video.height; y++ ) {

          color current = video.pixels[x+y*video.width];
          color previous = prevFrame.pixels[x+y*video.width];

          float r1 = red(current); 
          float g1 = green(current);
          float b1 = blue(current);
          float r2 = red(previous); 
          float g2 = green(previous);
          float b2 = blue(previous);

          float diff = dist(r1, g1, b1, r2, g2, b2);

          if (diff > threshold) {
            sumX += x;
            sumY += y;
            motionCount++;
          }
        }
      }

      float avgX = sumX / motionCount; 
      float avgY = sumY / motionCount; 

      sparkles.add(new Sparkle(avgX - width, avgY, 50));
      if (sparkles.size() > sparkleLimit) {
        sparkles.remove(0);
      }
      pushMatrix();
      scale(-1, 1);
      for (Sparkle s : sparkles) {
        s.display();
      }
      popMatrix();
    }
  }
}


/* * * *
 * * * *
 SPARKLE
 * * * *
 * * * */

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
    c = color(random(255), 100, 255);
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