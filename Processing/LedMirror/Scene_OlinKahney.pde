/*

  Gray Area CCA 2016 - NOW Hunters Point
  
  Olin Kahney

 */

class Scene_OlinKahney extends Scene {

  // Previous Frame
  PImage prevFrame;

  // How different must a pixel be to be a "motion" pixel
  float threshold = 50;

  ArrayList <Mover> bouncers;
  int bewegungsModus = 3;

  PVector particlePosition;

  public Scene_OlinKahney() {
    super();
  }

  void _setup() {
    bouncers = new ArrayList();

    for (int i = 0; i < 50; i++)
    {
      Mover m = new Mover();
      bouncers.add (m);
    }

    // Create an empty image the same size as the video
    prevFrame = createImage(video.width, video.height, RGB);
  }

  void _draw() {
    if (video.available()) {
      // Save previous frame for motion detection!!
      prevFrame.copy(video, 0, 0, video.width, video.height, 0, 0, video.width, video.height);
      prevFrame.updatePixels();  
      video.read();
    }

    background(0);
    pushMatrix();
    // Reverse the image (so it feels like a real mirror)
    scale(-1, 1);
    //image(video, 0, 0);
    // The x position is -width instead of 0 because we flipped over the x-axis
    image(video, -video.width, 0);

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
}


/* * * *
 * * * *
 MOVER
 * * * *
 * * * */

class Mover
{
  PVector direction;
  PVector location;

  float speed;
  float SPEED;

  float noiseScale;
  float noiseStrength;
  float forceStrength;

  float ellipseSize;

  color c;


  Mover () // Konstruktor = setup der Mover Klasse
  {
    setRandomValues();
  }

  Mover (float x, float y) // Konstruktor = setup der Mover Klasse
  {
    setRandomValues ();
  }

  // SET ---------------------------

  void setRandomValues ()
  {
    location = new PVector (random (width), random (height));
    ellipseSize = random (30, 70);

    float angle = random (TWO_PI);
    direction = new PVector (cos (angle), sin (angle));

    speed = random (4, 8);
    SPEED = speed;
    noiseScale = 80;
    noiseStrength = 1;
    forceStrength = random (0.1, 0.2);

    setRandomColor();
  }

  void setRandomColor ()
  {
    int colorDice = (int) random (7);


    if (colorDice == 0) c = #FF0000;
    else if (colorDice == 1) c = #FF8700;
    else if (colorDice == 2) c = #F7FF00;
    else if (colorDice == 3) c = #0FFF00;
    else if (colorDice == 4) c = #0013FF;
    else if (colorDice == 5) c = #8F00FF;
    else c = #FF00F3;
  }

  // GENEREL ------------------------------

  void update ()
  {
    update (3, new PVector(mouseX, mouseY));
  }

  void update (int mode, PVector pos)
  {
    if (mode == 0) // bouncing ball
    {
      speed = SPEED * 0.7;
      move();
      checkEdgesAndBounce();
    } else if (mode == 1) // noise
    {
      speed = SPEED * 0.7;
      addNoise ();
      move();
      checkEdgesAndRelocate ();
    } else if (mode == 2) // steer
    {
      steer (mouseX, mouseY);
      move();
    } else if (mode == 3) // seek
    {
      speed = SPEED * 0.7;
      seek (pos.x, pos.y);
      move();
    } else // radial
    {
      speed = SPEED * 0.7;
      addRadial ();
      move();
      checkEdges();
    }

    display();
  }

  // FLOCK ------------------------------

  void flock (ArrayList <Mover> boids)
  {

    PVector other;
    float otherSize ;

    PVector cohesionSum = new PVector (0, 0);
    float cohesionCount = 0;

    PVector seperationSum = new PVector (0, 0);
    float seperationCount = 0;

    PVector alignSum = new PVector (0, 0);
    float speedSum = 0;
    float alignCount = 0;

    for (int i = 0; i < boids.size(); i++)
    {
      other = boids.get(i).location;
      otherSize = boids.get(i).ellipseSize;

      float distance = PVector.dist (other, location);


      if (distance > 0 && distance <70) //align + cohesion
      {
        cohesionSum.add (other);
        cohesionCount++;

        alignSum.add (boids.get(i).direction);
        speedSum += boids.get(i).speed;
        alignCount++;
      }

      if (distance > 0 && distance < (ellipseSize+otherSize)*1.2) // seperate bei collision
      {
        float angle = atan2 (location.y-other.y, location.x-other.x);

        seperationSum.add (cos (angle), sin (angle), 0);
        seperationCount++;
      }

      if (alignCount > 8 && seperationCount > 12) break;
    }

    // cohesion: bewege dich in die Mitte deiner Nachbarn
    // seperation: renne nicht in andere hinein
    // align: bewege dich in die Richtung deiner Nachbarn

    if (cohesionCount > 0)
    {
      cohesionSum.div (cohesionCount);
      cohesion (cohesionSum, 1);
    }

    if (alignCount > 0)
    {
      speedSum /= alignCount;
      alignSum.div (alignCount);
      align (alignSum, speedSum, 1.3);
    }

    if (seperationCount > 0)
    {
      seperationSum.div (seperationCount);
      seperation (seperationSum, 2);
    }
  }

