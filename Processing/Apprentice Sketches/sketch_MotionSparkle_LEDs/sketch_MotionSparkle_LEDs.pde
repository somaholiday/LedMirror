/*

  Gray Area CCA 2016 - NOW Hunters Point
  
  Sophie Huang

 */


// adapted from Learning Processing exercise 16-07

import processing.video.*;

OPC opc;

Capture video;
PImage prevFrame;
float threshold = 50;

ArrayList<Sparkle> sparkles;
int sparkleLimit = 50;

void setup() {
  size(640, 360, P2D);

  initLEDs();

  colorMode(HSB);
  background(0);

  sparkles = new ArrayList<Sparkle>();

  video = new Capture(this, 640, 480);
  video.start();

  prevFrame = createImage(video.width, video.height, RGB);
}

void initLEDs() {
  opc = new OPC(this, "127.0.0.1", 7890);

  opc.setStatusLed(false);
  opc.showLocations(true);

  float spacing = height / 16.0;
  float offset = spacing * 4;
  float mid_x = width / 2.0;
  float mid_y = height / 2.0;

  opc.ledGrid8x8(64 * 0, mid_x - offset, height/4, spacing, 0, false);
  opc.ledGrid8x8(64 * 1, mid_x + offset, height/4, spacing, 0, false);
  opc.ledGrid8x8(64 * 2, mid_x - offset, 3 * height/4, spacing, 0, false);
  opc.ledGrid8x8(64 * 3, mid_x + offset, 3 * height/4, spacing, 0, false);
}

void draw() {
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