
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
    numberOfBuildingButtons = 10;
    boxHeight = buttonSize * numberOfBuildingButtons/2;
    buildingButtons = new Button[numberOfBuildingButtons];

    for( int i= 0; i < numberOfBuildingButtons/2; i++){  // zeilen
      for( int j= 0; j<2; j++){                          // spalten
        buildingButtons[i*2+j] = new BuildingButton(x+j*buttonSize,y+buttonSize*i, buttonSize);
      }
    }
  }
  void draw(){
    for( int i= 0; i < numberOfBuildingButtons; i++){

      buildingButtons[i].draw(); 
    }
    //    rect(x, y, boxWidth, boxHeight);
  }

}

class Button{
  int buttonSize = 50;
  int x, y;
  color buttonColor;  
  color borderColor;
  color highlightColor;
  color currentColor;
  boolean over = false;
  boolean pressed = false;   

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

  void draw(){
    super.draw();
    // println("Drawing: " + building.name);
    shape(building.buildingShape,x,y,buttonSize,buttonSize);
  }
  void update(){
    super.update();
    if (over() && mousePressed){
      building.setCenter(mouseX,mouseY);
      draggedBuilding = building;  // .copy(); wäre netter
      // später hier neues building object erstellen
    }
  }

}