  void cohesion (PVector force, float strength)
  {
    steer (force.x, force.y, strength);
  }

  void seperation (PVector force, float strength)
  {
    force.limit (strength*forceStrength);

    direction.add (force);
    direction.normalize();

    speed *= 1.1;
    speed = constrain (speed, 0, SPEED * 1.5);
  }

  void align (PVector force, float forceSpeed, float strength)
  {
    speed = lerp (speed, forceSpeed, strength*forceStrength);

    force.normalize();
    force.mult (strength*forceStrength);

    direction.add (force);
    direction.normalize();
  }

  // HOW TO MOVE ----------------------------

  void steer (float x, float y)
  {
    steer (x, y, 1);
  }

  void steer (float x, float y, float strength)
  {

    float angle = atan2 (y-location.y, x -location.x);

    PVector force = new PVector (cos (angle), sin (angle));
    force.mult (forceStrength * strength);

    direction.add (force);
    direction.normalize();

    float currentDistance = dist (x, y, location.x, location.y);

    if (currentDistance < 70)
    {
      speed = map (currentDistance, 0, 70, 0, SPEED);
    } else speed = SPEED;
  }

  void seek (float x, float y)
  {
    seek (x, y, 1);
  }

  void seek (float x, float y, float strength)
  {

    float angle = atan2 (y-location.y, x -location.x);

    PVector force = new PVector (cos (angle), sin (angle));
    force.mult (forceStrength * strength);

    direction.add (force);
    direction.normalize();
  }

  void addRadial ()
  {

    float m = noise (frameCount / (2*noiseScale));
    m = map (m, 0, 1, - 1.2, 1.2);

    float maxDistance = m * dist (0, 0, width/2, height/2);
    float distance = dist (location.x, location.y, width/2, height/2);

    float angle = map (distance, 0, maxDistance, 0, TWO_PI);

    PVector force = new PVector (cos (angle), sin (angle));
    force.mult (forceStrength);

    direction.add (force);
    direction.normalize();
  }

  void addNoise ()
  {

    float noiseValue = noise (location.x /noiseScale, location.y / noiseScale, frameCount / noiseScale);
    noiseValue*= TWO_PI * noiseStrength;

    PVector force = new PVector (cos (noiseValue), sin (noiseValue));
    //Processing 2.0:
    //PVector force = PVector.fromAngle (noiseValue);
    force.mult (forceStrength);
    direction.add (force);
    direction.normalize();
  }

  // MOVE -----------------------------------------

  void move ()
  {

    PVector velocity = direction.get();
    velocity.mult (speed);
    location.add (velocity);
  }

  // CHECK --------------------------------------------------------

  void checkEdgesAndRelocate ()
  {
    float diameter = ellipseSize;

    if (location.x < -diameter/2)
    {
      location.x = random (-diameter/2, width+diameter/2);
      location.y = random (-diameter/2, height+diameter/2);
    } else if (location.x > width+diameter/2)
    {
      location.x = random (-diameter/2, width+diameter/2);
      location.y = random (-diameter/2, height+diameter/2);
    }

    if (location.y < -diameter/2)
    {
      location.x = random (-diameter/2, width+diameter/2);
      location.y = random (-diameter/2, height+diameter/2);
    } else if (location.y > height + diameter/2)
    {
      location.x = random (-diameter/2, width+diameter/2);
      location.y = random (-diameter/2, height+diameter/2);
    }
  }


  void checkEdges ()
  {
    float diameter = ellipseSize;

    if (location.x < -diameter / 2)
    {
      location.x = width+diameter /2;
    } else if (location.x > width+diameter /2)
    {
      location.x = -diameter /2;
    }

    if (location.y < -diameter /2)
    {
      location.y = height+diameter /2;
    } else if (location.y > height+diameter /2)
    {
      location.y = -diameter /2;
    }
  }

  void checkEdgesAndBounce ()
  {
    float radius = ellipseSize / 2;

    if (location.x < radius )
    {
      location.x = radius ;
      direction.x = direction.x * -1;
    } else if (location.x > width-radius )
    {
      location.x = width-radius ;
      direction.x *= -1;
    }

    if (location.y < radius )
    {
      location.y = radius ;
      direction.y *= -1;
    } else if (location.y > height-radius )
    {
      location.y = height-radius ;
      direction.y *= -1;
    }
  }

  // DISPLAY ---------------------------------------------------------------

  void display ()
  {
    noStroke();
    fill (c, 200);
    ellipse (location.x, location.y, ellipseSize, ellipseSize);
  }
}