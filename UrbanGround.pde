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

    return true;
  }

  void display(){
    stroke(245);
    fill(250);

    float xPosMin;
    float xPosMax;
    float yPosMin;
    float yPosMax;

    for ( int i = 0; i< strips.length ; i++){
      xPosMin = i*gridSize; // xAxisRotate[0]*
      xPosMax = (1+i)*gridSize; //xAxisRotate[0]*
      yPosMin =  0 ; // xAxisRotate[1]*i;
      yPosMax = strips[i].stripLength*gridSize; //xAxisRotate[1]*i+

      Vertex topleft = new Vertex(xPosMin, yPosMin);      
      topleft.transform(x2,y2);
      Vertex topright = new Vertex(xPosMax, yPosMin);
      topright.transform(x2,y2);
      Vertex bottomleft = new Vertex(xPosMax, yPosMax);
      bottomleft.transform(x2,y2);
      Vertex bottomright = new Vertex(xPosMin, yPosMax);
      bottomright.transform(x2,y2);

      quad(topleft.x,  topleft.y,    // top left corner
      topright.x,  topright.y,    // top right corner
      bottomleft.x,  bottomleft.y,  // lower right corner
      bottomright.x, bottomright.y       // lower left corner
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
  
  UrbanStrip(int stripLength){
    this.stripLength = stripLength;
  }

  boolean mouseOver(){
    return true;
  }

}

















