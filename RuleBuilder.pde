
// sound api
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
// end sound api

Minim minim;
AudioSnippet constructionSound;



ItemBox itemBox;
Building draggedBuilding;

Building[] buildingPlans;  // store building templates

UrbanGround urbanGround;

void setup()
{
  size(1024,768); // final size for presentation
  smooth();  
  background(240);
  buildingsFromFile();    // read from file
  itemBox = new ItemBox(80);

  urbanGround = new UrbanGround();
  
  
  
    minim = new Minim(this);
  // load a file into an AudioSnippet
  // it must be in this sketches data folder
  constructionSound = minim.loadSnippet("constructionsound.mp3");

}

void stop()
{
  // always close Minim audio classes
  constructionSound.close();
  // always stop Minim before exiting
  minim.stop();
 
  super.stop();
}


void draw()
{
  background(250);
  urbanGround.display();

  itemBox.draw();
  try{
     draggedBuilding.draw();
  }
  catch(Exception ex){
  }



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

  }
  catch(Exception e){
  }
}



void keyPressed(){
  if (key == 's')  // press s to save current image to file
    saveFrame("construction_site_###.png"); 
  if (key == 'n')  // press n for new build phase
    setup();
    
      if ( key == 'p' )
  {
    constructionSound.play();
  }

}


















