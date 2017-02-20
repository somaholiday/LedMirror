/*
  A harness for testing the layout of the PixelPusher LEDs.
 */

import com.heroicrobot.dropbit.registry.*;
import com.heroicrobot.dropbit.devices.pixelpusher.Pixel;
import com.heroicrobot.dropbit.devices.pixelpusher.Strip;

import processing.core.*;
import java.util.*;
import gohai.glvideo.*;

GLCapture video;

DeviceRegistry registry;
TestObserver testObserver;

// number of LEDs per strip segment
int STRIDE = 44;

void setup() {
  size(480, 480, P2D);
  registry = new DeviceRegistry();
  testObserver = new TestObserver();
  registry.addObserver(testObserver);
  registry.setAntiLog(true);
  registry.setAutoThrottle(true);
  frameRate(60);

  String[] devices = GLCapture.list();
  println("Devices:");
  printArray(devices);
  if (0 < devices.length) {
    String[] configs = GLCapture.configs(devices[0]);
    println("Configs:");
    printArray(configs);
  }

  // this will use the first recognized camera by default
  video = new GLCapture(this);

  // you could be more specific also, e.g.
  //video = new GLCapture(this, devices[0]);
  //video = new GLCapture(this, devices[0], 640, 480, 25);
  //video = new GLCapture(this, devices[0], configs[0]);

  video.play();
}

void draw() {
  background(0);

  if (video.available()) {
    video.read();
  }
  
  //flippedVideo();

  image(video, 0, 0);
  
  scrape();
}

void flippedVideo() {
  pushMatrix();
  // Reverse the image (so it feels like a real mirror)
  scale(-1, 1);

  // The x position is -width instead of 0 because we flipped over the x-axis
  image(video, -video.width, 0);
  popMatrix();
}