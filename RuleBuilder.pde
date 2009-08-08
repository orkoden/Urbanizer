
ItemBox itemBox;
Building draggedBuilding;
Ground ground;
Building[] buildingPlans;  // store building templates

UrbanGround urbanGround;

void setup()
{
  size(1024,768);
  smooth();  
  background(20);
  buildingsFromFile();    // read from file
  itemBox = new ItemBox(80);

  urbanGround = new UrbanGround();
  // ground = new Ground(10,5,60);
  //button = new Button(10,10);
}


void draw()
{
  background(20);
  urbanGround.display();
  // ground.draw();
  //itemBox.draw();
  try{
    //   println("draggin"+draggedBuilding.name);
    draggedBuilding.setCenter(mouseX,mouseY);
    draggedBuilding.draw();
  }
  catch(Exception ex){
  }

}


void mouseReleased(){
  if(draggedBuilding != null){  // if a building is being dragged
    // check if bulding can be put here
//    ground.dropped(draggedBuilding);
    draggedBuilding = null;          // no building dragged anymore
  }
}


void mouseDragged(){
  try{
//    ground.mouseOverField();
  }
  catch(Exception e){
  }
}



void keyPressed(){
  if (key == 's')  // press s to save current image to file
    saveFrame("construction_site_###.png"); 
}









