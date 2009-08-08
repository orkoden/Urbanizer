class UrbanGround{

  UrbanStrip[] strips;
  int numberOfStrips = 93;
  int gridSize = 8;

  // offsets for the geometry
  float[] xAxisRotate;  // multiply x and y by this
  float[] yAxisRotate;  // 



  UrbanGround(){
    xAxisRotate = new float[2];
    yAxisRotate = new float[2];
    xAxisRotate[1] = tan(TWO_PI/16);
    xAxisRotate[0] = 1/cos(TWO_PI/16);
    yAxisRotate[0] = -tan(TWO_PI/16);
    yAxisRotate[1] = 1/cos(TWO_PI/16);


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
    stroke(200);
    fill(100);
    
    float xPosMin;
    float xPosMax;
    float yPosMin;
    float yPosMax;

    for ( int i = 0; i< strips.length ; i++){
      xPosMin = xAxisRotate[0]*i*gridSize;
      xPosMax =  xAxisRotate[0]*(1+i)*gridSize;
      yPosMin =  xAxisRotate[1]*i;
      yPosMax = xAxisRotate[1]*i+strips[i].stripLength*gridSize;
      
      quad(xPosMin,  yPosMin,    // top left corner
      xPosMax,  yPosMin,    // top right corner
      xPosMax,  y,  // lower right corner
      xAxisRotate[0]*i*gridSize,  xAxisRotate[1]*i+strips[i].stripLength*gridSize        // lower left corner

      );
    }

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

  void display(){

  }
}













