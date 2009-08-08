/*
Liest zur Zeit nur Dateien mit gerader Zeilenzahl erfolgreich aus

*/
void buildingsFromFile(){
  int recordCount = 0;
  String[] lines = loadStrings("typos.tsv");      // jede Array Zelle enthält eine Zeile text
  buildingPlans = new Building[lines.length-1];            // so vielel records wie anzahl zeieln
  for (int i = 1; i < lines.length; i++) {                //skip first line
    String[] pieces = split(lines[i], '\t');             // tokenize the lines separated by tab
    buildingPlans[recordCount] = new Building(pieces);   // create a new building template
    recordCount++;
  }
}

