/*

  Gray Area CCA 2016 - NOW Hunters Point
  
  Elise Xu

 */


// Work with processing video library
import processing.video.*;

// Variable for LED connection
OPC opc;
// Variable for camera
Capture video;
// Previous frame
PImage prevFrame;

// The balls that show up
ArrayList<Ball> balls;
PImage dot;

// Different thresholds for speed
int slow = 7;
int slight = 15;
int medium = 30;
int fast = 45;

void setup() {
  size(400, 360);
  
  // Connect to the LEDs
  initLEDs();
  // Use the camera
  video = new Capture(this, width, height);
  video.start();
  
  // Initialize the previous frame as an empty image
  prevFrame = createImage(video.width, video.height, RGB);
  
  // Display an initial ball
  balls = new ArrayList();
  balls.add(new Ball());
  // Each ball is an image of a dot
  dot = loadImage("dot.png");
  imageMode(CENTER);
}

// Connect to the FadeCandy Server for the LEDs
void initLEDs() {
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

// Capture frames from the video
void captureEvent(Capture video) {
  // Update prevFrame
  prevFrame.copy(video, 0, 0, video.width, video.height, 0, 0, video.width, video.height);
  prevFrame.updatePixels();
  video.read();
}


void draw() {
  
  // Make the background black; the camera is still analyzing the video
  background(0);
  
  // Load the pixels from the current video and the previous frame to
  // analyze the motion difference.
  video.loadPixels();
  prevFrame.loadPixels();

  // Start with a total of 0
  float totalMotion = 0;
  float avgMotion = 0;

  // Loop through each pixel
  for (int i = 0; i < video.pixels.length; i ++) {
    // Find the current color
    color current = video.pixels[i];
    // Find the previous color
    color previous = prevFrame.pixels[i];
    // Compare current and previous colors
    float r1 = red(current); 
    float g1 = green(current);
    float b1 = blue(current);
    float r2 = red(previous); 
    float g2 = green(previous);
    float b2 = blue(previous);
    // Calculate difference with the distance between the values
    float diff = dist(r1, g1, b1, r2, g2, b2);
    // Calculate the totalMotion by summing all color differences. 
    totalMotion += diff;
  }
  
  // Calculate avgMotion by dividing the total by the number of pixels.
  avgMotion = totalMotion / video.pixels.length; 

  // If motion is slow, make all the balls except the 3 most 
  // recent ones fade
  if (avgMotion < slow) {
   //println("you aren't moving.");
   for (int i = 0; i < balls.size() - 3; i++) {
    balls.get(i).fade();
    if (balls.get(i).fade < 10) {
      balls.remove(i);
    }
  }
  }
  // If motion is between slight and medium, add 1 ball
  else if (avgMotion > slight && avgMotion <= medium) {
   balls.add(new Ball());
  }
  // If motion is bigger than medium, add 2 balls
  else if (avgMotion > medium) {
    balls.add(new Ball());
    balls.add(new Ball());
  }
  // If motion is bigger than fast, add 3 balls
  else if (avgMotion > fast) {
    balls.add(new Ball());
    balls.add(new Ball());
    balls.add(new Ball());
  }
  
  // Display each ball and make it move
  for (int i = balls.size()-1; i >= 0; i--) { 
    Ball ball = (Ball) balls.get(i);
    ball.display();
    ball.move();
  }
  
  // If the number of balls onscreen is greater than 15, remove 1
  if (balls.size() > 15) {
    for (int i = 0; i < 1; i++) {
      balls.get(i).fade();
      balls.remove(i);
    }
  }

}