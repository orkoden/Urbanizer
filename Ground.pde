class Ground{
  GridField[][] grid;
  int gridSizeX;
  int gridSizeY;
  int gridspacing;  // determines field sizes
  int slant = 10;   // how schief shall the grid be?

  Ground(){
    this(6,2, 30);
  }

  Ground(int gridSizeX,int gridSizeY,int gridspacing){
    this.gridSizeX =gridSizeX;
    this.gridSizeY= gridSizeY;
    this.gridspacing = gridspacing;

    grid = new  GridField[gridSizeX][gridSizeY];

    for( int i=0; i<gridSizeX; i++){
      for(int j=0; j<gridSizeY; j++){
        grid[i][j] = new GridField();

      }
    }
  }

  void draw(){
    fill(30);
    stroke(100);

    for(int i=0; i < gridSizeX; i++){
      for( int j=0; j < gridSizeY; j++){

        // draw empty grid, vertices anticlockwise
        quad(j*slant + i*gridspacing ,   height - 10 - j* gridspacing,       // vertex 1 unten links
        j*slant + (i+1)*gridspacing,     height - 10 - j* gridspacing,       // vertex 2 unten rechts
        j*slant + (i+1)*gridspacing + 10,height - 10 - (j+1)* gridspacing,   // vertex 4 oben rechts
        j*slant + i*gridspacing + 10,    height - 10 - (j+1)* gridspacing    // vertex 3 oben links
        );

        // draw built fields
        if(grid[i][j].isEmpty == false){
          shape(grid[i][j].building.buildingShape,
          j*slant + i*gridspacing + 10,    height - 10 - (j+1)* gridspacing,
          gridspacing,gridspacing);  
        }
      }
    }
  }

  /**
   * Returns the field the mouse is over
   */
  GridField mouseOverField() throws OutOfGridException{
    //calculate array coordinates from mouse coordinates
    // height - 10 - (j+1)* gridspacing = Y
    int yPos = ((mouseY - height + 10 )/ -gridspacing) ;

    // j*slant + (i+1)*gridspacing + 10 = X
    int xPos = ((mouseX -10 - yPos * slant) / gridspacing); 

    // check if mouse over grid
    if (yPos < 0 || mouseX < yPos * slant || yPos >= gridSizeY || xPos >= gridSizeX)
      throw new OutOfGridException();
    println("gridPosition x: "+xPos+" y: "+yPos);
    return grid[xPos][yPos]; 
  }

  boolean dropped(Building draggedBuilding){
     try{
      GridField field = this.mouseOverField();
      if(field.isEmpty){  // check if field is available
        field.setBuilding(draggedBuilding);  // drop building
        println("building "+draggedBuilding.name+" dropped");
        return true;  
      }
    }
    catch(OutOfGridException e){
      return false;
    }
    return false;
  }

}

//represents one field in the grid
class GridField{
  //  int x;    // Position in Grid
  //  int y;
  Building building;
  boolean isEmpty;  
  GridField(){
    isEmpty = true;
  }

  void setBuilding(Building building){
    this.building = building;
    this.isEmpty = false;
  }
}

/**
 * Is thrown, when the field boundaries are exeeded
 */
class OutOfGridException extends Exception{
  OutOfGridException(){
    super();
  }
}






