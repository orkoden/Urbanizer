
class ItemBox{
  int x,y = 10; 
  int boxWidth = 100;
  int boxHeight = 100;
  Button[] buildingButtons;
  int numberOfBuildingButtons;
  int buttonSize = 50;

  ItemBox(){
    this(50);
  }


  ItemBox(int buttonSize){
    this.buttonSize=buttonSize;

    boxWidth = buttonSize;
    x= width -10 - boxWidth;
    numberOfBuildingButtons = buildingPlans.length;
    boxHeight = buttonSize * numberOfBuildingButtons;
    buildingButtons = new Button[numberOfBuildingButtons];

    for( int i= 0; i < numberOfBuildingButtons; i++){  // zeilen
      //      for( int j= 0; j<1; j++){                          // spalten
      buildingButtons[i] = new BuildingButton(x,y+buttonSize*i, buttonSize, buildingPlans[i]);
    }
    //    }
  }
  void draw(){
    for( int i= 0; i < numberOfBuildingButtons; i++){  // draw all buttons

      buildingButtons[i].draw(); 
    }
  }

}

/** generic class to create a square button, that changes color on mouseover  */
class Button{
  int buttonSize = 50;
  int x, y;            // on screen position
  color buttonColor;  
  color borderColor;
  color highlightColor;
  color currentColor;
  boolean over = false;

  Button(int x, int y){
    this(x,y,50);
  }
  Button(int x, int y, int buttonSize){
    this.buttonSize = buttonSize;
    this.x=x;
    this.y=y;
    buttonColor = color(200);
    borderColor = color(255);
    highlightColor = color(100);
    currentColor = buttonColor;
  }

  void draw(){
    this.update();
    stroke(borderColor);
    fill(currentColor);
    rect(x,y,buttonSize, buttonSize);
  }

  void update()   // update color depending on mouseover
  {
    if(over()) {
      currentColor = highlightColor;
    } 
    else {
      currentColor = buttonColor;
    }
  }
  boolean over(){  // test for mouse over
    if (mouseX >= x && mouseX <= x+buttonSize && 
      mouseY >= y && mouseY <= y+buttonSize) {
      return true;
    } 
    else {
      return false;
    }
  }
}

class BuildingButton extends Button{
  Building building;
  PShape shape;
  BuildingButton(int x, int y){
    this(x,y,50);
  }

  BuildingButton(int x, int y, int buttonSize){
    super(x,y, buttonSize);
    building = new Building();
  }
  BuildingButton(int x, int y, int buttonSize, Building building){
    super(x,y, buttonSize);
    this.building = building;
  }

  void draw(){
    super.draw();
    // println("Drawing: " + building.name);
    float ratio = building.buildingShape.height/building.buildingShape.width;
    float drawX; 
    float drawY;
    float distY;
    float distX;
    
    if (ratio < 1){  // width > height
      drawX = buttonSize-10;
      drawY = drawX*ratio;
    }
    else{  // width < height
      drawY = buttonSize-10;
      drawX = drawY/ratio;
    }
    
  distX = x + buttonSize/2.0 - drawX/2.0;
  distY = y + buttonSize/2.0 - drawY/2.0;

    shape(building.buildingShape,distX,distY,drawX,drawY);
  }

  void update(){
    super.update();
    if (over() && mousePressed){            // test if this button is clicked
      draggedBuilding = building.clone(); // create draggable building
      draggedBuilding.setCenter(mouseX,mouseY);  
     
    }
  }

}





