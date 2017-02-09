class Ball {
  // Attributes of each ball
  float fade;
  color c;
  float xpos;
  float ypos;
  float xspeed;
  float yspeed;
  float mysize;
  PImage dot = loadImage("dot.png");

  // Randomize each ball's attributes
    Ball () {
    fade = 255.0;
    c = color(random(50,255), random(50,255), random(50,255), fade);
    xpos = random(0, width);
    ypos = random(0, height);
    xspeed = random(-3, 4);
    yspeed = random(-3, 4);
    mysize = random(150, 200);
    
  }

  // Move the ball
  void move() {

    if (xpos > width || xpos < 0) {
      xspeed = xspeed * (-1);      
    }
    if (ypos > height || ypos < 0) {
      yspeed = yspeed * (-1);
    }
    xpos = xpos + xspeed;
    ypos = ypos + yspeed;
  }

  // Display the ball
  void display() {
    tint(c);
    image(dot, xpos, ypos, mysize, mysize);
  }
  
  // Fade the ball by decrementing its transparency
  void fade() {
    if (this.fade > 0.0) {
      this.fade = this.fade - 0.7;
    }
    c = color(red(c), green(c), blue(c), this.fade);
  }
  
}