
ItemBox itemBox;
Building draggedBuilding;
Ground ground;

void setup()
{
  size(800,500);
  smooth();  
  background(20);
  itemBox = new ItemBox(80);
  ground = new Ground(10,4,60);
  //button = new Button(10,10);
}


void draw()
{
  background(20);

  ground.draw();
  itemBox.draw();
  try{
    //   println("draggin"+draggedBuilding.name);
    draggedBuilding.draw();
  }
  catch(Exception ex){
  }

}

void mouseDragged(){
  try{

    draggedBuilding.setCenter(mouseX,mouseY);
  }  
  catch(Exception ex){
  }
}

void mouseReleased(){
  // check if bulding can be put here
  ground.dropped(draggedBuilding);
  draggedBuilding = null;  // no building dragged anymore
}








