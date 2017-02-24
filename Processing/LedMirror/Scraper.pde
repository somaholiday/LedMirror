/* Scrapes the screen and maps pixels to LEDs via PixelPusher */

boolean first_scrape = true;

void scrape() {
  // scrape for the strips
  loadPixels();
  if (testObserver.hasStrips) {
    registry.startPushing();
    List<Strip> strips = registry.getStrips();
    
    // for every strip:
    int stripy = 0;
    for (Strip strip : strips) {
      int strides_per_strip = strip.getLength() / STRIDE;

      int xscale = width / STRIDE;
      int yscale = height / (strides_per_strip * strips.size());

      // for every pixel in the physical strip
      for (int stripx = 0; stripx < strip.getLength(); stripx++) {
        int xpixel = stripx % STRIDE;
        int stride_number = stripx / STRIDE; 
        int xpos, ypos;

        if ((stride_number & 1) != 0) { // we are going right to left
          xpos = xpixel * xscale; 
          ypos = ((stripy*strides_per_strip) + stride_number) * yscale;
        } else { // we are going left to right
          xpos = ((STRIDE - 1)-xpixel) * xscale;
          ypos = ((stripy*strides_per_strip) + stride_number) * yscale;
        }

        color c = get(xpos, ypos);
        //colorMode(RGB);
        //set(xpos, ypos, color(255));
        colorMode(HSB);
        strip.setPixel(c, stripx);
        colorMode(RGB);
      }
      stripy++;
    }
  }
  updatePixels();
}