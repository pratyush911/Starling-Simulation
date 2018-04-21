ArrayList<Vehicle> boids;

class Vehicle {
  
  PVector position;
  PVector velocity;
  //PVector acceleration;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed

  Vehicle(float x, float y) {
    //acceleration = new PVector(0,0);
    velocity = new PVector(0,-1);
    position = new PVector(x,y);
    r = 6;
    maxspeed = 4;
    maxforce = 0.1;
  }

  PVector rule1(){//cohesion
    PVector pc = new PVector(0,0);
    for(Vehicle other: boids){
      if(this != other){
        pc.add(other.position);
      }
    }

    pc.div(boids.size()-1);

    return (pc.sub(position)).div(100);
  }

  PVector rule2(){//separation
    PVector c = new PVector(0,0);

    for(Vehicle other: boids){
      if(this != other){
        float d = PVector.dist(other.position, position);
        if(d<25){
          PVector  br = PVector.sub(other.position, position);
          c.sub(br);
        }
      }
    }

    return c;
  }

  PVector rule3(){
    PVector pv = new PVector(0,0);

    for(Vehicle other: boids){
      if(this!= other){
        pv.add(velocity);
      }
    }

    pv.div(boids.size() - 1);

    return (pv.sub(velocity)).div(8);
  }

  void update() {
    PVector v1 = this.rule1();
    PVector v2 = this.rule2();
    PVector v3 = this.rule3();

    velocity.add(v1);
    velocity.add(v2);
    velocity.add(v3);
    velocity.limit(maxspeed);
    position.add(velocity);
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
    // Draw a triangle rotated in the direction of velocity
    float theta = velocity.heading2D() + PI/2;
    fill(127);
    stroke(0);
    strokeWeight(1);
    pushMatrix();
    translate(position.x % 640,position.y % 360);
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
  size(800, 600);

  boids = new ArrayList<Vehicle>();
  for(int i=0; i<10; i++){
  Vehicle v = new Vehicle(width/2, height/2);
  boids.add(v);
  // Vehicle v1 = new Vehicle(width/2-1, height/2+1);
  // boids.add(v1);
      System.out.println("here123");
   }
}

void draw() {
  background(255);

  PVector mouse = new PVector(mouseX, mouseY);

  // Draw an ellipse at the mouse position
  fill(200);
  stroke(0);
  strokeWeight(2);
  ellipse(mouse.x, mouse.y, 48, 48);

  // Call the appropriate steering behaviors for our agents
  // v.seek(mouse);
  for(Vehicle other: boids){
    other.update();
  }
  for(Vehicle other: boids){
    other.display();
  }
}

