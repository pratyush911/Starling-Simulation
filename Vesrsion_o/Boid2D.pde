import java.util.*;
import java.util.Comparator;


class Boid2D {
  ArrayList<Boid2D> neighbourboids2D = new ArrayList<Boid2D>();
  int iter;
  PVector position;
  PVector velocity;
  PVector acceleration;
  float r;
  //float maxce = 0.1;    // Maximum steering force
  float maxce = 0.1;
  float maxspeed=2.0;    // Maximum speed
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
  
PVector avoidObstacles() {
    PVector steer = new PVector(0, 0);

    for (PVector other : obstacles) {
      float d = PVector.dist(position, other);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < 50)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(position, other);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
      }
    }
    return steer;
}
  
  PVector avoid(PVector target)
  {
    PVector steer = new PVector(); //creates vector for steering
    steer.set(PVector.sub(position, target)); //steering vector points away from target
    
      steer.mult(1/sq(PVector.dist(position, target)));
    //steer.limit(maxSteerForce); //limits the steering force to maxSteerForce
    return steer;
  }
  
  PVector rule1(){//cohesion
    PVector pc = new PVector(0,0);
    int neighbours = 0;
    for(Boid2D other: neighbourboids2D){
        float d = PVector.dist(position, other.position);
        if(d<200 && d!=0){        
          pc.add(other.position);
          neighbours++;
      }
    }
    //int neighbours=neighbourboids3D.size();
    if (neighbours>0){
        pc.div((float)neighbours);
    }
    PVector steer = pc.sub(position);
    steer.limit(maxce);
    return steer;
  }

  PVector rule2(){//separation
    PVector c = new PVector(0,0,0);
    for(Boid2D other: neighbourboids2D){
        float d = PVector.dist(position, other.position);
        if(d>0 && d<200){
          PVector  br = PVector.sub(position, other.position);
          br.normalize();
          br.div(d);
          c.add(br);
        } 
    }
    return c;
  }

  PVector rule3(){ // Alginment
    PVector pv = new PVector(0,0,0);

    int neighbours=0;

    for(Boid2D other: neighbourboids2D){
        float d = PVector.dist(position, other.position);
        if( d<200 && d!=0){
          PVector temp  = new PVector(other.velocity.x,other.velocity.y,other.velocity.z ) ;
          //temp.normalize();
          //temp.div(d); 
          pv.add(temp);
          neighbours++;
        }
    }

    if (neighbours > 0) {
        pv.div((float)neighbours);
        pv.limit(maxce);
    }
    return pv;
  }  
  
  
   PVector rule5(PVector target) {//seek
    PVector desired = PVector.sub(target, position);  // A vector pointing from the position to the target
    // Normalize desired and scale to maximum speed
    desired.normalize();
    desired.mult(maxspeed);
    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxce);  // Limit to maximum steering force
    return steer;
  }


   ArrayList<Boid2D> nearestneighbours_modified() {
    ArrayList<Boid2D> closestBoidsTemp=new ArrayList<Boid2D>(boids2D);
      for (int i = 0; i< boids2D.size(); i++){
        float d = PVector.dist(position, boids2D.get(i).position);
        if( d<200 ){//&& d>0){
        closestBoidsTemp.add(boids2D.get(i));
        }
      }
      return closestBoidsTemp;
   }

  void update() {
    
     //if (iter>10){
      neighbourboids2D = nearestneighbours_modified(); 
    //  iter = 0;
    //}
    //else iter ++;
    PVector v1 = this.rule1();
    PVector v2 = this.rule2();
    PVector v3 = this.rule3();
    PVector v7 = this.avoidObstacles();    
    
      acceleration.add(PVector.mult(avoid(new PVector(position.x, 0, position.z)), 5));
      acceleration.add(PVector.mult(avoid(new PVector(position.x, height, position.z)), 5));
      acceleration.add(PVector.mult(avoid(new PVector(width, position.y, position.z)), 5));
      acceleration.add(PVector.mult(avoid(new PVector(0, position.y, position.z)), 5));
      //acceleration.add(PVector.mult(avoid(new PVector(position.x, position.y, 300)), 0.1));
      //acceleration.add(PVector.mult(avoid(new PVector(position.x, position.y, 900)), 0.1));
    
    applyForce(v1.mult(0.1));
    applyForce(v2.mult(0.11));
    applyForce(v3.mult(0.25));
    //applyForce(v4.mult(1));
    PVector v5 = new PVector(0,0,0);
    if (seekMouse == 1)
      v5 = this.rule5(new PVector(mouseX, mouseY));
    applyForce(v5.mult(0.1));
    applyForce(v7.mult(10));
    acceleration.limit(maxce);
    
    velocity.add(acceleration);
    //velocity.add(wind);
    velocity.limit(maxspeed);
    position.add(velocity);
    acceleration.mult(0);
    
  }

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
