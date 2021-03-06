/**
 * Represents one Building with Attributes.
 */
class Building{

  float x=0;
  float y=0;
  float sizeX=120;    //vistible size. should be calculated from fieldsize in grid * fieldsX
  float sizeY=120;

  int gridUnit = 20;


  PShape buildingShape;
  String name;
  //possible attributes
  int fieldsX = 5;  // the number of fields this building covers in x and y direction
  int fieldsY = 1;
  float centerOffsetY =5;

  int buildHeight = 1;
  boolean lighted = false;  // true if outer facades need lighting

  int groundArea = 0;  // Grundflaeche
  int bgf = 0;  // Bruttogeschossflaeche

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
    if(fromFile[5].equals("ja"))
      this.lighted = true;

    this.groundArea = int(fromFile[6]);
    this.bgf =int(fromFile[7]);

    // sizes still don' work correctly. because shape.width depends on fields x and y
    float ratio = buildingShape.height/buildingShape.width;
    sizeX = buildingShape.width/2.0;
    sizeY = round( sizeX * ratio);

    this.centerOffsetY = centerOffset(fromFile[0]);

    println("new building constructed name: "+ this.name + " fieldsX: "+ this.fieldsX + " fieldsY: "+ this.fieldsY + " height: "+this.buildHeight + " centerOffsetY: " + this.centerOffsetY + " Grundfläche: " +this.groundArea);
  }

  Building(String name, PShape buildingShape){
    this.name=name;
    this.buildingShape=buildingShape;
  }

  float centerOffset(String buildingName){

    if(buildingName.equals("Turm"))
      return 8;
    else if(buildingName.equals("Scheibe"))
      return 4;
    else if(buildingName.equals("Block"))
      return 11;
    else if(buildingName.equals("Patio"))
      return 8;
    else if(buildingName.equals("Reihe"))
      return 4;
    else if(buildingName.equals("Frei"))
      return 8;
    else if(buildingName.equals("Box"))
      return 17;
    else if(buildingName.equals("BoxKlein"))
      return 9;

    else 
      return 7;

  }

  // set draggin position
  void setCenter(float x, float y){

    // set mouse pointer relative to building, so mouspointer and building point to the same building strip
    this.x = x;        //round(x-sizeX/2);
    this.y = y- sizeY + this.centerOffsetY;
  }  

  Building clone(){
    Building clone = new Building();
    clone.x = x;
    clone.y = y;
    clone.sizeX=sizeX;
    clone.sizeY=sizeY;
    clone.fieldsX=fieldsX;
    clone.fieldsY=fieldsY;
    clone.buildingShape = buildingShape;
    clone.name = name;
    clone.centerOffsetY = centerOffsetY;
    clone.buildHeight = buildHeight;
    clone.lighted = lighted;
    clone.groundArea = groundArea;
    clone.bgf = bgf;
    return clone;
  }

  void draw(){
    //    stroke(200);
    //  fill(50);
    shape(buildingShape,x,y,sizeX,sizeY);  //does work 
    // shape(buildingShape,x,y);
  } 

  void pgDisplay(PGraphics pg){
    pg.shape(buildingShape,x,y,sizeX,sizeY);  //does work 

}

}



