
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

    boxWidth = buttonSize *2;
    x= width -10 - boxWidth;
    numberOfBuildingButtons = buildingPlans.length;
    boxHeight = buttonSize * numberOfBuildingButtons/2;
    buildingButtons = new Button[numberOfBuildingButtons];

    for( int i= 0; i < numberOfBuildingButtons/2; i++){  // zeilen
      for( int j= 0; j<2; j++){                          // spalten
        buildingButtons[i*2+j] = new BuildingButton(x+j*buttonSize,y+buttonSize*i, buttonSize, buildingPlans[i*2+j]);
      }
    }
  }
  void draw(){
    for( int i= 0; i < numberOfBuildingButtons; i++){

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
    shape(building.buildingShape,x,y,buttonSize,buttonSize);
  }
  
  void update(){
    super.update();
    if (over() && mousePressed){          // test if this button is clicked
      building.setCenter(mouseX,mouseY);  
      draggedBuilding = building.clone();  // .copy(); wÃ¤re netter  // create draggable building
      // spÃ¤ter hier neues building object erstellen
    }
  }

}




