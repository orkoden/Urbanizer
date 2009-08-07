class Ground{
  GridField[][] grid;
  int gridSizeX;
  int gridSizeY;
  int gridspacing;  // determines field sizes

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
        quad(j*10 + i*gridspacing ,   height - 10 - j* gridspacing,       // vertex 1 unten links
        j*10 + (i+1)*gridspacing,     height - 10 - j* gridspacing,       // vertex 2 unten rechts
        j*10 + (i+1)*gridspacing + 10,height - 10 - (j+1)* gridspacing,   // vertex 4 oben rechts
        j*10 + i*gridspacing + 10,    height - 10 - (j+1)* gridspacing    // vertex 3 oben links
        );

        // draw built fields
        if(grid[i][j].isEmpty == false){
          shape(grid[i][j].building.buildingShape,
          j*10 + i*gridspacing + 10,    height - 10 - (j+1)* gridspacing,
          gridspacing,gridspacing);  
        }
      }
    }
  }

  void dropped(Building draggedBuilding){
    //calculate array coordinates from mouse coordinates
    if (mouseY > height -10)  // check for lower bound
      return;
    if (mouseY < height - 10 - gridSizeY* gridspacing)  // check for upper bound
      return;
    int yPos = (mouseY - (height - 10 - gridSizeY* gridspacing))/gridspacing;
    
    if (mouseX < 10)    // check left bound
      return;
    if (mouseX > yPos*10 + (gridSizeX)*gridspacing + 10)  // check max right bound
      return;
    int xPos = (mouseX - yPos*10 )/gridspacing;
    yPos = gridSizeY -yPos -1;
    println("building dropped at x: "+xPos+" y: "+yPos);

    if(grid[xPos][yPos].isEmpty)  // check if field is available
      grid[(mouseX-10)%gridSizeX][(mouseY-10)%gridSizeY].setBuilding(draggedBuilding);  // drop building
  }

}

//represents one field in the grid
class GridField{
  Building building;
  boolean isEmpty;  
  GridField(){
    isEmpty = true;
  }

  void setBuilding(Building building){
    this.building = building;
    isEmpty = false;
  }
}















