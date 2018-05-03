import java.util.Collections;
import java.util.Comparator;

//ArrayList<Boid> boids3D;

class Boid implements Comparator<Boid>
{
  //PVector position;
  //PVector velocity;
  //PVector acceleration;
  //float r;
  //float maxforce;    // Maximum steering force
  //float maxspeed=2.0;    // Maximum speed
  int iter = -1;
  color col;
  float col1 = 255;//random(0,255);
  float col2 = 190;//random(0,255);
  float col3 = 175;//random(0,255);

  PVector pos, vel, acc, ali, coh, sep; //pos, velocity, and acceleration in a vector datatype
  float neighborhoodRadius; //radius in which it looks for fellow boids
  float maxSpeed = 5; //maximum magnitude for the velocity vector
  float maxSteerForce = 0.2; //maximum magnitude of the steering vector
  float h; //hue
  float r=3; //scale factor for the render of the boid
  float flap = 0;
  float t=0;
  boolean avoidWalls = true;
  
  float phase=random(0.095,0.14);

  //constructors
  Boid(float x, float y, float z)
  {
    pos = new PVector(x,y,z);    //pos.set(inPos);
    vel = new PVector(random(-1, 1), random(-1, 1), random(1, -1));
    acc = new PVector(0, 0, 0);
    neighborhoodRadius = 400;
  }
  Boid(PVector inPos)
  {
    pos = new PVector(random(width/4,width*3/4), random(height), random(width/4,width*3/4));    //pos.set(inPos);
    vel = new PVector(random(-1, 1), random(-1, 1), random(1, -1));
    acc = new PVector(0, 0, 0);
    neighborhoodRadius = 400;
  }
  Boid(PVector inPos, PVector inVel, float r)
  {
    pos = new PVector();
    pos.set(inPos);
    vel = new PVector();
    vel.set(inVel);
    acc = new PVector(0, 0);
    neighborhoodRadius = r;
  }

  void update()
  {
    t+=phase;

    //acc.add(steer(new PVector(mouseX,mouseY,300),true));
    //acc.add(new PVector(0,.002,0));
    if (avoidWalls)
    {
      //acc.add(PVector.mult(avoid(new PVector(pos.x, height, pos.z), true), 5));
      //keep desire to not hit ground strong
      acc.add(PVector.mult(avoid(new PVector(pos.x, 0, pos.z), true), 5));
      acc.add(PVector.mult(avoid(new PVector(width, pos.y, pos.z), true), 0.1));
      acc.add(PVector.mult(avoid(new PVector(0, pos.y, pos.z), true), 0.1));
      acc.add(PVector.mult(avoid(new PVector(pos.x, pos.y, 300), true), 0.1));
      acc.add(PVector.mult(avoid(new PVector(pos.x, pos.y, 900), true), 0.1));
    }
    flock();
    move();
    //checkBounds();
    flap = 10*sin(t);
    //display();
  }

  /////-----------behaviors---------------
  void flock()
  {
    ArrayList<Boid> neighbours = new ArrayList<Boid>();
    //if (iter== -1 || iter ==1){
      
    //  neighbours=nearestNeighbours();
    //  iter = 0;
    //}
    //else iter++;
    //ArrayList neighbours=boids;
    neighbours=nearestNeighbours();
    ali = alignment(neighbours);
    coh = cohesion(neighbours);
    sep = seperation(neighbours);
    acc.add(PVector.mult(ali, 1));
    //acc.add(wind);
    
    acc.add(PVector.mult(coh, 6));
    acc.add(PVector.mult(sep, 3));
    acc.add(PVector.mult(roost(),1));
  }

  void scatter()
  {
  }
  ////------------------------------------

