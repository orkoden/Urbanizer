/**  Calculates statistical data
 */

class BuildingCounter extends ArrayList{

  int[] buildingCounter;

  String[] nameList = {
    "Turm","Scheibe","Block","Patio","Reihe","Frei","Box","BoxKlein", "Andere"
  };

  // text position
  float x = 10;
  float y = 40;
  PFont font;
  PFont fontBig;

  BuildingCounter(){
    super();
    buildingCounter = new int[nameList.length -1];  // dont count andere buildings

    font = loadFont("DIN_1451_Mittelschrift-30.vlw");
    fontBig = loadFont("DIN_1451_Mittelschrift-80.vlw");
  }

  int getIndexForName(String buildingName){
    for (int i=0; i < nameList.length; i++){
      if (nameList[i].equals(buildingName)){
        return i;
      }
    }
    
    return -1;  // building name not found
  }

  void addBuilding(Building building, int buildDepth){
   int index = getIndexForName(building.name);
    if (index < 0)  // return if building is of type andere
        return;
        
    if (index == 0){  // building is a tower
      buildingCounter[index] += (1+( buildDepth /(building.fieldsY + 10)));
    }
    else {
       buildingCounter[index] += buildDepth / building.fieldsY;
    }
  }
  
  
  void removeBuilding(Building building, int buildDepth){
   int index = getIndexForName(building.name);
    if (index < 0)  // return if building is of type andere
        return;
        
    if (index == 0){  // building is a tower
      buildingCounter[index] -= (1+( buildDepth /(building.fieldsY + 10)));
    }
    else {
       buildingCounter[index] -= buildDepth / building.fieldsY;
    }
    
    if (buildingCounter[index] < 0)
      buildingCounter[index] =0;
  }

  

  void toConsole(){
    for(int i=0; i < buildingCounter.length; i++){
      print(nameList[i] + ": " + buildingCounter[i] + " ");
    }

  }

  void display(){
    fill(50);
    textFont(font, 30);
    
    float[] values = this.densityCalc();

    text("BGF: "+values[0] + " m²    Bebaute Fläche: " + values[1] + " m²    GFZ: "+ values[2], x, y);
  }

  void pgDisplay(PGraphics pg){
    pg.fill(50);
    pg.textFont(font, 30);
    float[] values = this.densityCalc();
    pg.text("BGF: "+values[0] + " m²    Bebaute Fläche: " + values[1] + " m²    GFZ: "+ values[2], x, y);

  }
  
  void historyDisplay(PGraphics pg){
     float[] values = this.densityCalc();
     pg.fill(50);
     pg.textFont(fontBig, 80);
     float yy = y;
    y += 80;
    pg.text("GFZ: "+ values[2], x, y);
    y = yy;
  }
  
  float[] densityCalc(){
    
    int bgf =0;
    int areabuilt = 0;

    for(int i=0; i < buildingCounter.length; i++){
      bgf += buildingCounter[i]*buildingPlans[i].bgf;
      areabuilt += buildingCounter[i]*buildingPlans[i].groundArea;
      // println("GA: "+buildingPlans[i].groundArea);
    }
    float gfz = bgf/52900.0;
    gfz = round(gfz*100);
    gfz/= 100;
    
    float[] values = new float[3];
    values[0] = bgf;
    values[1] = areabuilt;
    values[2] = gfz;
    
    return values;
  }
}
























