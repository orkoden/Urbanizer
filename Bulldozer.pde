class Bulldozer extends Building{
  PImage imageBulldozer;

  float x = width - 110;
  float y = height-110;
  int bulldozerSize;
  Vertex gridPos;

  boolean dragged = false;

  Bulldozer(){
    imageBulldozer = loadImage("Bulldozer.png");
    bulldozerSize = 100;
  }

  void bulldoze(){
    try{
      gridPos = urbanGround.calcMousePos(mouseX,mouseY);
      Building toDestroy = urbanGround.strips[(int)gridPos.x].building;
      int toDestroySizeX = toDestroy.fieldsX;
      for( int i= (int)gridPos.x - toDestroySizeX; i < (int)gridPos.x+toDestroySizeX; i++){
        try{       
          if( urbanGround.strips[i].building == toDestroy){
            // clean strips under building
            urbanGround.strips[i].building = null;
            urbanGround.strips[i].isEmpty = true;
            urbanGround.strips[i].isBuildingRoot = false;
            urbanGround.strips[i].canBuildLighted = true;
          }
        }
        catch(Exception e){  // over edge of ground
          return;  
        }

      }

      // clean ground for lighted buildings
      for(int i = (int)gridPos.x - toDestroySizeX -toDestroy.buildHeight;     i < ((int) gridPos.x + toDestroySizeX + toDestroy.buildHeight) && i < urbanGround.strips.length; i++){  //highlighting
        try {
          urbanGround.strips[i].canBuildLighted = true;
        }
        catch(Exception e){
        }
      }

      // play bulldozing sound
      constructedBuildings.removeBuilding(toDestroy);
      bulldozerSound();
    }
    catch(Exception e){  // can't bulldozer, not over grid
    }  
  }

  boolean over(){  // test for mouse over
    if (mouseX >= x && mouseX <= x+bulldozerSize && 
      mouseY >= y && mouseY <= y+bulldozerSize) {
      return true;
    } 
    else {
      return false;
    }
  }

  void release(){
    x = width - 110;
    y = height-110;
    dragged = false;
  }

  void display(){
    if (dragged)  {
      x = mouseX;
      y = mouseY-bulldozerSize*0.8;
    }      
    image(imageBulldozer, x,y, bulldozerSize, bulldozerSize);

  }

}







