/**  Stores the last saved images and displays them at the bottom
 * 
 */

class ImageHistory extends ArrayList{
  ImageHistory(){
    super(5);
  }


  boolean add(Object object){
    if(super.size() > 3)
      super.remove(0);
    return super.add(object);
  }

  void display(){
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









