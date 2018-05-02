import java.util.*;
import java.util.Comparator;
float avoidRadius = 25;
float nearestRaius  =60;
float crowdRadius = 50;


class Boid2D {
  ArrayList<Boid2D> neighbourboids2D = new ArrayList<Boid2D>();
  int iter;
  PVector position;
  PVector velocity;
  PVector acceleration;
  float r;
  //float maxce = 0.1;    // Maximum steering force
  float maxforce = 0.1;
  float maxspeed=3.0;    // Maximum speed
  float flap = 0;
  float t = 0;

  float col1 = 255;//random(0,255);
  float col2 = 190;//random(0,255);
  float col3 = 175;//random(0,255);
  float h = 67;
  Boid2D(float x, float y) {
    acceleration = new PVector(0,0);
    velocity = new PVector(random(-3,3),random(-3,3));
    position = new PVector(x,y);
    r = 4;
    //maxforce = 0.1;
    
  }
  void wrap () {
    position.x = (position.x + width) % width;
    position.y = (position.y + height) % height;
  }

  void applyForce(PVector force) {
      // We could add mass here if we want A = F / M
      acceleration.add(force);
  }
  
  
  PVector avoid(PVector target)
  {
    PVector steer = new PVector(); //creates vector for steering
    steer.set(PVector.sub(position, target)); //steering vector points away from target
    if (true)
      steer.mult(1/sq(PVector.dist(position, target)));
    //steer.limit(maxSteerForce); //limits the steering force to maxSteerForce
    return steer;
  }
  
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, position);  // A vector pointing from the position to the target
    // Normalize desired and scale to maximum speed
    desired.normalize();
    desired.mult(maxspeed);
    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);  // Limit to maximum steering force
    return steer;
}
  
  PVector rule1(){//cohesion
    PVector pc = new PVector(0,0);
    int neighbours=0;
    for(Boid2D other: neighbourboids2D){
        float d = PVector.dist(position, other.position);
        if(d<50){        
          pc.add(other.position);
          neighbours++;
      }
    }
    if (neighbours >0) {
      pc.div(neighbours);
    //return seek(pc);
    return pc.setMag(0.5);
    }
    return new PVector(0,0);//.normalize();
  }

  PVector rule2(){//separation
    PVector c = new PVector(0,0);
    int count=0;
    for(Boid2D other: neighbourboids2D){
        float d = PVector.dist(position, other.position);
        if(d>0 && d<25){
          PVector  br = PVector.sub(position, other.position);
          br.normalize();
          br.div(d);
          c.add(br);
          count++;  
      }
      
    }
    
    if (count > 0) {
      c.div((float)count);
    }

    if (c.mag() > 0) {
      c.normalize();
      c.mult(maxspeed);
      c.sub(velocity);
      c.limit(maxforce);
    }

    return c;
  }

  PVector rule3(){ // Alginment
    PVector pv = new PVector(0,0);
    int neighbours=0;
    for(Boid2D other: neighbourboids2D){
      //if(this!= other){
        float d = PVector.dist(position, other.position);
        if( d<60){
          //pv.add(velocity);
        PVector temp  = new PVector(other.position.x,other.position.y) ;
        temp.normalize();
        temp.div(d); 
        pv.add(temp);
        neighbours++;
        //}
      }
    }

  //if (neighbours > 0) {
  //      pv.div((float)neighbours);
  //      pv.normalize();
  //      pv.mult(maxspeed);
  //      PVector steer = PVector.sub(pv, velocity);
  //      steer.limit(maxforce);
  //      return steer;
  //    } 
  //    else {
  //      return new PVector(0, 0);
  //}  
  return pv;
}

