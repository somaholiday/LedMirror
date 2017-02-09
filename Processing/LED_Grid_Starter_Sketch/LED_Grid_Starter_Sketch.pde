/*

 LED Mirror Starter Code
 
 This sketch will use a webcam to create a mirror effect.
 Whatever the webcam sees will be printed to the canvas, and then
 mapped to our LED output device.
 
 NOTE!  Make sure you are running the Fadecandy server process before
 running this sketch--that process is what allows Processing to talk to
 the LEDs.
 
 */

import processing.video.*;

// LEDs
OPC opc;

// Variable for capture device (webcam)
Capture video;

void setup() {
  size(640, 360, P2D);

  // Initialize the LED connection and positions
  initLEDs();

  // This the default video input, see the GettingStartedCapture 
  // example if it creates an error
  video = new Capture(this, width, height);

  // Start capturing the images from the camera
  video.start();
}

void initLEDs() {
  // connect to the running fcserver process on your computer
  opc = new OPC(this, "127.0.0.1", 7890);

  opc.setStatusLed(false);
  opc.showLocations(true);
  //opc.setColorCorrection(2.5 * 1/ .6, 0.98, 1.0, 1.0);

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

void draw() {
  background(0);

  if (video.available()) {
    video.read();

    // ========
    // Do your image manipulation work here!


    // ========
  }
  pushMatrix();
  // Reverse the image (so it feels like a real mirror)
  scale(-1, 1);

  // The x position is -width instead of 0 because we flipped over the x-axis
  image(video, -video.width, 0);
  popMatrix();
}