/*
  The master sketch for initializing video camera, LEDs, and loading
 apprentices' scenes.
 */

import com.heroicrobot.dropbit.registry.*;
import com.heroicrobot.dropbit.devices.pixelpusher.Pixel;
import com.heroicrobot.dropbit.devices.pixelpusher.Strip;

import processing.core.*;
import java.util.*;

//import gohai.glvideo.*;
import processing.video.*;

// number of LEDs per strip segment
int STRIDE = 44;

// SCENE STATE
Scene[] scenes;
int currentSceneIndex;
Scene currentScene;

// VIDEO
//GLCapture video;
Capture video;

// PIXELPUSHER
DeviceRegistry registry;
TestObserver testObserver;

void setup() {
  size(480, 480, P2D);

  initPixelPusher();
  initVideo();

  // initialize scenes
  scenes = new Scene[] {
    new Scene_Olin()
  };

  currentSceneIndex = 0;
  currentScene = scenes[currentSceneIndex];

  frameRate(60);
}

void initPixelPusher() {
  registry = new DeviceRegistry();
  testObserver = new TestObserver();
  registry.addObserver(testObserver);
  registry.setAntiLog(true);
  registry.setAutoThrottle(true);
}

void initGLVideo() {
  //String[] devices = GLCapture.list();
  //println("Devices:");
  //printArray(devices);
  //if (0 < devices.length) {
  //  String[] configs = GLCapture.configs(devices[0]);
  //  println("Configs:");
  //  printArray(configs);
  //}

  //// this will use the first recognized camera by default
  //video = new GLCapture(this);

  //// you could be more specific also, e.g.
  ////video = new GLCapture(this, devices[0]);
  ////video = new GLCapture(this, devices[0], 640, 480, 25);
  ////video = new GLCapture(this, devices[0], configs[0]);

  //video.play();
}

void initStandardVideo() {
  video = new Capture(this, width, height);
  video.start();
}

void initVideo() {
  initStandardVideo();
  //initGLVideo();
} 

void draw() {
  background(0);

  //if (video.available()) {
  //  video.read();
  //}

  //flippedVideo();

  //image(video, 0, 0);

  currentScene._draw();

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