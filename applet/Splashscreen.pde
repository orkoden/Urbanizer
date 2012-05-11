class Splash{
  PFont fontBig;
  PFont fontSmall;
  
  Splash(){
    fontBig = loadFont("DIN_1451_Mittelschrift-80.vlw");
    fontSmall = loadFont("DIN_1451_Mittelschrift-30.vlw");
    this.display();
  }
  
  void display(){
    textFont(fontBig, 80);
    text("Urbanizer",50, 500);
    textFont(fontSmall, 30);
    text("Taste [s] Zustand speichern\nTaste [n] nochmal von vorne", 50, 600);
  }

}

