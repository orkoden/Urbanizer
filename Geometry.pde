class Vertex{
  float x;
  float y;

  Vertex(float x, float y){
    this.x = x;
    this.y = y;
  }

  void rotate(){
    float xx = this.x;
    float yy = this.y;
    this.x = xx + yy * -tan(49.0*PI/180.0);
    this.y = xx * tan(16.0*PI/180.0) + yy;
  }
  void normalize(){
    float veclength = sqrt(x*x + y*y);
    x/=veclength;
    y/=veclength;
  }

  // transform to new coordinate system with the base vectors x2 and y2
  void transform(Vertex x2, Vertex y2){
    float xx = this.x;
    float yy = this.y;
    this.x = xx * x2.x + yy * y2.x;
    this.y = xx * x2.y + yy * y2.y;
    
   this.x+= 200;
   this.y+= 150;
  }
  
  void scale(float f){
    this.x *= f; 
    this.y *= f;
  }
  
}










