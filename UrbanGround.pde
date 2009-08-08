class UrbanGround{

  UrbanStrip[] strips;
  int numberOfStrips = 93;
  int gridSize = 8;
  
  // offsets for the geometry
  double offsetXAxis;
  double offsetYAxis;
  
  UrbanGround(){
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

    for ( int i = 0; i< strips.length ; i++){
      quad(i*gridSize,0,    // top left corner
      (1+i)*gridSize,0,    // top right corner
      (1+i)*gridSize,strips[i].stripLength*gridSize,  // lower right corner
      i*gridSize,strips[i].stripLength*gridSize        // lower left corner

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












