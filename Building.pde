
class Building{
  Building[] buildingTypes;

  int x=0;
  int y=0;
  int sizeX=120;
  int sizeY=120;
  PShape buildingShape;
  String name;

  Building(){
    name = "unnamed Building";
    buildingShape = loadShape("bot1.svg");

  }

  Building(String[] fromFile){
    name = fromFile[0];
    buildingShape = loadShape(fromFile[1]);

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
    shape(buildingShape,x,y,sizeX,sizeY);
  } 

}





