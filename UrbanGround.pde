
// base vectors for coordination transformation
Vertex x2;
Vertex y2;
int gridSize = 8/2;


class UrbanGround{

  UrbanStrip[] strips;
  int numberOfStrips = 93;




  UrbanGround(){

    calcBaseVectors();  // base vectors for drawing the geometry

    strips = new UrbanStrip[93];
    int currentStripLength= 0;
    float xPosMin;
    float xPosMax;
    float yPosMin;
    float yPosMax;

    // create strips with certain lengths
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

    // mark strips with border
    int[] borderStrips = {
      8, 36,37,48, 58, 70, 76            };
    for (int i= 0; i < borderStrips.length; i++){
      strips[borderStrips[i]].hasBorder = true;
    }
    // calculate corners for strips
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
    this.allStripsNoHighlight();

  }

  /** Clear removes all buildings
   * 
   */
  void clear(){
    for(int i=0; i < strips.length; i++){  // reset color for all strips
      strips[i].removeBuilding();
    }
  }

  void allStripsNoHighlight(){
    for(int i=0; i < strips.length; i++){  // reset color for all strips
      strips[i].nohighlight();
    }
  }

  boolean mouseOver(float mousePosX, float mousePosY){
    Vertex mousePos;
    try{
      mousePos = this. calcMousePos(mousePosX, mousePosY);
    }
    catch (Exception e){
      this.allStripsNoHighlight();
      return false;
    }

    allStripsNoHighlight();


    // check all strips under the building
    for(int i = (int)mousePos.x; i < ((int) mousePos.x + draggedBuilding.fieldsX) && i < strips.length; i++){  //highlighting
      strips[i].highlight();  // green or red highlight

        for(int j = i - draggedBuilding.buildHeight; j < i  + draggedBuilding.buildHeight +1 ; j++){  // check left and right to dragged building
        try{   
          if (strips[j].building.lighted ){
            strips[i].currentColor = strips[i].highlightRed;
          }
        }
        catch(Exception e){
        }
      }
    }
    return true;
  }

  /** tries to build the droppedBuilding onto the strips corresponding to mouse position
   * 
   */
  void dropBuilding(Building droppedBuilding, float mousePosX, float mousePosY){

    Vertex mousePos;
    try{
      mousePos = this. calcMousePos(mousePosX, mousePosY);
    }
    catch (Exception e){  
      this.allStripsNoHighlight();
      
      return;
    }

    // test if it can be built here
    for(int i = (int)mousePos.x; i < ((int) mousePos.x + draggedBuilding.fieldsX) && i < strips.length; i++){  // for all strips under building
      //check if there are lighted buildings in the neighborhood
      for(int j = i - draggedBuilding.buildHeight; j < i  + draggedBuilding.buildHeight +1; j++){
        try{   
          if (strips[j].building.lighted){
            this.allStripsNoHighlight();
            buildingFailedSound();
            return;
          }
        }
        catch(Exception e){
        }
      }

      if(!strips[i].isEmpty ||                                   // check if strip is free
      (strips[i].hasBorder && (i < ((int) mousePos.x + draggedBuilding.fieldsX -1) ) ) ||   // check if building is crossing a border
      mousePos.x + draggedBuilding.fieldsX > strips.length  ||  // check for right edge of Urbanground
      strips[i].stripLength < draggedBuilding.fieldsY ||        //  check if all strips under building are long enough
      (draggedBuilding.lighted && !strips[i].canBuildLighted)   //check if building is lighted and ground allows lighted building  
      ){
        this.allStripsNoHighlight();
        return;  // cannot build so return
      }
    }



    // build building
    int buildToDepth = 100000;  // how deep in y direction can the building be built
    for(int i = (int)mousePos.x; i < ((int) mousePos.x + draggedBuilding.fieldsX) && i < strips.length; i++){  //highlighting
      if (buildToDepth > strips[i].stripLength )  // find shortest strip
        buildToDepth = strips[i].stripLength;
    }

    for(int i = (int)mousePos.x; i < ((int) mousePos.x + draggedBuilding.fieldsX) && i < strips.length; i++){  //highlighting
      if (i == (int)mousePos.x) strips[i].isBuildingRoot = true;  // set first strip as root for building
      strips[i].setBuilding(draggedBuilding, buildToDepth);        // set building to all strips
      strips[i].nohighlight();
    }

    // adjust neighboring strips to disallow lighted building
    for(int i = (int)mousePos.x - draggedBuilding.buildHeight; 
    i < ((int) mousePos.x + draggedBuilding.fieldsX + draggedBuilding.buildHeight) && i < strips.length; i++){  //highlighting
      try {
        strips[i].canBuildLighted = false;
      }
      catch(Exception e){
      }
    }
    constructionSound();
    constructedBuildings.addBuilding(draggedBuilding, buildToDepth);
    constructedBuildings.toConsole();
  }

