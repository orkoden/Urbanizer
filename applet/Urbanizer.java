import processing.core.*; 
import processing.xml.*; 

import processing.pdf.*; 
import ddf.minim.signals.*; 
import ddf.minim.*; 
import ddf.minim.analysis.*; 
import ddf.minim.effects.*; 

import java.applet.*; 
import java.awt.*; 
import java.awt.image.*; 
import java.awt.event.*; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class Urbanizer extends PApplet {

/** Urbanizer
 * Eine interaktive St\u00e4dtebausimulation.
 *
 *
 * Entstanden im Rahmen der Diplomarbeit "Offenes Planungssytem f\u00fcr den Wriezener Bahnhof" 
 * von Paul Lambeck und Philipp Kei\u00df in Architektur an der TU Berlin.
 *
 * Dieses Programm darf beliebig kopiert und weitergegeben werden.
 *
 * Alle Rechte vorbehalten. 
 * 
 * Programmierung \u00a9 2009 J\u00f6rg B\u00fchmann   joergbuehmann@web.de
 * Bild und Tondaten \u00a9 2009 Paul Lambeck   p_lambeck@yahoo.de  
 */




// sound api




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

public void setup()
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

public void stop()
{
  // always close Minim audio classes
  constructionSound.close();
  buildingFailedSound.close();
  bulldozerSound.close();
  // always stop Minim before exiting
  minim.stop();

  super.stop();
}


public void draw()
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


public void mouseReleased(){
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


public void mouseDragged(){

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

public void mousePressed(){
  showSplash = false;
}


public void keyPressed(){
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






































/**
 * Represents one Building with Attributes.
 */
class Building{

  float x=0;
  float y=0;
  float sizeX=120;    //vistible size. should be calculated from fieldsize in grid * fieldsX
  float sizeY=120;

  int gridUnit = 20;


  PShape buildingShape;
  String name;
  //possible attributes
  int fieldsX = 5;  // the number of fields this building covers in x and y direction
  int fieldsY = 1;
  float centerOffsetY =5;

  int buildHeight = 1;
  boolean lighted = false;  // true if outer facades need lighting

  int groundArea = 0;  // Grundflaeche
  int bgf = 0;  // Bruttogeschossflaeche

  Building(){
    name = "unnamed Building";
    buildingShape = loadShape("bot1.svg");

  }

  Building(String[] fromFile){
    this.name = fromFile[0];
    this.buildingShape = loadShape(fromFile[1]);
    this.fieldsX = PApplet.parseInt(fromFile[2]);
    this.fieldsY = PApplet.parseInt(fromFile[3]);
    this.buildHeight = PApplet.parseInt(fromFile[4]);
    if(fromFile[5].equals("ja"))
      this.lighted = true;

    this.groundArea = PApplet.parseInt(fromFile[6]);
    this.bgf =PApplet.parseInt(fromFile[7]);

    // sizes still don' work correctly. because shape.width depends on fields x and y
    float ratio = buildingShape.height/buildingShape.width;
    sizeX = buildingShape.width/2.0f;
    sizeY = round( sizeX * ratio);

    this.centerOffsetY = centerOffset(fromFile[0]);

    println("new building constructed name: "+ this.name + " fieldsX: "+ this.fieldsX + " fieldsY: "+ this.fieldsY + " height: "+this.buildHeight + " centerOffsetY: " + this.centerOffsetY + " Grundfl\u00e4che: " +this.groundArea);
  }

  Building(String name, PShape buildingShape){
    this.name=name;
    this.buildingShape=buildingShape;
  }

  public float centerOffset(String buildingName){

    if(buildingName.equals("Turm"))
      return 8;
    else if(buildingName.equals("Scheibe"))
      return 4;
    else if(buildingName.equals("Block"))
      return 11;
    else if(buildingName.equals("Patio"))
      return 8;
    else if(buildingName.equals("Reihe"))
      return 4;
    else if(buildingName.equals("Frei"))
      return 8;
    else if(buildingName.equals("Box"))
      return 17;
    else if(buildingName.equals("BoxKlein"))
      return 9;

    else 
      return 7;

  }

  // set draggin position
  public void setCenter(float x, float y){

    // set mouse pointer relative to building, so mouspointer and building point to the same building strip
    this.x = x;        //round(x-sizeX/2);
    this.y = y- sizeY + this.centerOffsetY;
  }  

  public Building clone(){
    Building clone = new Building();
    clone.x = x;
    clone.y = y;
    clone.sizeX=sizeX;
    clone.sizeY=sizeY;
    clone.fieldsX=fieldsX;
    clone.fieldsY=fieldsY;
    clone.buildingShape = buildingShape;
    clone.name = name;
    clone.centerOffsetY = centerOffsetY;
    clone.buildHeight = buildHeight;
    clone.lighted = lighted;
    clone.groundArea = groundArea;
    clone.bgf = bgf;
    return clone;
  }

  public void draw(){
    //    stroke(200);
    //  fill(50);
    shape(buildingShape,x,y,sizeX,sizeY);  //does work 
    // shape(buildingShape,x,y);
  } 

  public void pgDisplay(PGraphics pg){
    pg.shape(buildingShape,x,y,sizeX,sizeY);  //does work 

}

}



class Bulldozer {
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

  public void bulldoze(){
    try{
      gridPos = urbanGround.calcMousePos(mouseX,mouseY);
      Building toDestroy = urbanGround.strips[(int)gridPos.x].building;
      int buildDepth = 0;

      int toDestroySizeX = toDestroy.fieldsX;
      for( int i= (int)gridPos.x - toDestroySizeX; i < (int)gridPos.x+toDestroySizeX; i++){
        try{       
          if( urbanGround.strips[i].building == toDestroy){
            // clean strips under building
            urbanGround.strips[i].building = null;
            urbanGround.strips[i].isEmpty = true;
            urbanGround.strips[i].isBuildingRoot = false;
            urbanGround.strips[i].canBuildLighted = true;
            buildDepth = urbanGround.strips[i].buildToDepth;
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
      constructedBuildings.removeBuilding(toDestroy, buildDepth);
      bulldozerSound();
    }
    catch(Exception e){  // can't bulldozer, not over grid
    }  
  }

  public boolean over(){  // test for mouse over
    if (mouseX >= x && mouseX <= x+bulldozerSize && 
      mouseY >= y && mouseY <= y+bulldozerSize) {
      return true;
    } 
    else {
      return false;
    }
  }

  public void release(){
    x = width - 110;
    y = height-110;
    dragged = false;
  }

  public void display(){
    if (dragged)  {
      x = mouseX;
      y = mouseY-bulldozerSize*0.8f;
    }      
    image(imageBulldozer, x,y, bulldozerSize, bulldozerSize);

  }

}








/**  Calculates statistical data
 */

class BuildingCounter extends ArrayList{

  int[] buildingCounter;

  String[] nameList = {
    "Turm","Scheibe","Block","Patio","Reihe","Frei","Box","BoxKlein", "Andere"
  };

  // text position
  float x = 10;
  float y = 40;
  PFont font;
  PFont fontBig;

  BuildingCounter(){
    super();
    buildingCounter = new int[nameList.length -1];  // dont count andere buildings

    font = loadFont("DIN_1451_Mittelschrift-30.vlw");
    fontBig = loadFont("DIN_1451_Mittelschrift-80.vlw");
  }

  public int getIndexForName(String buildingName){
    for (int i=0; i < nameList.length; i++){
      if (nameList[i].equals(buildingName)){
        return i;
      }
    }
    
    return -1;  // building name not found
  }

  public void addBuilding(Building building, int buildDepth){
   int index = getIndexForName(building.name);
    if (index < 0)  // return if building is of type andere
        return;
        
    if (index == 0){  // building is a tower
      buildingCounter[index] += (1+( buildDepth /(building.fieldsY + 10)));
    }
    else {
       buildingCounter[index] += buildDepth / building.fieldsY;
    }
  }
  
  
  public void removeBuilding(Building building, int buildDepth){
   int index = getIndexForName(building.name);
    if (index < 0)  // return if building is of type andere
        return;
        
    if (index == 0){  // building is a tower
      buildingCounter[index] -= (1+( buildDepth /(building.fieldsY + 10)));
    }
    else {
       buildingCounter[index] -= buildDepth / building.fieldsY;
    }
    
    if (buildingCounter[index] < 0)
      buildingCounter[index] =0;
  }

  

  public void toConsole(){
    for(int i=0; i < buildingCounter.length; i++){
      print(nameList[i] + ": " + buildingCounter[i] + " ");
    }

  }

  public void display(){
    fill(50);
    textFont(font, 30);
    
    float[] values = this.densityCalc();

    text("BGF: "+values[0] + " m\u00b2    Bebaute Fl\u00e4che: " + values[1] + " m\u00b2    GFZ: "+ values[2], x, y);
  }

  public void pgDisplay(PGraphics pg){
    pg.fill(50);
    pg.textFont(font, 30);
    float[] values = this.densityCalc();
    pg.text("BGF: "+values[0] + " m\u00b2    Bebaute Fl\u00e4che: " + values[1] + " m\u00b2    GFZ: "+ values[2], x, y);

  }
  
  public void historyDisplay(PGraphics pg){
     float[] values = this.densityCalc();
     pg.fill(50);
     pg.textFont(fontBig, 80);
     float yy = y;
    y += 80;
    pg.text("GFZ: "+ values[2], x, y);
    y = yy;
  }
  
  public float[] densityCalc(){
    
    int bgf =0;
    int areabuilt = 0;

    for(int i=0; i < buildingCounter.length; i++){
      bgf += buildingCounter[i]*buildingPlans[i].bgf;
      areabuilt += buildingCounter[i]*buildingPlans[i].groundArea;
      // println("GA: "+buildingPlans[i].groundArea);
    }
    float gfz = bgf/52900.0f;
    gfz = round(gfz*100);
    gfz/= 100;
    
    float[] values = new float[3];
    values[0] = bgf;
    values[1] = areabuilt;
    values[2] = gfz;
    
    return values;
  }
}
























/*
Liest zur Zeit nur Dateien mit gerader Zeilenzahl erfolgreich aus
 
 */
public void buildingsFromFile(){
  int recordCount = 0;
  String[] lines = loadStrings("typos.tsv");      // jede Array Zelle enth\u00e4lt eine Zeile text
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
  
  public void pdfSave(){
   // file drawing
    try{
      PGraphics pdf;
      pdf = createGraphics(950, 450, PDF, "construction_site_"+year()+month()+day()+hour()+minute()+second()+".pdf");
      pdf.textMode(SHAPE);
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


/**  An itemBox contains several clickable buttons

*/
class ItemBox{
  int x,y = 10; 
  int boxWidth = 100;
  int boxHeight = 100;
  Button[] buildingButtons;
  int numberOfBuildingButtons;
  int buttonSize = 50;

  ItemBox(){
    this(50);
  }


  ItemBox(int buttonSize){
    this.buttonSize=buttonSize;

    boxWidth = buttonSize;
    x= width -10 - boxWidth;
    numberOfBuildingButtons = buildingPlans.length;
    boxHeight = buttonSize * numberOfBuildingButtons;
    buildingButtons = new Button[numberOfBuildingButtons];

    for( int i= 0; i < numberOfBuildingButtons; i++){  // zeilen
      //      for( int j= 0; j<1; j++){                          // spalten
      buildingButtons[i] = new BuildingButton(x,y+buttonSize*i, buttonSize, buildingPlans[i]);
    }
    //    }
  }
  public void draw(){
    for( int i= 0; i < numberOfBuildingButtons; i++){  // draw all buttons

      buildingButtons[i].draw(); 
    }
  }

}

/** generic class to create a square button, that changes color on mouseover  */
class Button{
  int buttonSize = 50;
  int x, y;            // on screen position
  int buttonColor;  
  int borderColor;
  int highlightColor;
  int currentColor;
  boolean over = false;

  Button(int x, int y){
    this(x,y,50);
  }
  Button(int x, int y, int buttonSize){
    this.buttonSize = buttonSize;
    this.x=x;
    this.y=y;
    buttonColor = color(200);
    borderColor = color(255);
    highlightColor = color(100);
    currentColor = buttonColor;
  }

  public void draw(){
    this.update();
    stroke(borderColor);
    fill(currentColor);
    rect(x,y,buttonSize, buttonSize);
  }

  public void update()   // update color depending on mouseover
  {
    if(over()) {
      currentColor = highlightColor;
    } 
    else {
      currentColor = buttonColor;
    }
  }
  public boolean over(){  // test for mouse over
    if (mouseX >= x && mouseX <= x+buttonSize && 
      mouseY >= y && mouseY <= y+buttonSize) {
      return true;
    } 
    else {
      return false;
    }
  }
}

class BuildingButton extends Button{
  Building building;
  PShape shape;
  BuildingButton(int x, int y){
    this(x,y,50);
  }

  BuildingButton(int x, int y, int buttonSize){
    super(x,y, buttonSize);
    building = new Building();
  }
  BuildingButton(int x, int y, int buttonSize, Building building){
    super(x,y, buttonSize);
    this.building = building;
  }

  public void draw(){
    super.draw();
    // println("Drawing: " + building.name);
    float ratio = building.buildingShape.height/building.buildingShape.width;
    float drawX; 
    float drawY;
    float distY;
    float distX;
    
    if (ratio < 1){  // width > height
      drawX = buttonSize-10;
      drawY = drawX*ratio;
    }
    else{  // width < height
      drawY = buttonSize-10;
      drawX = drawY/ratio;
    }
    
  distX = x + buttonSize/2.0f - drawX/2.0f;
  distY = y + buttonSize/2.0f - drawY/2.0f;

    shape(building.buildingShape,distX,distY,drawX,drawY);
  }

  public void update(){
    super.update();
    if (over() && mousePressed){            // test if this button is clicked
      draggedBuilding = building.clone(); // create draggable building
      draggedBuilding.setCenter(mouseX,mouseY);  
     
    }
  }

}





class Vertex{
  float x;
  float y;

  Vertex(float x, float y){
    this.x = x;
    this.y = y;
  }

  public void rotate(){
    float xx = this.x;
    float yy = this.y;
    this.x = xx + yy * -tan(49.0f*PI/180.0f);
    this.y = xx * tan(16.0f*PI/180.0f) + yy;
  }
  public void normalize(){
    float veclength = sqrt(x*x + y*y);
    x/=veclength;
    y/=veclength;
  }

  // transform to new coordinate system with the base vectors x2 and y2
  public void transform(Vertex x2, Vertex y2){
    float xx = this.x;
    float yy = this.y;
    this.x = xx * x2.x + yy * y2.x;
    this.y = xx * x2.y + yy * y2.y;

    this.x+= 210;
    this.y+= 150;
  }

  public void transformBack(Vertex x2, Vertex y2){
    this.x-= 210;
    this.y-= 150;

    float xx = this.x;
    float yy = this.y;

    this.y = ( yy * x2.x - xx * x2.y) / ( y2.y * x2.x - y2.x * x2.y);
    this.x = ( xx - this.y * y2.x) / x2.x;
  }

  public void scale(float f){
    this.x *= f; 
    this.y *= f;
  }

}












/**  Stores the last saved images and displays them at the bottom
 * 
 */

class ImageHistory extends ArrayList{
  ImageHistory(){
    super(5);
  }


  public boolean add(Object object){
    if(super.size() > 3)
      super.remove(0);
    return super.add(object);
  }

  public void display(){
    PImage img;
    float ratio;
    try{  
      float drawwidth = width/super.size();
      if(drawwidth == width)
        drawwidth = width/2;
      for(int i=0; i < super.size(); i++){
        img = (PImage)super.get(i);
        ratio = img.width/img.height;
        image(img,10+drawwidth*i,height-drawwidth/ratio - 10, drawwidth,drawwidth/ratio);
      }
    }

    catch(Exception e){
    }
  }
}









public void constructionSound(){

    constructionSound.rewind();
    constructionSound.play();
}

public void buildingFailedSound(){

    buildingFailedSound.rewind();
    buildingFailedSound.play();
}


public void bulldozerSound(){

    bulldozerSound.rewind();
    bulldozerSound.play();
}
class Splash{
  PFont fontBig;
  PFont fontSmall;
  
  Splash(){
    fontBig = loadFont("DIN_1451_Mittelschrift-80.vlw");
    fontSmall = loadFont("DIN_1451_Mittelschrift-30.vlw");
    this.display();
  }
  
  public void display(){
    textFont(fontBig, 80);
    text("Urbanizer",50, 500);
    textFont(fontSmall, 30);
    text("Taste [s] Zustand speichern\nTaste [n] nochmal von vorne", 50, 600);
  }

}


// base vectors for coordination transformation
Vertex x2;
Vertex y2;
int gridSize = 8/2;


class UrbanGround{

  UrbanStrip[] strips;
  int numberOfStrips = 93;




  UrbanGround(){

    calcBaseVectors();  // base vectors for drawing the geometry

    strips = new UrbanStrip[93];
    int currentStripLength= 0;
    float xPosMin;
    float xPosMax;
    float yPosMin;
    float yPosMax;

    // create strips with certain lengths
    for ( int i = 0; i< strips.length ; i++){
      // ### assign strip length
      if (i<9)
        currentStripLength = 46;
      else if(i <37)
        currentStripLength = 8;
      else if (i ==  37)
        currentStripLength = 34;
      else if(i<49)
        currentStripLength = 8;
      else if(i<59)
        currentStripLength = 22;
      else if (i<71)
        currentStripLength = 8;
      else if (i<77)
        currentStripLength = 13;
      //     else if (i < 79)
      //       currentStripLength = 22;
      else if (i<93){
        currentStripLength =(int)round( (92-i)*(8.0f/16) +14);
      }
      // ### end assign strip length
      strips[i] = new UrbanStrip(currentStripLength);
    }   

    // mark strips with border
    int[] borderStrips = {
      8, 36,37,48, 58, 70, 76                };
    for (int i= 0; i < borderStrips.length; i++){
      strips[borderStrips[i]].hasBorder = true;
    }
    // calculate corners for strips
    for ( int i = 0; i< strips.length ; i++){

      // ### begin corner calculation
      xPosMin = i*gridSize; 
      xPosMax = (1+i)*gridSize; 
      yPosMin =  0 ; 
      yPosMax = strips[i].stripLength*gridSize; 

      Vertex topleft = new Vertex(xPosMin, yPosMin);      
      Vertex topright = new Vertex(xPosMax, yPosMin);
      Vertex bottomright = new Vertex(xPosMax, yPosMax);
      Vertex bottomleft = new Vertex(xPosMin, yPosMax);

      topleft.transform(x2,y2);
      topright.transform(x2,y2);
      bottomright.transform(x2,y2);
      bottomleft.transform(x2,y2);

      // ### end corner calculation

      Vertex[] corners = new Vertex[4];
      corners[0] = topleft;
      corners[1] = topright;
      corners[2] = bottomright;
      corners[3] = bottomleft;

      strips[i].corners = corners;  // assign corners

    }
    this.allStripsNoHighlight();

  }

  /** Clear removes all buildings
   * 
   */
  public void clear(){
    for(int i=0; i < strips.length; i++){  // reset color for all strips
      strips[i].removeBuilding();
    }
  }

  public void allStripsNoHighlight(){
    for(int i=0; i < strips.length; i++){  // reset color for all strips
      strips[i].nohighlight();
    }
  }

  public boolean mouseOver(float mousePosX, float mousePosY){
    Vertex mousePos;
    try{
      mousePos = this. calcMousePos(mousePosX, mousePosY);
    }
    catch (Exception e){
      this.allStripsNoHighlight();
      return false;
    }

    allStripsNoHighlight();


    // check all strips under the building
    for(int i = (int)mousePos.x; i < ((int) mousePos.x + draggedBuilding.fieldsX) && i < strips.length; i++){  //highlighting
      strips[i].highlight();  // green or red highlight

        for(int j = i - draggedBuilding.buildHeight; j < i  + draggedBuilding.buildHeight +1 ; j++){  // check left and right to dragged building
        try{   
          if (strips[j].building.lighted ){
            strips[i].currentColor = strips[i].highlightRed;
          }
        }
        catch(Exception e){
        }
      }
    }
    return true;
  }

  /** tries to build the droppedBuilding onto the strips corresponding to mouse position
   * 
   */
  public void dropBuilding(Building droppedBuilding, float mousePosX, float mousePosY){

    Vertex mousePos;
    try{
      mousePos = this. calcMousePos(mousePosX, mousePosY);
    }
    catch (Exception e){  
      this.allStripsNoHighlight();

      return;
    }

    // test if it can be built here
    for(int i = (int)mousePos.x; i < ((int) mousePos.x + draggedBuilding.fieldsX) && i < strips.length; i++){  // for all strips under building
      //check if there are lighted buildings in the neighborhood
      for(int j = i - draggedBuilding.buildHeight; j < i  + draggedBuilding.buildHeight +1; j++){
        try{   
          if (strips[j].building.lighted){
            this.allStripsNoHighlight();
            buildingFailedSound();
            return;
          }
        }
        catch(Exception e){
        }
      }

      if(!strips[i].isEmpty ||                                   // check if strip is free
      (strips[i].hasBorder && (i < ((int) mousePos.x + draggedBuilding.fieldsX -1) ) ) ||   // check if building is crossing a border
      mousePos.x + draggedBuilding.fieldsX > strips.length  ||  // check for right edge of Urbanground
      strips[i].stripLength < draggedBuilding.fieldsY ||        //  check if all strips under building are long enough
      (draggedBuilding.lighted && !strips[i].canBuildLighted)   //check if building is lighted and ground allows lighted building  
      ){
        buildingFailedSound();

        this.allStripsNoHighlight();
        return;  // cannot build so return
      }
    }



    // build building
    int buildToDepth = 100000;  // how deep in y direction can the building be built
    for(int i = (int)mousePos.x; i < ((int) mousePos.x + draggedBuilding.fieldsX) && i < strips.length; i++){  //highlighting
      if (buildToDepth > strips[i].stripLength )  // find shortest strip
        buildToDepth = strips[i].stripLength;
    }

    for(int i = (int)mousePos.x; i < ((int) mousePos.x + draggedBuilding.fieldsX) && i < strips.length; i++){  //highlighting
      if (i == (int)mousePos.x) strips[i].isBuildingRoot = true;  // set first strip as root for building
      strips[i].setBuilding(draggedBuilding, buildToDepth);        // set building to all strips
      strips[i].nohighlight();
    }

    // adjust neighboring strips to disallow lighted building
    for(int i = (int)mousePos.x - draggedBuilding.buildHeight; 
    i < ((int) mousePos.x + draggedBuilding.fieldsX + draggedBuilding.buildHeight) && i < strips.length; i++){  //highlighting
      try {
        strips[i].canBuildLighted = false;
      }
      catch(Exception e){
      }
    }
    constructionSound();
    constructedBuildings.addBuilding(draggedBuilding, buildToDepth);
    constructedBuildings.toConsole();
  }

  /** calculate Array position from mouse coordinates
   */
  public Vertex calcMousePos(float mousePosX, float mousePosY) throws Exception{
    Vertex mousePos = new Vertex(mousePosX, mousePosY);
    mousePos.transformBack(x2,y2);

    mousePos.x /= gridSize;
    mousePos.y /= gridSize;
    //   println("strip x: " +mousePos.x + " y: " + mousePos.y);
    mousePos.x = floor(mousePos.x);
    mousePos.y = floor(mousePos.y);
    // check boundaries
    if (mousePos.x < 0 || mousePos.x >= strips.length)  // check x boundaries
      throw new Exception() ;
    else if(mousePos.y < 0 || mousePos.y >= strips[(int)mousePos.x].stripLength){  // check strip length boundaries
      throw new Exception() ;  
    }
    return mousePos;
  }

  public void display(){
    stroke(220);
    fill(120);

    for ( int i = strips.length-1; i >= 0 ; i--){
      strips[i].display();
    }

    for(int i=0; i < strips.length; i++){  
      strips[i].displayBuilding();
    }

  }

  public void pgDisplay(PGraphics pg){
    pg.stroke(220);
    pg.fill(120);

    for ( int i = strips.length-1; i >= 0 ; i--){
      strips[i].pgDisplay(pg);
    }

    for(int i=0; i < strips.length; i++){  
      strips[i].pgDisplayBuilding(pg);
    }

  }

  public void calcBaseVectors(){
    x2 = new Vertex(1,0);
    y2 = new Vertex(0,1);
    x2.rotate();
    y2.rotate();
    x2.normalize();
    y2.normalize();
    x2.scale(2);
    y2.scale(2*0.72f);
  }

}

/** Represents one strip of the construction site
 */

class UrbanStrip{
  Building building;
  boolean isBuildingRoot = false;    // the leftmost building is its root and responsible for drawing it
  int buildToDepth;                   // how deep can the building be built here

  int stripLength = 0;
  boolean isEmpty = true;          // is the strip empty
  boolean canBuildLighted = true;  // can a lighted building be constructed here

    Vertex[] corners;          // has to be clockwise starting with top left corner
  boolean hasBorder = false;  // true if the right side of this strip is a border, that can't be built over
  int currentBorderColor;
  int normalBorderColor;

  int fillColor;
  int highlightRed;
  int highlightGreen;
  int currentColor;

  UrbanStrip(int stripLength){
    this.stripLength = stripLength;
    fillColor = color(200);
    highlightRed = color(255,100,100) ;
    highlightGreen =  color(100,255,100);
    normalBorderColor = color(150);
    currentBorderColor = normalBorderColor;
  }

  UrbanStrip(int stripLength, Vertex[] corners){
    this(stripLength);
    this.corners = corners;
  }


  public void setBuilding(Building building, int buildToDepth){
    this.building = building;
    this.buildToDepth = buildToDepth;
    this.isEmpty = false;
    this.canBuildLighted = false;

    if (this.isBuildingRoot) 
      this.building.setCenter((int) (corners[0].x + y2.x * this.building.fieldsY * gridSize), 
      (int)(corners[0].y + y2.y * this.building.fieldsY * gridSize));

  }
  public void removeBuilding(){
    this.building = null;
    this.isEmpty = true;
  }

  public void display(){
    // display strip
    fill(currentColor);
    stroke(190);
    quad(corners[0].x, corners[0].y,
    corners[1].x, corners[1].y,
    corners[2].x, corners[2].y,
    corners[3].x, corners[3].y
      );

    if(hasBorder){  // draw right border
      stroke(currentBorderColor);
      line(corners[1].x, corners[1].y,   corners[2].x, corners[2].y);
    }
  }


  public void displayBuilding(){
    if (!isEmpty && this.isBuildingRoot){   
      // display building
      //this.building.draw(this.stripLength / this.building.fieldsY);

      // copy building position
      float buildX = this.building.x;
      float buildY = this.building.y;

      if (this.building.name.equals("Turm")){
        //this.building.draw();
        Vertex towerPos = new Vertex(corners[0].x, corners[0].y);
        for (int i = 0; i <= buildToDepth / (this.building.fieldsY + 10); i++){
          this.building.setCenter(corners[0].x + y2.x * ((this.building.fieldsY+ 10)*(i+1) -10) * gridSize, 
          corners[0].y + y2.y * ((this.building.fieldsY+10)*(i+1) -10)* gridSize);
          this.building.draw();
        }
      }

      else for (int i = 0; i< buildToDepth / this.building.fieldsY; i++){
        this.building.setCenter((corners[0].x + y2.x * this.building.fieldsY* (i+1) * gridSize), 
        (corners[0].y + y2.y * this.building.fieldsY *(i+1)* gridSize));
        this.building.draw();
      }

      // reset building view position to original pos
      this.building.x = buildX;
      this.building.y = buildY;
    }
  }


  public void pgDisplay(PGraphics pg){
    // display strip
    pg.fill(currentColor);
    pg.stroke(190);
    pg.quad(corners[0].x, corners[0].y,
    corners[1].x, corners[1].y,
    corners[2].x, corners[2].y,
    corners[3].x, corners[3].y
      );

    if(hasBorder){  // draw right border
      pg.stroke(currentBorderColor);
      pg.line(corners[1].x, corners[1].y,   corners[2].x, corners[2].y);
    }


  }

  public void pgDisplayBuilding(PGraphics pg){
    // drawing buildings

    if (!isEmpty && this.isBuildingRoot){   
      // display building
      // copy building position
      float buildX = this.building.x;
      float buildY = this.building.y;

      if (this.building.name.equals("Turm")){
        //this.building.draw();
        Vertex towerPos = new Vertex(corners[0].x, corners[0].y);
        for (int i = 0; i <= buildToDepth / (this.building.fieldsY + 10); i++){
          this.building.setCenter(corners[0].x + y2.x * ((this.building.fieldsY+ 10)*(i+1) -10) * gridSize, 
          corners[0].y + y2.y * ((this.building.fieldsY+10)*(i+1) -10)* gridSize);
          this.building.pgDisplay(pg);
        }
      }

      else for (int i = 0; i< buildToDepth / this.building.fieldsY; i++){
        this.building.setCenter((corners[0].x + y2.x * this.building.fieldsY* (i+1) * gridSize), 
        (corners[0].y + y2.y * this.building.fieldsY *(i+1)* gridSize));
        this.building.pgDisplay(pg);
      }

      // reset building view position to original pos
      this.building.x = buildX;
      this.building.y = buildY;
    } 
  }

  public void highlight(){
    if (hasBorder)
      currentBorderColor = highlightRed;

    if (isEmpty && draggedBuilding.lighted && canBuildLighted || isEmpty && !draggedBuilding.lighted)
      currentColor = highlightGreen;
    else
      currentColor = highlightRed;
  }

  public void nohighlight(){
    currentColor = fillColor;
    currentBorderColor = normalBorderColor;
  }
}


















































































  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#FFFFFF", "Urbanizer" });
  }
}
