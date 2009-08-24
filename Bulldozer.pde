class Bulldozer extends Building{
  PImage imageBulldozer;

  float x = width - 110;
  float y = height-110;
  int bulldozerSize;

  boolean dragged = false;

  Bulldozer(){
    imageBulldozer = loadImage("Bulldozer.png");
    bulldozerSize = 100;
  }

  boolean over(){  // test for mouse over
    if (mouseX >= x && mouseX <= x+bulldozerSize && 
      mouseY >= y && mouseY <= y+bulldozerSize) {
      return true;
    } 
    else {
      return false;
    }
  }

  void release(){
    x = width - 110;
    y = height-110;
    dragged = false;
  }

  void display(){
    if (dragged)  {
      x = mouseX;
      y = mouseY-bulldozerSize*0.8;
    }      
    image(imageBulldozer, x,y, bulldozerSize, bulldozerSize);

  }

}