PVector rule4() {//avoidance
    PVector steer = new PVector(0, 0);
    int count = 0;

    for (Boid2D other : neighbourboids2D) {
      float d = PVector.dist(position, other.position);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < avoidRadius)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(position, other.position);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    if (count > 0) {
      //steer.div((float) count);
    }
    return steer;
  }
  
  PVector roost() {
    PVector roostPos= new PVector(width/2,height/2,600);
    
    //calculate vertical force
    float vertWeight=0.0003;
    PVector steer=new PVector(0,0);
    steer.y=roostPos.y-position.y;
    steer.y=steer.y*vertWeight;
    
    //calculate horizontal force
    float horiWeight=0.01;
    PVector modPos=new PVector(0,0);
    modPos.x=position.x;
    modPos.y=0;
    modPos.z=position.z;
    PVector modPosDiff=new PVector(0,0);
    modPosDiff.add(roostPos);
    modPosDiff.sub(modPos);
    modPosDiff.y=0;
    modPosDiff.normalize();
    modPosDiff.mult(horiWeight);  
    steer.add(modPosDiff);
    return steer;
  }
  
ArrayList<Boid2D>  nearestNeighbours() {
  ArrayList<Boid2D>  closestBoids=new ArrayList<Boid2D>(); // copy-constructor to avoid reaching out of our scope
  for (int i = 0; i<boids2D.size(); i++){
    Boid2D temp_boid = boids2D.get(i);
    //System.out.println(temp_boid.position.x);
    //System.out.println(temp_boid.position.y);
    //System.out.println(this.position.x);
    //System.out.println(this.position.x);
    
    if (abs(temp_boid.position.x - this.position.x) < 250 &&  abs(temp_boid.position.y - this.position.y) < 250) {
      if (temp_boid != this){  
        closestBoids.add(temp_boid);
      }
    }
  }
  return closestBoids;
}
  void update() {
    if (iter>10){
      neighbourboids2D = nearestNeighbours(); 
      iter = 0;
    }
    else iter ++;
     
    //System.out.println ( neighbourboids2D.size());
    PVector v1 = this.rule1();//cohesion
    PVector v2 = this.rule2();//separation
    PVector v3 = this.rule3();//alignment
    PVector v4 = this.rule4();//avoidance
    //PVector v4= this.roost();
    
    
   
    applyForce(v1.mult(1));
    applyForce(v2.mult(1));
    applyForce(v3.mult(10));
    applyForce(v4.mult(1));
    acceleration.limit(maxforce);
    velocity.add(acceleration);
    //velocity.add(bound_position());
    velocity.limit(maxspeed);
    //velocity.add(wind);
    position.add(velocity);
    acceleration.mult(0);
    wrap();
  }

//  PVector bound_position(){
//    int Xmin=0, Xmax=width, Ymin=0, Ymax=height;// Zmin, Zmax
//    PVector v=new PVector(0,0);

//    if( this.position.x < Xmin) 
//      v.x = 0.10;
//    else if (this.position.x > Xmax)
//      v.x = -0.10;
      
//    if (this.position.y < Ymin)
//      v.y = 0.10;
//    else if (this.position.y > Ymax)
//      v.y = -0.10;
    
//    //if (b.position.z < Zmin)
//    //  v.z = 10;
//    //else if ( b.position.z > Zmax)
//    //  v.z = -10;
    
//    return v;
//  }
  

  // void applyForce(PVector force) {
  //   // We could add mass here if we want A = F / M
  //   acceleration.add(force);
  // }

  // A method that calculates a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  // void seek(PVector target) {
  //   PVector desired = PVector.sub(target,position);  // A vector pointing from the position to the target
    
  //   // Scale to maximum speed
  //   desired.setMag(maxspeed);

  //   // Steering = Desired minus velocity
  //   PVector steer = PVector.sub(desired,velocity);
  //   steer.limit(maxforce);  // Limit to maximum steering force
    
  //   applyForce(steer);
  // }
    
  void display() {
    // Draw a triangle rotated in the direction of velocity
    float theta = velocity.heading2D() + PI/2;
    fill(127);
    stroke(0);
    strokeWeight(1);
    pushMatrix();
    translate(position.x,position.y);
    rotate(theta);
    beginShape();
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
    endShape(CLOSE);
    popMatrix();
      
  }

}
