
// base vectors for coordination transformation
Vertex x2;
Vertex y2;
int gridSize = 8/2;


class UrbanGround{

  UrbanStrip[] strips;
  int numberOfStrips = 93;

  // base vectors for drawing the geometry



  UrbanGround(){

    calcBaseVectors();
    strips = new UrbanStrip[93];
    int currentStripLength= 0;
    float xPosMin;
    float xPosMax;
    float yPosMin;
    float yPosMax;


    for ( int i = 0; i< strips.length ; i++){
      // ### assign strip length
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
      // ### end assign strip length
      strips[i] = new UrbanStrip(currentStripLength);
    }   

    for ( int i = 0; i< strips.length ; i++){

      // ### begin corner calculation
      xPosMin = i*gridSize; 
      xPosMax = (1+i)*gridSize; 
      yPosMin =  0 ; 
      yPosMax = strips[i].stripLength*gridSize; 

      Vertex topleft = new Vertex(xPosMin, yPosMin);      
      Vertex topright = new Vertex(xPosMax, yPosMin);
      Vertex bottomright = new Vertex(xPosMax, yPosMax);
      Vertex bottomleft = new Vertex(xPosMin, yPosMax);

      topleft.transform(x2,y2);
      topright.transform(x2,y2);
      bottomright.transform(x2,y2);
      bottomleft.transform(x2,y2);

      // ### end corner calculation

      Vertex[] corners = new Vertex[4];
      corners[0] = topleft;
      corners[1] = topright;
      corners[2] = bottomright;
      corners[3] = bottomleft;

      strips[i].corners = corners;  // assign corners

    }

  }

  void clear(){
    for(int i=0; i < strips.length; i++){  // reset color for all strips
      strips[i].removeBuilding();
    }

  }

  boolean mouseOver(float mousePosX, float mousePosY){
    Vertex mousePos;
    try{
      mousePos = this. calcMousePos(mousePosX, mousePosY);
    }
    catch (Exception e){
      return false;
    }

    for(int i=0; i < strips.length; i++){  // reset color for all strips
      strips[i].fillColor = color(200);
    }

    // check all strips under the building
    for(int i = (int)mousePos.x; i < ((int) mousePos.x + draggedBuilding.fieldsX) && i < strips.length; i++){  //highlighting
      strips[i].highlight();  // green or red highlight
    }
    return true;
  }

  void dropBuilding(Building droppedBuilding, float mousePosX, float mousePosY){

    Vertex mousePos;
    try{
      mousePos = this. calcMousePos(mousePosX, mousePosY);
    }
    catch (Exception e){
      return;
    }
    //  check if all strips under building are empty

    for(int i = (int)mousePos.x; i < ((int) mousePos.x + draggedBuilding.fieldsX) && i < strips.length; i++){  //highlighting
      if(!strips[i].isEmpty)
        return;
    }

    for(int i = (int)mousePos.x; i < ((int) mousePos.x + draggedBuilding.fieldsX) && i < strips.length; i++){  //highlighting
      if (i == (int)mousePos.x) strips[i].isBuildingRoot = true;  // set first strip as root for building
      strips[i].setBuilding(draggedBuilding);        // 
      strips[i].fillColor = color(200);
    }
  }

  // calculate Array position from mouse coordinates
  Vertex calcMousePos(float mousePosX, float mousePosY) throws Exception{
    Vertex mousePos = new Vertex(mousePosX, mousePosY);
    mousePos.transformBack(x2,y2);

    mousePos.x /= gridSize;
    mousePos.y /= gridSize;
    //   println("strip x: " +mousePos.x + " y: " + mousePos.y);
    mousePos.x = floor(mousePos.x);
    mousePos.y = floor(mousePos.y);
    // check boundaries
    if (mousePos.x < 0 || mousePos.x >= strips.length)  // check x boundaries
      throw new Exception() ;
    else if(mousePos.y < 0 || mousePos.y >= strips[(int)mousePos.x].stripLength){  // check strip length boundaries
      throw new Exception() ;  
    }
    return mousePos;
  }

  void display(){
    stroke(220);
    fill(120);

    for ( int i = strips.length-1; i >= 0 ; i--){
      strips[i].display();
    }

    for(int i=0; i < strips.length; i++){  
      strips[i].displayBuilding();
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
  boolean isBuildingRoot = false;    // the leftmost building is its root and responsible for drawing it

  int stripLength = 0;
  boolean isEmpty = true;
  Vertex[] corners;  // has to be clockwise starting with top left corner

  color fillColor;
  color highlightRed;
  color highlightGreen;

  UrbanStrip(int stripLength){
    this.stripLength = stripLength;
    fillColor = color(200);
    highlightRed = color(255,100,100) ;
    highlightGreen =  color(100,255,100);
  }

  UrbanStrip(int stripLength, Vertex[] corners){
    this(stripLength);
    this.corners = corners;
  }

  boolean mouseOver(){
    return true;
  }

  void setBuilding(Building building){
    this.building = building;
    this.isEmpty = false;
    if (this.isBuildingRoot) 
      this.building.setCenter((int) (corners[0].x + y2.x * this.building.fieldsY * gridSize), 
      (int)(corners[0].y + y2.y * this.building.fieldsY * gridSize));

  }
  void removeBuilding(){
    this.building = null;
    this.isEmpty = true;
  }

  void display(){
    // display strip
    fill(fillColor);
    stroke(190);
    quad(corners[0].x, corners[0].y,
    corners[1].x, corners[1].y,
    corners[2].x, corners[2].y,
    corners[3].x, corners[3].y
      );
  }

  void displayBuilding(){
    if (!isEmpty && this.isBuildingRoot){   
      // display building
      //this.building.draw(this.stripLength / this.building.fieldsY);

      // copy building position
      int buildX = this.building.x;
      int buildY = this.building.y;

      if (this.building.name.equals("Turm")){
        for (int i = 0; i< this.stripLength / (this.building.fieldsY + 10); i++){
          this.building.setCenter((int) round(corners[0].x + y2.x * (this.building.fieldsY +10)* (i+1) * gridSize), 
          (int)round(corners[0].y + y2.y * (this.building.fieldsY +10) *(i+1)* gridSize));
          this.building.draw();
        }
      }

      else for (int i = 0; i< this.stripLength / this.building.fieldsY; i++){
        this.building.setCenter((int) round(corners[0].x + y2.x * this.building.fieldsY* (i+1) * gridSize), 
        (int)round(corners[0].y + y2.y * this.building.fieldsY *(i+1)* gridSize));
        this.building.draw();
      }

      this.building.x = buildX;
      this.building.y = buildY;
    }
  }

  void highlight(){
    if (isEmpty)
      fillColor = highlightGreen;
    else
      fillColor = highlightRed;
  }
}


















































