
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


  Building(String name, PShape buildingShape){
    this.name=name;
    this.buildingShape=buildingShape;
  }
  void setCenter(int x, int y){
    this.x = x-sizeX/2;
    this.y = y-sizeY/2;
  }  

  void draw(){
    shape(buildingShape,x,y,sizeX,sizeY);
  } 

  // list to store building names, attributes and graphics
  // best to save it in an extra file. then we need file io -> example2

}




