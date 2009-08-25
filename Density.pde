/**  Calculates statistical data
 */

class BuildingCounter extends ArrayList{

  ArrayList[] buildingList;
  ArrayList currentList;
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
    buildingList = new ArrayList[9];
    for(int i=0; i < buildingList.length; i++){
      buildingList[i] = new ArrayList();
    }

    font = loadFont("DIN_1451_Mittelschrift-30.vlw");
    fontBig = loadFont("DIN_1451_Mittelschrift-80.vlw");
  }

  void addBuilding(Building building, int buildDepth){
    if(building.name.equals("Turm"))
      currentList = buildingList[0];
    else if(building.name.equals("Scheibe"))
      currentList = buildingList[1];
    else if(building.name.equals("Block"))
      currentList = buildingList[2];
    else if(building.name.equals("Patio"))
      currentList = buildingList[3];
    else if(building.name.equals("Reihe"))
      currentList = buildingList[4];
    else if(building.name.equals("Frei"))
      currentList = buildingList[5];
    else if(building.name.equals("Box"))
      currentList = buildingList[6];
    else if(building.name.equals("BoxKlein"))
      currentList = buildingList[7];
    else 
      currentList = buildingList[8];


    if (building.name.equals("Turm")){
      for (int i = 0; i <= buildDepth / (building.fieldsY + 10); i++){     
        currentList.add(building);
      }
    }
    else for( int i=0; i < buildDepth / building.fieldsY; i++){
      currentList.add(building);
    }
  }
  
  
  void removeBuilding(Building toremove){
    
   if(toremove.name.equals("Turm"))
      currentList = buildingList[0];
    else if(toremove.name.equals("Scheibe"))
      currentList = buildingList[1];
    else if(toremove.name.equals("Block"))
      currentList = buildingList[2];
    else if(toremove.name.equals("Patio"))
      currentList = buildingList[3];
    else if(toremove.name.equals("Reihe"))
      currentList = buildingList[4];
    else if(toremove.name.equals("Frei"))
      currentList = buildingList[5];
    else if(toremove.name.equals("Box"))
      currentList = buildingList[6];
    else if(toremove.name.equals("BoxKlein"))
      currentList = buildingList[7];
    else 
      currentList = buildingList[8];
 
      for (int j=currentList.size()-1; j > 0; j--){
        if(currentList.get(j) == toremove)
          currentList.remove(toremove);
      }
  }

  

  void toConsole(){
    for(int i=0; i < buildingList.length; i++){
      print(nameList[i] + ": " + buildingList[i].size() + " ");
    }

  }

  void display(){
    textFont(font, 30);

    fill(50);
    //    text("Archlecken", 100, 130);
    //    for(int i=0; i < buildingList.length; i++){
    //      String bla = nameList[i] + ": " + buildingList[i].size() + " ";
    //      text(bla, 10, 500 + i* 30);
    //    }

    int bgf =0;
    int areabuilt = 0;

    for(int i=0; i < buildingList.length - 1; i++){
      bgf += buildingList[i].size()*buildingPlans[i].bgf;
      areabuilt += buildingList[i].size()*buildingPlans[i].groundArea;
      // println("GA: "+buildingPlans[i].groundArea);
    }
    float gfz = bgf/52900.0;
    //       println("GFZ: "+ gfz);

    gfz = round(gfz*100);
    gfz/= 100;
    text("BGF: "+bgf + " m²    Bebaute Fläche: " + areabuilt + " m²    GFZ: "+ gfz, x, y);
  }

  void pgDisplay(PGraphics pg){
    float[] values = this.pgDisplayHelper(pg);
    pg.text("BGF: "+values[0] + " m²    Bebaute Fläche: " + values[1] + " m²    GFZ: "+ values[2], x, y);

  }
  
  void historyDisplay(PGraphics pg){
     float[] values = this.pgDisplayHelper(pg);
     pg.textFont(fontBig, 80);
      float yy = y;
    y += 80;
    pg.text("GFZ: "+ values[2], x, y);
    y = yy;
  }
  
  float[] pgDisplayHelper(PGraphics pg){
    pg.textFont(font, 30);

    pg.fill(50);
    
    int bgf =0;
    int areabuilt = 0;

    for(int i=0; i < buildingList.length - 1; i++){
      bgf += buildingList[i].size()*buildingPlans[i].bgf;
      areabuilt += buildingList[i].size()*buildingPlans[i].groundArea;
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
























