import java.util.*;
import java.util.Comparator;


class Boid implements Comparator<Boid>{
   ArrayList<Boid> neighbourboids3D  = new ArrayList<Boid>();
   int iter;;
  PVector position;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxce = 0.1;    // Maximum steering force
  float maxforce = 0.1;
  float maxspeed=80.0;    // Maximum speed
  float flap = 0;
  float t = 0;

  float col1 = 255;//random(0,255);
  float col2 = 190;//random(0,255);
  float col3 = 175;//random(0,255);
  float h = 67;
  Boid(float x, float y, float z) {
    acceleration = new PVector(0,0,0);
    velocity = new PVector(random(-0.5,0.5),random(-0.5,0.5),random(-0.5,0.5));
    position = new PVector(x,y,z);
    r = 4;
    maxforce = 0.1;
    
  }

  void applyForce(PVector force) {
      // We could add mass here if we want A = F / M
      acceleration.add(force);
  }
  int compare(Boid boid1, Boid boid2) {
    float dist1 = PVector.dist(this.position, boid1.position); //boid1.position.dist(this.position);
    float dist2 =  PVector.dist(this.position, boid2.position);//boid2.position.dist(this.position);
    if(dist1>dist2) {return 1;}
    else if(dist1<dist2) {return -1;}
    else {return 0;}
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
  
  PVector rule1(ArrayList<Boid> neighbourboids3D){//cohesion
    PVector pc = new PVector(0,0,0);
    
    for(Boid other: neighbourboids3D){
        //float d = PVector.dist(position, other.position);
        //if(d<500){        
          pc.add(other.position);
         
      //}
    }
    int neighbours=neighbourboids3D.size();
    if (neighbours>0){
        pc.div(neighbours);
    return (pc.sub(position));}//.normalize();
        //return (rule5(pc));}
    else 
      return new PVector(0,0,0);
  }

  PVector rule2(ArrayList<Boid> neighbourboids3D){//separation
    PVector c = new PVector(0,0,0);
  int count = 0;
    for(Boid other: neighbourboids3D){
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

    //c.normalize();
    //c.mult(maxspeed);
    //c.sub(velocity);
    //c.limit(maxforce);
    return c;
  }

  PVector rule3(ArrayList<Boid> neighbourboids3D){ // Alginment
    PVector pv = new PVector(0,0,0);

    int neighbours=0;

    for(Boid other: neighbourboids3D){
      //if(this!= other){
        float d = PVector.dist(position, other.position);
        if( d<25){
          pv.add(velocity);
          neighbours++;
        }
      //}
    }

    if (neighbours > 0) {
        pv.div((float)neighbours);
        pv.normalize();
        pv.mult(maxspeed);
        PVector steer = PVector.sub(pv, velocity);
        steer.limit(maxforce);
        return steer;
      } 
      else {
        return new PVector(0, 0, 0);
      } 
  }
  
  
  
  PVector rule4() {
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
   PVector rule5(PVector target) {//seek
    PVector desired = PVector.sub(target, position);  // A vector pointing from the position to the target
    // Normalize desired and scale to maximum speed
    desired.normalize();
    desired.mult(maxspeed);
    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);  // Limit to maximum steering force
    return steer;
}


   ArrayList<Boid> nearestneighbours_modified() {
    ArrayList<Boid> closestBoidsTemp=new ArrayList<Boid>(boids3D);
      for (int i = 0; i< boids3D.size(); i++){
        float d = PVector.dist(position, boids3D.get(i).position);
        if( d<25 ){//&& d>0){
        closestBoidsTemp.add(boids3D.get(i));
        }
      }
      return closestBoidsTemp;
   }
    ArrayList<Boid> nearestNeighbours() {
    ArrayList<Boid> closestBoidsTemp=new ArrayList<Boid>(boids3D); // copy-constructor to avoid reaching out of our scope
    closestBoidsTemp.remove(this); // avoids considering ourselve
    Collections.sort(closestBoidsTemp, this);
    ArrayList<Boid> closestBoids = new ArrayList();
    if (closestBoidsTemp.size() < 7){
      closestBoids = closestBoidsTemp;
    }
    else{
    for(int i=0;i<6;i++) {
      closestBoids.add(closestBoidsTemp.get(i));
    }
    }
        return closestBoids;
  }
  void update() {
    
     if (iter>10){
      neighbourboids3D = nearestneighbours_modified(); 
      iter = 0;
    }
    else iter ++;
    PVector v1 = this.rule1(neighbourboids3D);
    PVector v2 = this.rule2(neighbourboids3D);
    PVector v3 = this.rule3(neighbourboids3D);
    PVector v4= this.rule4();//roosting
    
    
      acceleration.add(PVector.mult(avoid(new PVector(position.x, 0, position.z)), 5));
      acceleration.add(PVector.mult(avoid(new PVector(position.x, height, position.z)), 5));
      acceleration.add(PVector.mult(avoid(new PVector(width, position.y, position.z)), 0.1));
      acceleration.add(PVector.mult(avoid(new PVector(0, position.y, position.z)), 0.1));
      acceleration.add(PVector.mult(avoid(new PVector(position.x, position.y, 300)), 0.1));
      acceleration.add(PVector.mult(avoid(new PVector(position.x, position.y, 900)), 0.1));
    
    applyForce(v1.mult(1));
    applyForce(v2.mult(1.5));
    applyForce(v3.mult(0.1));
    applyForce(v4.mult(0.1));
    acceleration.limit(maxforce);
    velocity.add(acceleration);
    velocity.limit(maxspeed);
    //velocity.add(wind);
    position.add(velocity);
    acceleration.mult(0);
    
  }

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
    //box(10);
    popMatrix();
  }
}
