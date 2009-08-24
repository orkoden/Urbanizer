class BuildingCounter extends ArrayList{

  ArrayList[] buildingList;
  ArrayList currentList;
  String[] nameList = {
    "Turm","Scheibe","Block","Patio","Reihe","Frei","Box","BoxKlein", "Andere"
  };

  // text position
  float x = 0;
  float y = 0;
  PFont font;

  BuildingCounter(){
    super();
    buildingList = new ArrayList[9];
    for(int i=0; i < buildingList.length; i++){
      buildingList[i] = new ArrayList();
    }

    font = loadFont("DIN_1451_Mittelschrift-20.vlw");
    textFont(font, 20);
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

  void toConsole(){
    for(int i=0; i < buildingList.length; i++){
      print(nameList[i] + ": " + buildingList[i].size() + " ");
    }

  }

  void display(){
    fill(50);
    //    text("Archlecken", 100, 130);
    for(int i=0; i < buildingList.length; i++){
      String bla = nameList[i] + ": " + buildingList[i].size() + " ";
      text(bla, 10, 500 + i* 30);
    }
  }
}

















