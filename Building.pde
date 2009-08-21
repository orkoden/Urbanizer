/**
 * Represents one Building with Attributes.
 */
class Building{

  int x=0;
  int y=0;
  float sizeX=120;    //vistible size. should be calculated from fieldsize in grid * fieldsX
  float sizeY=120;

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

    // sizes still don' work correctly. because shape.width depends on fields x and y
    float ratio = buildingShape.height/buildingShape.width;
    sizeX = buildingShape.width/2.0;
    sizeY = round( sizeX * ratio);
    
    println("new building constructed name: "+ this.name + " fieldsX: "+ this.fieldsX + " fieldsY: "+ this.fieldsY + " height: "+this.buildHeight);
  }

  Building(String name, PShape buildingShape){
    this.name=name;
    this.buildingShape=buildingShape;
  }
  
  // set draggin position
  void setCenter(int x, int y){
    
    // set mouse pointer relative to building, so mouspointer and building point to the same building strip
    this.x = (int) round(x);//round(x-sizeX/2);
    this.y = (int) round(y-sizeY+5);
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
      shape(buildingShape,x,y,sizeX,sizeY);  //does't work yet
   // shape(buildingShape,x,y);
  } 

}










