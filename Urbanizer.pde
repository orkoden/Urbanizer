
// sound api
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
// end sound api

Minim minim;
AudioSnippet constructionSound;
AudioSnippet buildingFailedSound;
AudioSnippet bulldozerSound;


ItemBox itemBox;
Building draggedBuilding;  // currently dragged building

Building[] buildingPlans;  // store building templates

BuildingCounter constructedBuildings; 

UrbanGround urbanGround;
ImageHistory imageHistory;


void setup()
{
  size(1024,768); // final size for presentation
  smooth();  
  background(240);
  buildingsFromFile();    // read from file
  itemBox = new ItemBox(80);

  urbanGround = new UrbanGround();

  constructedBuildings = new BuildingCounter();

  minim = new Minim(this);
  // load a file into an AudioSnippet
  constructionSound = minim.loadSnippet("constructionsound.mp3");
  buildingFailedSound = minim.loadSnippet("cantbuild.mp3");
  imageHistory = new ImageHistory();
}

void stop()
{
  // always close Minim audio classes
  constructionSound.close();
  buildingFailedSound.close();
  // always stop Minim before exiting
  minim.stop();

  super.stop();
}


void draw()
{
  background(250);


  try{ // draw first for quick graphics update
    draggedBuilding.draw();
  }
  catch(Exception ex){
  }

  urbanGround.display();
  imageHistory.display();
  itemBox.draw();
  try{
    draggedBuilding.draw();
  }
  catch(Exception ex){
  }

  constructedBuildings.display();

}


void mouseReleased(){
  if(draggedBuilding != null){  // if a building is being dragged
    // check if bulding can be put here
    if (  urbanGround.mouseOver(mouseX, mouseY)){
      urbanGround.dropBuilding(draggedBuilding, mouseX,mouseY);
      println(draggedBuilding.name + " built");
    }
    draggedBuilding = null;          // no building dragged anymore
  }
}


void mouseDragged(){
  try{
    //    ground.mouseOverField();
    urbanGround.mouseOver(mouseX, mouseY);
    draggedBuilding.setCenter(mouseX,mouseY);
    //   draggedBuilding.draw();
  }
  catch(Exception e){
  }
}



void keyPressed(){
  if (key == 's') { // press s to save current image to file
 
 // file drawing
    PGraphics pg;
    pg = createGraphics(950, 450, JAVA2D);

    pg.beginDraw();

    background(250);
    pg.smooth();
    constructedBuildings.pgDisplay(pg);
    urbanGround.pgDisplay(pg);
    pg.endDraw();

    pg.save("construction_site_"+year()+month()+day()+hour()+minute()+second()+".png");

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
  if (key == 'n')  // press n for new build phase
    setup();

}



























