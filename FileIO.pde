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


/** Draws construction site to offview buffer and saves to file and history
 * 
 */

class ImageSave extends Thread{
  ImageSave(){
  }

  public void run(){
    
 // file drawing
    try{
      PGraphics pg;
      pg = createGraphics(950, 450, JAVA2D);
  
      pg.beginDraw();
  
      background(250);
      pg.smooth();

      constructedBuildings.pgDisplay(pg);
      urbanGround.pgDisplay(pg);
      
      pg.endDraw();
      
      pg.save("construction_site_"+year()+month()+day()+hour()+minute()+second()+".png");
    }
    catch(Exception e){  // saving might fail
    }
    // history drawing
    PGraphics hpg;
    hpg = createGraphics(950, 450, JAVA2D);

    hpg.beginDraw();

    background(250);
    hpg.smooth();
    urbanGround.pgDisplay(hpg);
    constructedBuildings.historyDisplay(hpg);
    hpg.endDraw();

    imageHistory.add(hpg);
    //saveFrame("construction_site_###.png"); 
  }
  
  void pdfSave(){
   // file drawing
    try{
      PGraphics pdf;
      pdf = createGraphics(950, 450, PDF, "construction_site_"+year()+month()+day()+hour()+minute()+second()+".pdf");
  
      pdf.beginDraw();
  
      background(250);
      pdf.smooth();

      constructedBuildings.pgDisplay(pdf);
      urbanGround.pgDisplay(pdf);
      
      pdf.dispose();
      pdf.endDraw();
      
    }
    catch(Exception e){  // saving might fail
    }
  }
}

