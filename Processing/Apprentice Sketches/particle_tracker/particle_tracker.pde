/*

  Gray Area CCA 2016 - NOW Hunters Point
  
  Olin Kahney

 */


/**
 * Simple Particle System
 * by Daniel Shiffman.  
 * 
 * Particles are generated each cycle through draw(),
 * fall with gravity and fade out over time
 * A ParticleSystem object manages a variable size (ArrayList) 
 * list of particles. 
 */
import processing.video.*;

// Variable for capture device
Capture video;
// Previous Frame
PImage prevFrame;

ArrayList <Mover> bouncers;
int bewegungsModus = 3;

// LEDs
OPC opc;

// How different must a pixel be to be a "motion" pixel
float threshold = 50;


void setup() {
  size(640, 360);

  video = new Capture(this, width, height);
  video.start();

  // Initialize the LED connection and positions
  initLEDs();

  //blendMode(ADD);


  bouncers = new ArrayList();

  for (int i = 0; i < 50; i++)
  {
    Mover m = new Mover();
    bouncers.add (m);
  }

  // Create an empty image the same size as the video
  prevFrame = createImage(video.width, video.height, RGB);
}

void initLEDs() {
  // connect to the running fcserver process on your computer
  opc = new OPC(this, "127.0.0.1", 7890);

  opc.setStatusLed(false);
  opc.showLocations(true);

  // Register the LED positions on the screen
  float spacing = height / 16.0;
  float offset = spacing * 4;
  float mid_x = width / 2.0;
  float mid_y = height / 2.0;

  opc.ledGrid8x8(64 * 0, mid_x - offset, height/4, spacing, 0, false);
  opc.ledGrid8x8(64 * 1, mid_x + offset, height/4, spacing, 0, false);
  opc.ledGrid8x8(64 * 2, mid_x - offset, 3 * height/4, spacing, 0, false);
  opc.ledGrid8x8(64 * 3, mid_x + offset, 3 * height/4, spacing, 0, false);
}

void captureEvent(Capture video) {
  // Save previous frame for motion detection!!
  prevFrame.copy(video, 0, 0, video.width, video.height, 0, 0, video.width, video.height);
  prevFrame.updatePixels();  
  video.read();
}

PVector particlePosition;

void draw() {
  background(0);
  pushMatrix();
  // Reverse the image (so it feels like a real mirror)
  scale(-1, 1);
  //image(video, 0, 0);
  // The x position is -width instead of 0 because we flipped over the x-axis
  //image(video, -video.width, 0);

  particlePosition = getAverageMotion();
  particlePosition.x = particlePosition.x - width;
 

  int i = 0;
  while (i < bouncers.size () )
  {
    Mover m = bouncers.get(i);
    if (bewegungsModus != 5) {
      m.update (bewegungsModus, particlePosition );
    } else
    {
      m.flock (bouncers);
      m.move();
      m.checkEdges();
      m.display();
    }

    i = i + 1;
  }

  popMatrix();
}

PVector getAverageMotion() {
  loadPixels();
  video.loadPixels();
  prevFrame.loadPixels();

  // These are the variables we'll need to find the average X and Y
  float sumX = 0;
  float sumY = 0;
  int motionCount = 0; 

  // Begin loop to walk through every pixel
  for (int x = 0; x < video.width; x++ ) {
    for (int y = 0; y < video.height; y++ ) {
      // What is the current color
      color current = video.pixels[x+y*video.width];

      // What is the previous color
      color previous = prevFrame.pixels[x+y*video.width];

      // Step 4, compare colors (previous vs. current)
      float r1 = red(current); 
      float g1 = green(current);
      float b1 = blue(current);
      float r2 = red(previous); 
      float g2 = green(previous);
      float b2 = blue(previous);

      // Motion for an individual pixel is the difference between the previous color and current color.
      float diff = dist(r1, g1, b1, r2, g2, b2);

      // If it's a motion pixel add up the x's and the y's
      if (diff > threshold) {
        sumX += x;
        sumY += y;
        motionCount++;
      }
    }
  }

  // average location is total location divided by the number of motion pixels.
  if (motionCount == 0) {
    return new PVector(width/2, height/2);
  } else {
    float avgX = sumX / motionCount; 
    float avgY = sumY / motionCount; 
    return  new PVector(avgX, avgY);
  }
}