/*
  A harness for testing the layout of the PixelPusher LEDs.
 */

import com.heroicrobot.dropbit.registry.*;
import com.heroicrobot.dropbit.devices.pixelpusher.Pixel;
import com.heroicrobot.dropbit.devices.pixelpusher.Strip;

import processing.core.*;
import java.util.*;

DeviceRegistry registry;
TestObserver testObserver;

// number of LEDs per strip segment
int STRIDE = 44;

PImage dot;
float dotSize = 250;

void setup() {
  size(480, 480);
  registry = new DeviceRegistry();
  testObserver = new TestObserver();
  registry.addObserver(testObserver);
  registry.setAntiLog(true);
  registry.setAutoThrottle(true);
  frameRate(60);

  colorMode(HSB);
  dot = loadImage("dot.png");
}

void draw() {
  background(0);

  tint(frameCount % 255, 255, 255);
  image(dot, mouseX - dotSize*.5, mouseY - dotSize*.5, dotSize, dotSize);
  
  scrape();
}