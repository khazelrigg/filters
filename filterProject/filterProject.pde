boolean PicLoaded = false;
boolean Grayscale = false;
boolean Effect1 = false;
boolean Effect2 = false;
boolean Effect3 = false;
boolean gPressed = false;
boolean e1Pressed = false;
boolean e2Pressed = false;
boolean e3Pressed = false;
int picWidth = 0;
int picHeight = 0;
PImage img, resetImg;

/***********************************/

void setup() 
{
  noLoop();
  size(592, 578);
  PImage bg = loadImage("assets/bg.JPG");
  background(bg); 
  textAlign(LEFT);
  textSize(16);
  fill(0);
  text("Load Picture", 8, 38);
  text("Save Picture", 118, 38);
}

void draw()
{
  fill(0);
  noStroke();
  int picStart = 0;
  int picEnd = 0;


  //The following loads and displays an image file.
  //The image is resized to best fit in a 640x480 frame.
  if (PicLoaded)
  {     
    picWidth = img.width;
    picHeight = img.height;

    if (picWidth > 490)
    {
      picHeight = (int)(picHeight*(490.0/picWidth));
      picWidth = 490;
    }
    if (picHeight > 420)
    {
      picWidth = (int)(picWidth*(420.0/picHeight));
      picHeight = 420;
    }
    img.resize(picWidth, picHeight);
    //  (640-picWidth)/2, (480-picHeight)/2    to CENTER
    picStart = 0;
    picEnd = picStart+img.width*img.height;


    /***** Effects Code *****/
    /* This sample grayscale code may serve as an example */
    if (Grayscale && !gPressed)
    {
      img.loadPixels();
      int i = picStart;
      while (i < picEnd) 
      {
        color c = img.pixels[i];
        float gray = (red(c)+green(c)+blue(c))/3.0;  //average the RGB colors
        img.pixels[i] = color(gray, gray, gray);
        i = i + 1;
      }
      gPressed = true;
    }

    img.updatePixels(); 
    redraw();
  }

  if (img != null) image(img, (640-picWidth)/2, (480-picHeight)/2, picWidth, picHeight);
  fill(255);
  noStroke();
}

void mouseClicked() {
  println(mouseX + " " + mouseY);
  redraw();
}

void mousePressed()
{
  //The following define the clickable bounding boxes for any buttons used.
  //Note that these boundaries should match those drawn in the draw() function.

  if (mouseX>8 && mouseX<105 && mouseY>24 && mouseY<40)
  {
    selectInput("Select a file to process:", "infileSelected");
  }

  if (mouseX>118 && mouseX<217 && mouseY>24 && mouseY<40)
  {
    selectOutput("Select a file to write to:", "outfileSelected");
  }

  if (mouseX>0 && mouseX<0 && mouseY>0 && mouseY<0 && PicLoaded)
  {
    Grayscale = true;
    redraw();
  }   

  if (mouseX>660 && mouseX<790 && mouseY>250 && mouseY<290 && PicLoaded)
  {
    Effect1 = true;
    redraw();
  } 

  if (mouseX>660 && mouseX<790 && mouseY>300 && mouseY<340 && PicLoaded)
  {
    Effect2 = true;
    redraw();
  }  

  if (mouseX>660 && mouseX<790 && mouseY>350 && mouseY<390 && PicLoaded)
  {
    Effect3 = true;
    redraw();
  }

  if (mouseX>693 && mouseX<758 && mouseY>400 && mouseY<440 && PicLoaded)
  {
    resetTheImage();
    redraw();
  }

  checkFilterButtons();
  checkTintButtons();
}

void resetTheImage()
{
  Grayscale = false;
  Effect1 = false;
  Effect2 = false;
  Effect3 = false;
  gPressed = false;
  e1Pressed = false;
  e2Pressed = false;
  e3Pressed = false;
  if (PicLoaded) img = resetImg.get();
}

void infileSelected(File selection) 
{
  if (selection == null) 
  {
    println("IMAGE NOT LOADED: Window was closed or the user hit cancel.");
  } else 
  {
    resetTheImage();    
    println("IMAGE LOADED: User selected " + selection.getAbsolutePath());
    img = loadImage(selection.getAbsolutePath());
    resetImg = loadImage(selection.getAbsolutePath());
    PicLoaded = true;
    redraw();
  }
}

void outfileSelected(File selection) 
{
  if (selection == null) 
  {
    println("IMAGE NOT SAVED: Window was closed or the user hit cancel.");
  } else 
  {
    println("IMAGE SAVED: User selected " + selection.getAbsolutePath());
    img.save(selection.getAbsolutePath());
    redraw();
  }
}

void checkFilterButtons() {
  for (int r = 0; r < 5; r++) {
    for (int c = 0; c < 2; c++) {
      checkFilterButton(8 + (c * 24), 50 + (r * 24));
    }
  }
}

void checkFilterButton(int x, int y) {
  if (mouseX > x && mouseX < x + 24 && mouseY > y && mouseY < y + 24) {
    int col = (x - 8) / 24;
    int row = (y - 50) / 24;
    println("CLICKED BUTTON: " + col + " " + row);
    if (col == 0) {
      switch(row) {
      case 0:
        println("filter 1");
        filterOne();
        break;
      case 1:
        println("filter 2");
        filterTwo();
        break;
      case 2:
        println("filter 3");
        filterThree();
        break;
      case 3:
        println("filter 7");
        filterSeven();
        break;
      case 4:
        println("filter 6");
        filterSix();
        break;
      }
    } else {
      switch(row) {
      case 0:
        println("filter 5");
        filterFive();
        break;
      case 1:
        println("grayscale");
        grayScale();
        break;
      case 2:
        println("filter 4");
        filterFour();
        break;
      case 3:
        println("filter 8");
        filterEight();
        break;
      case 4:
        println("reset");
        resetTheImage();
        break;
      }
    }
  }
}
void checkTintButtons() {
  for (int r = 0; r < 2; r++) {
    for (int c = 0; c < 28; c++) {
      checkTintButton(36 + c * 16, 510 + r * 16);
    }
  }
}