  void move()
  {
    vel.add(acc); //add acceleration to velocity
    //pos.sub(wind_prev);
    vel.limit(maxSpeed); //make sure the velocity vector magnitude does not exceed maxSpeed
    pos.add(vel); //add velocity to position
    acc.mult(0); //reset acceleration
  }

  
  void display()
  {

this.flap = 10*sin(this.t);
    this.t += random(0.1,0.2);
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    rotateY(atan2(-vel.z, vel.x));
    rotateZ(asin(vel.y/vel.mag()));
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

  //avoid. If weight == true avoidance vector is larger the closer the boid is to the target
  PVector avoid(PVector target, boolean weight)
  {
    PVector steer = new PVector(); //creates vector for steering
    steer.set(PVector.sub(pos, target)); //steering vector points away from target
    if (weight)
      steer.mult(1/sq(PVector.dist(pos, target)));
    //steer.limit(maxSteerForce); //limits the steering force to maxSteerForce
    return steer;
  }

  PVector seperation(ArrayList boids)
  {
    PVector posSum = new PVector(0, 0, 0);
    PVector repulse;
    for (int i=0; i<boids.size(); i++)
    {
      Boid b = (Boid)boids.get(i);
      float d = PVector.dist(pos, b.pos);
      if (d>0&&d<=neighborhoodRadius)
      {
        repulse = PVector.sub(pos, b.pos);
        repulse.normalize();
        repulse.div(d);
        posSum.add(repulse);
      }
    }
    return posSum;
  }

  PVector alignment(ArrayList boids)
  {
    PVector velSum = new PVector(0, 0, 0);
    int count = 0;
    for (int i=0; i<boids.size(); i++)
    {
      Boid b = (Boid)boids.get(i);
      float d = PVector.dist(pos, b.pos);
      if (d>0&&d<=neighborhoodRadius)
      {
        velSum.add(b.vel);
        count++;
      }
    }
    if (count>0)
    {
      velSum.div((float)count);
      velSum.limit(maxSteerForce);
    }
    return velSum;
  }

  PVector cohesion(ArrayList boids)
  {
    PVector posSum = new PVector(0, 0, 0);
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    for (int i=0; i<boids.size(); i++)
    {
      Boid b = (Boid)boids.get(i);
      float d = dist(pos.x, pos.y, b.pos.x, b.pos.y);
      if (d>0&&d<=neighborhoodRadius)
      {
        posSum.add(b.pos);
        count++;
      }
    }
    if (count>0)
    {
      posSum.div((float)count);
    }
    steer = PVector.sub(posSum, pos);
    steer.limit(maxSteerForce); 
    return steer;
  }
  
  PVector roost() {
    PVector roostPos= new PVector(width/2,height/2,600);
    
    //calculate vertical force
    float vertWeight=0.0003;
    PVector steer=new PVector(0,0,0);
    steer.y=roostPos.y-pos.y;
    steer.y=steer.y*vertWeight;
    
    //calculate horizontal force
    float horiWeight=0.01;
    PVector modPos=new PVector(0,0,0);
    modPos.x=pos.x;
    modPos.y=0;
    modPos.z=pos.z;
    PVector modPosDiff=new PVector(0,0,0);
    modPosDiff.add(roostPos);
    modPosDiff.sub(modPos);
    modPosDiff.y=0;
    modPosDiff.normalize();
    modPosDiff.mult(horiWeight);  
    steer.add(modPosDiff);
    return steer;
  }
  
  //ArrayList<Boid> nearestNeighbours() {
  //  ArrayList<Boid> closestBoidsTemp=new ArrayList<Boid>(boids3D); // copy-constructor to avoid reaching out of our scope
  //  closestBoidsTemp.remove(this); // avoids considering ourselves
  //  Collections.sort(closestBoidsTemp, this);
  //  ArrayList<Boid> closestBoids = new ArrayList();
  //  for(int i=0;i<6;i++) {
  //    closestBoids.add(closestBoidsTemp.get(i));
  //  }
  //      return closestBoids;
  //}
  ArrayList<Boid> nearestNeighbours() {
    ArrayList<Boid> closestBoidsTemp=new ArrayList<Boid>(boids3D);
      for (int i = 0; i< boids3D.size(); i++){
        float d = PVector.dist(pos, boids3D.get(i).pos);
        if( d<50){
        closestBoidsTemp.add(boids3D.get(i));
        }
      }
      return closestBoidsTemp;
   }
  
  int compare(Boid boid1, Boid boid2) {
    float dist1 = boid1.pos.dist(this.pos);
    float dist2 = boid2.pos.dist(this.pos);
    //print("Boid[" + System.identityHashCode(this) + "].compare(Boid[" + System.identityHashCode(boid1) + "], Boid[" + System.identityHashCode(boid2) + "]: dist1=" + dist1 + ", dist2=" + dist2 + "\n");
    if(dist1>dist2) {return 1;}
    if(dist1<dist2) {return -1;}
    else {return 0;}
    //return (int) Math.signum(boid1.pos.sub(this.pos).mag()-boid2.pos.sub(this.pos).mag());
  }
    
}
