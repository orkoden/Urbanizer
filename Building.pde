/**
 * Represents one Building with Attributes.
 */
class Building{
  Building[] buildingTypes;

  int x=0;
  int y=0;
  int sizeX=120;    //vistible size. should be calculated from fieldsize in grid * fieldsX
  int sizeY=120;

  int gridUnit = 20;

  PShape buildingShape;
  String name;
  //possible attributes
  int fieldsX = 1;  // the number of fields this building covers in x and y direction
  int fieldsY = 1;

  int buildHeight = 1;

  Building(){
    name = "unnamed Building";
    buildingShape = loadShape("bot1.svg");

  }

  Building(String[] fromFile){
    this.name = fromFile[0];
    this.buildingShape = loadShape(fromFile[1]);
    this.fieldsX = int(fromFile[2]);
    this.fieldsY = int(fromFile[3]);
    this.buildHeight = int(fromFile[4]);
    sizeX =fieldsX *gridUnit;
    sizeY = buildHeight*gridUnit;
    println("new building constructed name: "+ this.name + " fieldsX: "+ this.fieldsX + " fieldsY: "+ this.fieldsY + " height: "+this.buildHeight);
  }

  Building(String name, PShape buildingShape){
    this.name=name;
    this.buildingShape=buildingShape;
  }
  void setCenter(int x, int y){
    this.x = x-sizeX/2;
    this.y = y-sizeY/2;
  }  

  Building clone(){
    Building clone = new Building();
    clone.x = x;
    clone.y = y;
    clone.sizeX=sizeX;
    clone.sizeY=sizeY;
    clone.buildingShape = buildingShape;
    clone.name = name;
    return clone;
  }

  void draw(){
    //    stroke(200);
    //  fill(50);
  //  shape(buildingShape,x,y,sizeX,sizeY);
  shape(buildingShape,x,y);
    } 

}









