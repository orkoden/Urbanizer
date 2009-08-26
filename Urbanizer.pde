/** Urbanizer
 * Eine interaktive Städtebausimulation.
 *
 *
 * Entstanden im Rahmen der Diplomarbeit von Paul Lambeck und Philipp Keiß in Architektur an der TU Berlin.
 *
 * Dieses Programm darf beliebig kopiert und weitergegeben werden.
 *
 * Alle Rechte vorbehalten. 
 * 
 * Programmierung © 2009 Jörg Bühmann   joergbuehmann@web.de
 * Bild und Tondaten © 2009 Paul Lambeck   p_lambeck@yahoo.de  
 */

import processing.pdf.*;


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

Bulldozer bulldozer;

Splash splash;
boolean showSplash = true;

void setup()
{
  size(1024,768, P2D); // final size for presentation
  smooth();
  frameRate(60);  
  background(240);
  splash = new Splash();

  buildingsFromFile();    // read from file
  itemBox = new ItemBox(80);

  urbanGround = new UrbanGround();

  constructedBuildings = new BuildingCounter();

  minim = new Minim(this);
  // load a file into an AudioSnippet
  constructionSound = minim.loadSnippet("constructionsound.mp3");
  buildingFailedSound = minim.loadSnippet("cantbuildbuzz.wav");
  bulldozerSound = minim.loadSnippet("destroy.wav");
  imageHistory = new ImageHistory();

  bulldozer = new Bulldozer();
}

void stop()
{
  // always close Minim audio classes
  constructionSound.close();
  buildingFailedSound.close();
  bulldozerSound.close();
  // always stop Minim before exiting
  minim.stop();

  super.stop();
}


void draw()
{
  background(250);

  if(showSplash)  splash.display();

  //
  try{ // draw first for quick graphics update
    // draggedBuilding.setCenter(mouseX,mouseY);

    draggedBuilding.draw();
  }
  catch(Exception ex){
  }

  urbanGround.display();
  imageHistory.display();
  itemBox.draw();
  try{
    //  draggedBuilding.setCenter(mouseX,mouseY);

    draggedBuilding.draw();
  }
  catch(Exception ex){
  }

  constructedBuildings.display();
  bulldozer.display();

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
  bulldozer.release();
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
  if(bulldozer.over())
    bulldozer.dragged = true;
  if (bulldozer.dragged){
    bulldozer.bulldoze();
    draggedBuilding = null;
  }
}

void mousePressed(){
  showSplash = false;
}


void keyPressed(){
  if (key == 's') { // press s to save current image to file

    // run image savin in a new thread
    ImageSave imageSave = new ImageSave();
    imageSave.run();

  }
  if (key == 'n'){  // press n for new build phase
    setup();
    showSplash = true;  
  }
}






































