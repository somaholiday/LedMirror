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
static final int STRIDE = 44;

// SCENE STATE
SceneManager sceneManager;

// VIDEO
//GLCapture video;
Capture video;

// PIXELPUSHER
DeviceRegistry registry;
TestObserver testObserver;

void setup() {
  size(320, 240, P2D);

  initPixelPusher();
  initVideo();

  // initialize scenes
  sceneManager = new SceneManager(new Scene[] {
    new Scene_OlinKahney(), 
    new Scene_EliseXu(), 
    new Scene_SophieHuang()
    });

  frameRate(60);
}

/* Initializes PixelPusher Registry and Observer */
void initPixelPusher() {
  registry = new DeviceRegistry();
  testObserver = new TestObserver();
  registry.addObserver(testObserver);
  registry.setAntiLog(true);
  registry.setAutoThrottle(true);
}

/* Uses gohai's GL Video library */
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

/* Uses the built-in Processing video library */
void initStandardVideo() {
  video = new Capture(this, width, height, 30);
  video.start();
}

void initVideo() {
  initStandardVideo();
  //initGLVideo();
} 

void draw() {
  background(0);

  sceneManager.update();

  scrape();

  //if (frameCount % 300 == 0) {
  //  changeScene(); 
  //}
}

void keyPressed() {
  sceneManager.nextScene();
}

void fadeRect(float opacity) {
  pushStyle();
  fill(0, opacity);
  rect(-1, -1, width+1, height+1);
  popStyle();
}