void checkTintButton(int x, int y) {
  if (mouseX > x && mouseX < x + 16 && mouseY > y && mouseY < y + 16) {
    tint(get(x + 5, y + 5));
  }
}


void filterOne() {
  float r, g, b;
  for (int i = 0; i < img.width*img.height/2; i++) 
  { 
    if  (i % img.width < img.width/2) {
      r = red(img.pixels[i]);
      b = blue(img.pixels[i]);
      g = green(img.pixels[i]);
      img.pixels[i] =color(r+(.00001*i), g/i, b);
    } else {
      r = red(img.pixels[i]);
      b = blue(img.pixels[i]);
      g = green(img.pixels[i]);
      img.pixels[i] =color(r, g/i, b+i);
    }
  }
  for (int i = img.width * img.height/2; i < img.width* img.height; i++) { 
    if  (i % img.width < width/2) {
      r = red(img.pixels[i]);
      b = blue(img.pixels[i]);
      g = green(img.pixels[i]);
      img.pixels[i] =color(r/i, g-i, b);
    } else {
      r = red(img.pixels[i]);
      b = blue(img.pixels[i]);
      g = green(img.pixels[i]);
      img.pixels[i] =color(r, b, g);
    }
  }
}

void filterTwo() {
  color[] tempArray = new color[img.pixels.length];
  for (int c = 0; c < img.pixels.length - 1; c++) {
    tempArray[c] = img.pixels[c];
  }

  for (int i = 0; i < img.width * img.height /2; i++) { 
    if  (i % img.width < img.width/2) {
      img.pixels[i] = tempArray[i + img.width*img.height/2];
    } else {
      img.pixels[i] = tempArray[i + img.width * img.height/2];
    }
  }
  for (int i = img.width*img.height/2; i < img.width*img.height; i++) { 
    if  (i % img.width < img.width/2) {
      img.pixels[i] = (tempArray[i - img.width*img.height/2]);
    } else {
      img.pixels[i] = tempArray[i - img.width*img.height/2];
    }
  }
}

void filterThree() {
  int size = 4;
  for (int x = 0; x < img.width - 1; x++) {
    for (int y = 0; y < img.height; y++) {
      int loc = x + (y * img.width);
      if (((x/size)+(y/size)) % 2 == 0) {
        img.pixels[loc] = img.pixels[loc] * 3;
      } else {
        img.pixels[loc] = img.pixels[loc] / 3;
      }
    }
  }
}

void filterFour() {
  for (int i = 0; i < img.pixels.length - 1; i++) {
    float r = red(img.pixels[i]);
    float g = green(img.pixels[i]);
    float b = blue(img.pixels[i]);
    img.pixels[i] = color(g, r, b * 2);
  }
}

void filterFive() {
  for (int i = 0; i < img.pixels.length - 1; i++) {
    img.pixels[i] = img.pixels[i] / 3;
  }
}

void grayScale() {
  for (int i = 0; i < img.pixels.length - 1; i++) {
    color c = img.pixels[i];
    float gray = (red(c)+green(c)+blue(c))/3.0;  //average the RGB colors
    img.pixels[i] = color(gray, gray, gray);
  }
}

void filterSix() {
  PImage flipped = createImage(img.width, img.height, RGB);//create a new image with the same dimensions
  for (int i = 0; i < flipped.pixels.length; i++) {       //loop through each pixel
    int srcX = i % flipped.width;                        //calculate source(original) x position
    int dstX = flipped.width-srcX-1;                     //calculate destination(flipped) x position = (maximum-x-1)
    int y    = i / flipped.width;                        //calculate y coordinate
    flipped.pixels[y*flipped.width+dstX] = img.pixels[i];//write the destination(x flipped) pixel based on the current pixel
  }
  img = flipped;
  image(img, (640-picWidth)/2, (480-picHeight)/2, picWidth, picHeight);
}

void filterSeven() {
  PImage flipped = createImage(img.width, img.height, RGB);//create a new image with the same dimensions
  for (int i = 0; i < flipped.pixels.length; i++) {       //loop through each pixel
    int srcX = i % flipped.height;                        //calculate source(original) x position
    int dstX = flipped.height-srcX-1;                     //calculate destination(flipped) x position = (maximum-x-1)
    int y    = i / flipped.height;                        //calculate y coordinate
    flipped.pixels[y*flipped.height+dstX] = img.pixels[i];//write the destination(x flipped) pixel based on the current pixel
  }
  img = flipped;
  image(img, (640-picWidth)/2, (480-picHeight)/2, picWidth, picHeight);
}

void filterEight() {
  for (int x = 0; x < img.width - 1; x++) {
    for (int y = 0; y < img.height; y++) {
      float diff = abs(brightness(img.pixels[x + y * img.width]) - brightness(img.pixels[(x + 1) + y * img.width]));
      if (diff > 20) {
        img.pixels[x + y * img.width] = color(0);
      } else {
        img.pixels[x + y * img.width] = color(255);
      }
    }
  }
}
