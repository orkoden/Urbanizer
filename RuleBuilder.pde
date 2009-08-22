
ItemBox itemBox;
Building draggedBuilding;
Ground ground;
Building[] buildingPlans;  // store building templates

ArrayList displayedBuildings;

UrbanGround urbanGround;

void setup()
{
  //  size(1925,600);
  size(1024,768); // final size for presentation
  smooth();  
  background(240);
  buildingsFromFile();    // read from file
  itemBox = new ItemBox(80);

  urbanGround = new UrbanGround();

  displayedBuildings = new ArrayList();

  // ground = new Ground(10,5,60);
  //button = new Button(10,10);
}


void draw()
{
  background(250);
  urbanGround.display();
  // ground.draw();

  for (int i = displayedBuildings.size()-1; i >= 0; i--) { 
    Building build = (Building) displayedBuildings.get(i);
    build.draw();
  }

  itemBox.draw();
  try{
    //   println("draggin"+draggedBuilding.name);
    draggedBuilding.draw();
  }
  catch(Exception ex){
  }

}


void mouseReleased(){
  if(draggedBuilding != null){  // if a building is being dragged
    // check if bulding can be put here
    //    ground.dropped(draggedBuilding);
    if (  urbanGround.mouseOver(mouseX, mouseY)){
     // displayedBuildings.add(draggedBuilding);
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
}
















