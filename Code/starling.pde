import java.util.*;
ArrayList<Boid> boids;

class Boid {
  
  PVector position;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed=2.0;    // Maximum speed

  color col;
  Boid(float x, float y, float z) {
    acceleration = new PVector(0,0,0);
    velocity = new PVector((float)Math.random(),(float)Math.random(),(float)Math.random());
    position = new PVector(x,y,z);
    r = 6;
    maxforce = 0.1;
    
  }

  void applyForce(PVector force) {
      // We could add mass here if we want A = F / M
      acceleration.add(force);
  }

  PVector rule1(){//cohesion
    PVector pc = new PVector(0,0,0);
    int neighbours=0;
    for(Boid other: boids){
      if(this != other){
        float d = PVector.dist(other.position, position);
        //if(d<50){        
          pc.add(other.position);
          neighbours++;
        //}
      }
    }

    pc.div(neighbours);

    return (pc.sub(position)).div(10000);
  }

  PVector rule2(){//separation
    PVector c = new PVector(0,0,0);

    for(Boid other: boids){
      if(this != other){
        float d = PVector.dist(other.position, position);
        if(d<25){
          PVector  br = PVector.sub(other.position, position);
          br.normalize();
          c.sub(br);
        }
      }
    }

    c.normalize();
    //c.mult(maxspeed);
    //c.sub(velocity);
    c.limit(maxforce);
    return c;
  }

  PVector rule3(){ // Alginment
    PVector pv = new PVector(0,0,0);

    int neighbours=0;

    for(Boid other: boids){
      if(this!= other){
        float d = PVector.dist(other.position, position);
        //if(d<50){
          pv.add(velocity);
          neighbours++;
        //}
      }
    }

    pv.div(neighbours);

    return (pv.sub(velocity)).div(8000);
  }

  void update() {
    PVector v1 = this.rule1();
    PVector v2 = this.rule2();
    PVector v3 = this.rule3();

    applyForce(v1);
    applyForce(v2);
    applyForce(v3);
    
    velocity.add(acceleration);
    velocity.limit(maxspeed);
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
    
  void display() {
    // Draw a triangle rotated in the direction of velocityha
    float theta = velocity.heading2D() + PI/2;
    fill(127);
    stroke(0);
    strokeWeight(1);
    pushMatrix();
    translate(position.x, position.y,position.z);
    rotate(theta);
    beginShape();
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
    endShape(CLOSE);
    popMatrix();
      
  }
}




//  initialise_positions()
void setup() {
  size(1920, 1080);

  boids = new ArrayList<Boid>();
  for(int i=0; i<1000; i++){
    Boid v = new Boid(width/2, height/2,0);
    boids.add(v);
  }
}

void settings(){
  size(displayWidth, displayHeight, P3D);
}

//void mousePressed(){
//  Boid v = new Boid(mouseX, mouseY,0);
//  boids.add(v);
//  System.out.println("here123");

//}

void keyPressed(){
    //LURD
    if (key == 'a')
        rotateX(1);
    else if (key == 's')
        rotateY(100);
    else if (keyCode == UP)
        rotateX(1);
    else if (keyCode == UP)
        rotateY(1);
     
    if (key == 'a' ){
       Boid v = new Boid(mouseX, mouseY,0);
       boids.add(v);
    }
}

void draw() {
  background(0);

  PVector mouse = new PVector(mouseX, mouseY);

  // Draw an ellipse at the mouse position
  fill(200);
  stroke(0);  
  strokeWeight(2);
  ellipse(mouse.x, mouse.y, 48, 48);

  // Call the appropriate steering behaviors for our agents
  // v.seek(mouse);
  for(Boid other: boids){
    other.update();
  }
  for(Boid other: boids){
    other.display();
  }
}