  /** calculate Array position from mouse coordinates
   */
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

void pgDisplay(PGraphics pg){
    pg.stroke(220);
    pg.fill(120);

    for ( int i = strips.length-1; i >= 0 ; i--){
      strips[i].pgDisplay(pg);
    }

    for(int i=0; i < strips.length; i++){  
      strips[i].pgDisplayBuilding(pg);
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

/** Represents one strip of the construction site
*/

class UrbanStrip{
  Building building;
  boolean isBuildingRoot = false;    // the leftmost building is its root and responsible for drawing it
  int buildToDepth;                   // how deep can the building be built here

  int stripLength = 0;
  boolean isEmpty = true;          // is the strip empty
  boolean canBuildLighted = true;  // can a lighted building be constructed here

    Vertex[] corners;          // has to be clockwise starting with top left corner
  boolean hasBorder = false;  // true if the right side of this strip is a border, that can't be built over
  color currentBorderColor;
  color normalBorderColor;

  color fillColor;
  color highlightRed;
  color highlightGreen;
  color currentColor;

  UrbanStrip(int stripLength){
    this.stripLength = stripLength;
    fillColor = color(200);
    highlightRed = color(255,100,100) ;
    highlightGreen =  color(100,255,100);
    normalBorderColor = color(150);
    currentBorderColor = normalBorderColor;
  }

  UrbanStrip(int stripLength, Vertex[] corners){
    this(stripLength);
    this.corners = corners;
  }


  void setBuilding(Building building, int buildToDepth){
    this.building = building;
    this.buildToDepth = buildToDepth;
    this.isEmpty = false;
    this.canBuildLighted = false;

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
    fill(currentColor);
    stroke(190);
    quad(corners[0].x, corners[0].y,
    corners[1].x, corners[1].y,
    corners[2].x, corners[2].y,
    corners[3].x, corners[3].y
      );

    if(hasBorder){  // draw right border
      stroke(currentBorderColor);
      line(corners[1].x, corners[1].y,   corners[2].x, corners[2].y);
    }
  }


  void displayBuilding(){
    if (!isEmpty && this.isBuildingRoot){   
      // display building
      //this.building.draw(this.stripLength / this.building.fieldsY);

      // copy building position
      float buildX = this.building.x;
      float buildY = this.building.y;

      if (this.building.name.equals("Turm")){
        //this.building.draw();
        Vertex towerPos = new Vertex(corners[0].x, corners[0].y);
        for (int i = 0; i <= buildToDepth / (this.building.fieldsY + 10); i++){
          this.building.setCenter(corners[0].x + y2.x * ((this.building.fieldsY+ 10)*(i+1) -10) * gridSize, 
          corners[0].y + y2.y * ((this.building.fieldsY+10)*(i+1) -10)* gridSize);
          this.building.draw();
        }
      }

      else for (int i = 0; i< buildToDepth / this.building.fieldsY; i++){
        this.building.setCenter((corners[0].x + y2.x * this.building.fieldsY* (i+1) * gridSize), 
        (corners[0].y + y2.y * this.building.fieldsY *(i+1)* gridSize));
        this.building.draw();
      }

      // reset building view position to original pos
      this.building.x = buildX;
      this.building.y = buildY;
    }
  }


  void pgDisplay(PGraphics pg){
    // display strip
    pg.fill(currentColor);
    pg.stroke(190);
    pg.quad(corners[0].x, corners[0].y,
    corners[1].x, corners[1].y,
    corners[2].x, corners[2].y,
    corners[3].x, corners[3].y
      );

    if(hasBorder){  // draw right border
      pg.stroke(currentBorderColor);
      pg.line(corners[1].x, corners[1].y,   corners[2].x, corners[2].y);
    }
    
 
  }

void pgDisplayBuilding(PGraphics pg){
    // drawing buildings
    
     if (!isEmpty && this.isBuildingRoot){   
      // display building
      // copy building position
      float buildX = this.building.x;
      float buildY = this.building.y;

      if (this.building.name.equals("Turm")){
        //this.building.draw();
        Vertex towerPos = new Vertex(corners[0].x, corners[0].y);
        for (int i = 0; i <= buildToDepth / (this.building.fieldsY + 10); i++){
          this.building.setCenter(corners[0].x + y2.x * ((this.building.fieldsY+ 10)*(i+1) -10) * gridSize, 
          corners[0].y + y2.y * ((this.building.fieldsY+10)*(i+1) -10)* gridSize);
          this.building.pgDisplay(pg);
        }
      }

      else for (int i = 0; i< buildToDepth / this.building.fieldsY; i++){
        this.building.setCenter((corners[0].x + y2.x * this.building.fieldsY* (i+1) * gridSize), 
        (corners[0].y + y2.y * this.building.fieldsY *(i+1)* gridSize));
        this.building.pgDisplay(pg);
      }

      // reset building view position to original pos
      this.building.x = buildX;
      this.building.y = buildY;
    } 
}

  void highlight(){
    if (hasBorder)
      currentBorderColor = highlightRed;

    if (isEmpty && draggedBuilding.lighted && canBuildLighted || isEmpty && !draggedBuilding.lighted)
      currentColor = highlightGreen;
    else
      currentColor = highlightRed;
  }

  void nohighlight(){
    currentColor = fillColor;
    currentBorderColor = normalBorderColor;
  }
}
















































































