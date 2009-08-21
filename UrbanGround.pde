class UrbanGround{

  UrbanStrip[] strips;
  int numberOfStrips = 93;
  int gridSize = 8/2;

  // base vectors for drawing the geometry
  Vertex x2;
  Vertex y2;



  UrbanGround(){

    calcBaseVectors();
    strips = new UrbanStrip[93];
    int currentStripLength= 0;
    for ( int i = 0; i< strips.length ; i++){
      if (i<9)
        currentStripLength = 46;
      else if(i <37)
        currentStripLength = 8;
      else if (i ==  37)
        currentStripLength = 34;
      else if(i<49)
        currentStripLength = 8;
      else if(i<59)
        currentStripLength = 22;
      else if (i<71)
        currentStripLength = 8;
      else if (i<77)
        currentStripLength = 13;
      //     else if (i < 79)
      //       currentStripLength = 22;
      else if (i<93){
        currentStripLength =(int)round( (92-i)*(8.0/16) +14);
      }
      strips[i] = new UrbanStrip(currentStripLength);

    }

  }

  boolean mouseOver(){
    //    Vertex xBase = new Vertex(1,0);
    //    Vertex yBase = new Vertex(0,1);
    Vertex mousePos = new Vertex(mouseX, mouseY);
    //    mousePos.x -= 210;
    //    mousePos.y -= 150;
    mousePos.transformBack(x2,y2);

    mousePos.x /= gridSize;
    mousePos.y /= gridSize;
    //    
    println("strip x: " +mousePos.x + " y: " + mousePos.y);
    strips[(int) mousePos.x].fillColor = color(200,50,50);
    return true;
  }

  void display(){
    stroke(220);
    fill(230);

    float xPosMin;
    float xPosMax;
    float yPosMin;
    float yPosMax;

    for ( int i = 0; i< strips.length ; i++){
      fill(strips[i].fillColor);

      xPosMin = i*gridSize; 
      xPosMax = (1+i)*gridSize; 
      yPosMin =  0 ; 
      yPosMax = strips[i].stripLength*gridSize; 

      Vertex topleft = new Vertex(xPosMin, yPosMin);      
      Vertex topright = new Vertex(xPosMax, yPosMin);
      Vertex bottomleft = new Vertex(xPosMax, yPosMax);
      Vertex bottomright = new Vertex(xPosMin, yPosMax);

      // draw strips top down
      //      quad(topleft.x,  topleft.y,      // top left corner
      //      topright.x,  topright.y,        // top right corner
      //      bottomleft.x,  bottomleft.y,    // lower right corner
      //      bottomright.x, bottomright.y    // lower left corner
      //      );

      topleft.transform(x2,y2);
      topright.transform(x2,y2);
      bottomright.transform(x2,y2);
      bottomleft.transform(x2,y2);

      //draw transformed strips
      quad(topleft.x,  topleft.y,      // top left corner
      topright.x,  topright.y,        // top right corner
      bottomleft.x,  bottomleft.y,    // lower right corner
      bottomright.x, bottomright.y    // lower left corner
      );
    }

  }

  void calcBaseVectors(){
    x2 = new Vertex(1,0);
    y2 = new Vertex(0,1);
    x2.rotate();
    y2.rotate();
    x2.normalize();
    y2.normalize();
    x2.scale(2);
    y2.scale(2*0.72);
  }

}

class UrbanStrip{
  Building building;
  int stripLength;
  boolean isEmpty;
  color fillColor;

  UrbanStrip(int stripLength){
    this.stripLength = stripLength;
    fillColor = color(230);
  }

  boolean mouseOver(){
    return true;
  }

}























