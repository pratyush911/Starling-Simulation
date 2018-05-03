import java.util.*;
import java.util.Comparator;


class Boid {
   ArrayList<Boid> neighbourboids3D  = new ArrayList<Boid>();
   int iter;;
  PVector position;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxce = 0.2;    // Maximum steering force
  float maxspeed=5.0;    // Maximum speed
  float flap = 0;
  float t = 0;

  float col1 = 255;//random(0,255);
  float col2 = 190;//random(0,255);
  float col3 = 175;//random(0,255);
  float h = 67;
  Boid(float x, float y, float z) {
    acceleration = new PVector(0,0,0);
    velocity = new PVector(random(-0.5,0.5),random(-0.5,0.5),0);
    position = new PVector(x,y,z);
    r = 4;
    
  }

  void applyForce(PVector force) {
      // We could add mass here if we want A = F / M
      acceleration.add(force);
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
    PVector pc = new PVector(0,0,0);
    int neighbours = 0;
    for(Boid other: neighbourboids3D){
        float d = PVector.dist(position, other.position);
        if(d<500 && d!=0){        
          pc.add(other.position);
          neighbours++;
         
      }
    }
    if (neighbours>0){
        pc.div((float)neighbours);
    }
    PVector steer = pc.sub(position);
    steer.limit(maxce);
    return steer;
  }

  PVector rule2(){//separation
    PVector c = new PVector(0,0,0);
    int count = 0;
    for(Boid other: neighbourboids3D){
        float d = PVector.dist(position, other.position);
        if(d>0 && d<500){
          PVector  br = PVector.sub(position, other.position);
          br.normalize();
          br.div(d);
          c.add(br);
          count++;
        }
      
    }
    return c;
  }

  PVector rule3(){ // Alginment
    PVector pv = new PVector(0,0,0);

    int neighbours=0;

    for(Boid other: neighbourboids3D){
        float d = PVector.dist(position, other.position);
        if( d<500 && d!=0){
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
  
  
  
  PVector rule4() {//roost
    PVector roostPos= new PVector(width/2,height/2,600);
    
    //calculate vertical force
    float vertWeight=0.0003;
    PVector steer=new PVector(0,0,0);
    steer.y=roostPos.y-position.y;
    steer.y=steer.y*vertWeight;
    
    //calculate horizontal force
    float horiWeight=0.01;
    PVector modPos=new PVector(0,0,0);
    modPos.x=position.x;
    modPos.y=0;
    modPos.z=position.z;
    PVector modPosDiff=new PVector(0,0,0);
    modPosDiff.add(roostPos);
    modPosDiff.sub(modPos);
    modPosDiff.y=0;
    modPosDiff.normalize();
    modPosDiff.mult(horiWeight);  
    steer.add(modPosDiff);
    return steer;
  }
  
  
  PVector rule6() {//avoidance
    PVector steer = new PVector(0, 0, 0);
    int count = 0;

    for (Boid other : neighbourboids3D) {
      float d = PVector.dist(position, other.position);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < 250)) {
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


   ArrayList<Boid> nearestneighbours_modified() {
    ArrayList<Boid> closestBoidsTemp=new ArrayList<Boid>(boids3D);
      for (int i = 0; i< boids3D.size(); i++){
        float d = PVector.dist(position, boids3D.get(i).position);
        if( d<500 ){//&& d>0){
        closestBoidsTemp.add(boids3D.get(i));
        }
      }
      return closestBoidsTemp;
   }

  void update() {
    
      neighbourboids3D = nearestneighbours_modified(); 

    PVector v1 = this.rule1();
    PVector v2 = this.rule2();
    PVector v3 = this.rule3();
    PVector v4= this.rule4();//roosting
    PVector v6 = this.rule6();
    
      //They dont want to hit the ground this is the upthrust generated by the boids
      acceleration.add(PVector.mult(avoid(new PVector(position.x, 0, position.z)), 5));

      //They can attain a ceratin height according to their oxygen level intake
      acceleration.add(PVector.mult(avoid(new PVector(position.x, height, position.z)), 5));
      
      //They remain in a region and don't want to go out of it.
      acceleration.add(PVector.mult(avoid(new PVector(width, position.y, position.z)), 4));
      acceleration.add(PVector.mult(avoid(new PVector(0, position.y, position.z)), 4));
      acceleration.add(PVector.mult(avoid(new PVector(position.x, position.y, 300)), 4));
      acceleration.add(PVector.mult(avoid(new PVector(position.x, position.y, 900)), 4));
    
    applyForce(v1.mult(1.5));
    applyForce(v2.mult(2.5));
    applyForce(v3.mult(1));
    applyForce(v4.mult(1));
    PVector v5 = new PVector(0,0,0);
    if (seekMouse == 1)
      v5 = this.rule5(new PVector(mouseX, mouseY, 0));
    applyForce(v5.mult(6));
    acceleration.limit(maxce);
    
    velocity.add(acceleration);
    if (windOn == 1)
      velocity.add(wind);
    velocity.limit(maxspeed);
    position.add(velocity);
    acceleration.mult(0);
    
  }

    
    void display()
  {
    this.flap = 10*sin(this.t);
    this.t += random(0.1,0.2);
    pushMatrix();
    translate(position.x, position.y, position.z);
    rotateY(atan2(-velocity.z, velocity.x));
    rotateZ(asin(velocity.y/velocity.mag()));
    rotateX(-PI/2);
    stroke(h);
    noFill();
    noStroke();
    fill(col1, col2, col3);
    //draw bird
    beginShape(TRIANGLES);
    vertex(3*r,0,0);
    vertex(-3*r,2*r,0);
    vertex(-3*r,-2*r,0);
//endShape();
//beginShape(TRIANGLES);
    vertex(3*r,0,0);
    vertex(-3*r,2*r,0);
    vertex(-3*r,0,2*r);
//endShape();
//beginShape(TRIANGLES);
    vertex(3*r,0,0);
    vertex(-3*r,0,2*r);
    vertex(-3*r,-2*r,0);
//endShape();
//beginShape(TRIANGLES);
    // wings
    vertex(2*r, 0, 0);
    vertex(-1*r, 0, 0);
    vertex(-1*r, -8*r, flap);
//endShape();
//beginShape(TRIANGLES);
    vertex(2*r, 0, 0);
    vertex(-1*r, 0, 0);
    vertex(-1*r, 8*r, flap);
//endShape();
//beginShape(TRIANGLES);
   vertex(-3*r, 0, 2*r);
    vertex(-3*r, 2*r, 0);
    vertex(-3*r, -2*r, 0);
    //
    endShape();
    popMatrix();
  }
}
