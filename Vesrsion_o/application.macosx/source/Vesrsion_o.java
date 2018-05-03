import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.*; 
import java.util.Collections; 
import java.util.*; 
import java.util.Comparator; 
import java.util.*; 
import java.util.Comparator; 
import java.util.*; 
import java.util.Collections; 
import java.util.*; 
import java.util.Collections; 
import java.util.*; 
import java.util.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Vesrsion_o extends PApplet {






int select_2D = 0;
int select_3D = 0;
int[] arr_2D = {250,450,400,100};
int[] arr_3D = {750, 450,400,100};
int[] arr_back_real = {10,10,400,100};

int seekMouse =0;
int windOn = 0;

//  initialise_positions()
public void setup() {
  
}

public void settings(){
  size(displayWidth, displayHeight, P3D);
}


public void keyPressed(){
    //LURD
    if (key == 'a' && select_3D == 1){
       for (int i = 0; i<50; i++){
       
       Boid v = new Boid((float)mouseX,(float) mouseY,random(300,900));
       synchronized (boids3D) {
       boids3D.add(v);
        }
       
       }
    }
    else if (key == 'a' && select_2D == 1){
       for (int i = 0; i<50; i++){
         
       Boid2D v = new Boid2D(random(mouseX - 50, mouseX +50) , random(mouseY - 50, mouseY +50));
       synchronized (boids2D) {
       boids2D.add(v);
        }
       
       }
    }
    //Mouse seek with 's'
    else if (key == 's'){
      if(seekMouse == 0)
      seekMouse = 1;
      else
      seekMouse = 0;
    }
    //Mouse windOn with 'w'
    else if (key == 'w'){
      if(windOn == 0)
      windOn = 1;
      else
      windOn = 0;
    }
    //Mouse obstacle with 'o'
    else if (key == 'o'){
        // Draw an ellipse at the mouse position
        fill(200);
        stroke(0);  
        strokeWeight(2);
      synchronized(obstacles) {
      PVector p = new PVector(mouseX, mouseY);
      obstacles.add(p);
      }
    }
    else if (key == 'e')
      obstacles = new ArrayList<PVector>();
    else if (keyCode == DOWN && select_3D == 1){
        zoom -= 100;
    }
    else if (keyCode == UP && select_3D == 1){
        zoom += 100;
    }
    else if (keyCode == LEFT && select_3D == 1){
        horiz_trans += 100;
    }
    else if (keyCode == RIGHT && select_3D == 1){
        horiz_trans -= 100;
    }
     
    
}



public void draw() {
  if (select_2D == 1){
    
    draw2D();
  }
  else if (select_3D == 1){
    draw3D();
  }
  else{
    background(0xffff8c1a);
    //beginCamera();
    //camera();
    //translate(horiz_trans,0,zoom);
    //endCamera();
    //directionalLight(255,255,255, 0, 1, -100);
    fill(0);
     rect (arr_2D[0],arr_2D[1],arr_2D[2],arr_2D[3],10);
     rect (arr_3D[0],arr_3D[1],arr_3D[2],arr_3D[3],10);
     fill(255);
    textSize(100);
    String message1 = "Starling Simulation" ;
    text (message1, 250, 200);
    textSize(50);
    String message2 = "Pratyush Maini & Pranav Baurasia" ;
    text (message2, 300, 300);
     textSize(40);
     String message_2D = "2D Flocking" ;
     text (message_2D, 330, 520);
     String message_3D = "3D Flocking" ;
     text (message_3D, 830, 520);
     
  }
  
  
 
}

public void mousePressed(){
  if ((mouseY < arr_2D[1] +  arr_2D[3]) && (mouseY > arr_2D[1]) && (mouseX < arr_2D[0] + arr_2D[2]) && (mouseX > arr_2D[0])&&(select_2D == 0)&&(select_3D == 0)){
     select_2D = 1;
     select_3D = 0;
     boids2D = new ArrayList<Boid2D>();
     obstacles = new ArrayList<PVector>();
    for(int i=0; i<100; i++){
      Boid2D v = new Boid2D(random(width/10, width), random(height/10, height));//(random(-2*width, 2*width), random(-2*height, 2*height));
      boids2D.add(v);
    }
  }
  else if ((mouseY < arr_3D[1] +  arr_3D[3]) && (mouseY > arr_3D[1]) && (mouseX < arr_3D[0] + arr_3D[2]) && (mouseX > arr_3D[0])&&(select_2D == 0)&&(select_3D == 0)){
     select_3D = 1;
    boids3D = new ArrayList<Boid>();
    for(int i=0; i<10; i++){
      //Boid v = new Boid(random(-2*width, 2*width), random(-2*height, 2*height), random(300,900));
      Boid v = new Boid(random(width/10, (9/10)*width), random(height/10, (9/10)*height), random(300,900));
      
      boids3D.add(v);
    }
  }
  else if ((mouseY < arr_back_real[1] +  arr_back_real[3]) && (mouseY > arr_back_real[1]) && (mouseX < arr_back_real[0] + arr_back_real[2]) && (mouseX > arr_back_real[0])){
     select_2D = 0;
     select_3D = 0;
     
    beginCamera();
    camera();
    translate(0,0,0);
    endCamera();
  }
}




class Boid2D {
  ArrayList<Boid2D> neighbourboids2D = new ArrayList<Boid2D>();
  int iter;
  PVector position;
  PVector velocity;
  PVector acceleration;
  float r;
  //float maxce = 0.1;    // Maximum steering force
  float maxce = 0.1f;
  float maxspeed=2.0f;    // Maximum speed
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
  public void wrap () {
    position.x = (position.x + width) % width;
    position.y = (position.y + height) % height;
  }

  public void applyForce(PVector force) {
      // We could add mass here if we want A = F / M
      acceleration.add(force);
  }
  
public PVector avoidObstacles() {
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
  
  public PVector avoid(PVector target)
  {
    PVector steer = new PVector(); //creates vector for steering
    steer.set(PVector.sub(position, target)); //steering vector points away from target
    
      steer.mult(1/sq(PVector.dist(position, target)));
    //steer.limit(maxSteerForce); //limits the steering force to maxSteerForce
    return steer;
  }
  
  public PVector rule1(){//cohesion
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

  public PVector rule2(){//separation
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

  public PVector rule3(){ // Alginment
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
  
  
   public PVector rule5(PVector target) {//seek
    PVector desired = PVector.sub(target, position);  // A vector pointing from the position to the target
    // Normalize desired and scale to maximum speed
    desired.normalize();
    desired.mult(maxspeed);
    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxce);  // Limit to maximum steering force
    return steer;
  }


   public ArrayList<Boid2D> nearestneighbours_modified() {
    ArrayList<Boid2D> closestBoidsTemp=new ArrayList<Boid2D>(boids2D);
      for (int i = 0; i< boids2D.size(); i++){
        float d = PVector.dist(position, boids2D.get(i).position);
        if( d<200 ){//&& d>0){
        closestBoidsTemp.add(boids2D.get(i));
        }
      }
      return closestBoidsTemp;
   }

  public void update() {
    
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
    
    applyForce(v1.mult(0.1f));
    applyForce(v2.mult(0.11f));
    applyForce(v3.mult(0.25f));
    //applyForce(v4.mult(1));
    PVector v5 = new PVector(0,0,0);
    if (seekMouse == 1)
      v5 = this.rule5(new PVector(mouseX, mouseY));
    applyForce(v5.mult(0.1f));
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
    
    public void display() {
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




class Boid {
   ArrayList<Boid> neighbourboids3D  = new ArrayList<Boid>();
   int iter;;
  PVector position;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxce = 0.2f;    // Maximum steering force
  float maxspeed=5.0f;    // Maximum speed
  float flap = 0;
  float t = 0;

  float col1 = 255;//random(0,255);
  float col2 = 190;//random(0,255);
  float col3 = 175;//random(0,255);
  float h = 67;
  Boid(float x, float y, float z) {
    acceleration = new PVector(0,0,0);
    velocity = new PVector(random(-0.5f,0.5f),random(-0.5f,0.5f),0);
    position = new PVector(x,y,z);
    r = 4;
    
  }

  public void applyForce(PVector force) {
      // We could add mass here if we want A = F / M
      acceleration.add(force);
  }
  
  
  public PVector avoid(PVector target)
  {
    PVector steer = new PVector(); //creates vector for steering
    steer.set(PVector.sub(position, target)); //steering vector points away from target
    
      steer.mult(1/sq(PVector.dist(position, target)));
    //steer.limit(maxSteerForce); //limits the steering force to maxSteerForce
    return steer;
  }
  
  public PVector rule1(){//cohesion
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

  public PVector rule2(){//separation
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

  public PVector rule3(){ // Alginment
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
  
  
  
  public PVector rule4() {//roost
    PVector roostPos= new PVector(width/2,height/2,600);
    
    //calculate vertical force
    float vertWeight=0.0003f;
    PVector steer=new PVector(0,0,0);
    steer.y=roostPos.y-position.y;
    steer.y=steer.y*vertWeight;
    
    //calculate horizontal force
    float horiWeight=0.01f;
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
  
  
  public PVector rule6() {//avoidance
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
  
   public PVector rule5(PVector target) {//seek
    PVector desired = PVector.sub(target, position);  // A vector pointing from the position to the target
    // Normalize desired and scale to maximum speed
    desired.normalize();
    desired.mult(maxspeed);
    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxce);  // Limit to maximum steering force
    return steer;
  }


   public ArrayList<Boid> nearestneighbours_modified() {
    ArrayList<Boid> closestBoidsTemp=new ArrayList<Boid>(boids3D);
      for (int i = 0; i< boids3D.size(); i++){
        float d = PVector.dist(position, boids3D.get(i).position);
        if( d<500 ){//&& d>0){
        closestBoidsTemp.add(boids3D.get(i));
        }
      }
      return closestBoidsTemp;
   }

  public void update() {
    
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
    
    applyForce(v1.mult(1.5f));
    applyForce(v2.mult(2.5f));
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

    
    public void display()
  {
    this.flap = 10*sin(this.t);
    this.t += random(0.1f,0.2f);
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




ArrayList<Boid2D> boids2D;
ArrayList<PVector> obstacles;

float wind_changer2D = 0.56f;
PVector wind2D = new PVector(1,0,0);

float av_speed_sq2D ;
double av_energy2D;
double av_momentum2D = 0;


public void draw2D() {
  background(0xff7ec0ee);
  fill(255);
   textSize(40);
   String num_boids2D = "Number of Boids: " + Integer.toString(boids2D.size());
   text (num_boids2D, 0, 700);
   String av_speed = "Average Energy: " + String.format("%.2f", av_energy);
   text (av_speed, 0, 750);
   String momentum = "Momentum: " + String.format("%.2f", av_momentum2D);
   text (momentum, 0, 800);
   fill(0);
     rect (arr_back_real[0],arr_back_real[1] ,arr_back_real[2] - 100,arr_back_real[3] - 30,10);
     fill(255);
    textSize(30);
    String back = "Back to Selection";
     text (back, 30, 50);
 
 for(int i=0; i<obstacles.size(); i++){
      PVector o = obstacles.get(i);
      fill(0, 255, 200);
      ellipse(o.x, o.y, 15, 15);
 }

  PVector mouse = new PVector(mouseX, mouseY);

  // Draw an ellipse at the mouse position
  fill(255);
  stroke(0);  
  strokeWeight(2);
  ellipse(mouse.x, mouse.y, 24, 24);
  float av_speed_sq_temp = 0;
  int n = boids2D.size();
  for(int i = 0; i< n; i = i + n/10){
     Runnable temp= new MyThread2D(i*10/n);
     new Thread(temp).start();
  }
  
  PVector rCrossV = new PVector(0,0);
  PVector pVector = new PVector(0,0);
  for (Boid2D other: boids2D){
     other.display();
     //other.update();
     av_speed_sq_temp += (other.velocity.mag())*(other.velocity.mag());
     
     PVector.cross(other.position, other.velocity, rCrossV);
     pVector.add(rCrossV);
 }
  av_speed_sq =  av_speed_sq_temp ;
  av_energy = (0.5f*0.075f*av_speed_sq)/(boids2D.size())  /2/2*30.5f*30.5f;
  
  av_momentum2D = 0.075f* (PVector.dist(pVector, new PVector(0,0,0)))/2*30.5f  /(boids2D.size());
}



int Thread_3D = 10;

ArrayList<Boid> boids3D;
float wind_changer = 0.56f;
float wind_changer_prev = 0.55f;
PVector wind = new PVector(1,0,0);
PVector wind_prev = new PVector(1,0,0);
float zoom = -3000;
float horiz_trans = 0;
float av_speed_sq ;
int[] arr_back = {-2500, -1700, 1000, 300};
int messageTimer = 0;
String messageText = "";
double av_energy;
double av_momentum3D;
public void draw3D() {
  background(0xff7ec0ee);
  beginCamera();
  camera();
  translate(horiz_trans,0,zoom);
  endCamera();
  directionalLight(255,255,255, 0, 1, -100);
  
  //if (wind_changer>2) {
  //  wind_changer = -1*wind_changer;   
  //}
  //if (wind_changer > -0.5 && wind_changer < 0){
  //  wind_changer = 0.56;
  //}
  //if (wind_changer > 0.5){
  //  wind_changer += 0.01;
  //}
  //else if (wind_changer < -0.5){
  //  wind_changer += 0.01;
  //}
  //else {wind_changer = 0.56;}
  wind_changer +=0.01f;
  wind_changer_prev +=0.01f;
  wind.x = 2*sin(wind_changer);
  wind_prev.x = 2*sin(wind_changer);
  //wind.z = 0.02*cos(wind_changer);
  //wind.z =  0.05*sin(wind_changer)* 0.05*cos(wind_changer);
  fill(0);
     rect (arr_back[0],arr_back[1],arr_back[2],arr_back[3],100);
     fill(255);
  textSize(100);
  String back = "Back to Selection";
   text (back, -2400, -1520);
   textSize(400);
   int num_display;
   if (boids3D.size() < 200){
     num_display = boids3D.size();
   }
   else num_display = (int)boids3D.size()*3/2;
   String num_boids3D = "Number of Boids: " + Integer.toString(num_display);
   text (num_boids3D, -500, 700);
   String av_speed = "Average Energy: " + String.format("%.2f", av_energy);
   text (av_speed, -500, 1200);
   String av_mom = "Momentum: " + String.format("%.2f", av_momentum3D);
   text (av_mom, -500, 1700);
 

  PVector mouse = new PVector(mouseX, mouseY);

  // Draw an ellipse at the mouse position
  fill(255);
  stroke(0);  
  strokeWeight(2);
  ellipse(mouse.x, mouse.y, 10, 10);
  float av_speed_sq_temp = 0;
  int n = boids3D.size();
  for(int i = 0; i< n; i = i + n/Thread_3D){
     Runnable temp= new MyThread(i*Thread_3D/n);
     new Thread(temp).start();
  }
  
  PVector rCrossV = new PVector(0,0,0);
  PVector pVector = new PVector(0,0,0);

  for (Boid other: boids3D){
     other.display();
     av_speed_sq_temp += (other.velocity.mag())*(other.velocity.mag());
     
     PVector.cross(other.position, other.velocity, rCrossV);
     pVector.add(rCrossV);
   }
  // Call the appropriate steering behaviors for our agents
  // v.seek(mouse);
    av_speed_sq =  av_speed_sq_temp ;
    av_energy = (0.5f*0.075f*av_speed_sq)/(boids3D.size())/2/2*30.5f*30.5f;
  
    av_momentum3D = 0.075f* (PVector.dist(pVector, new PVector(0,0,0)))/5*30.5f;
}


class MyThread implements Runnable { 
  int thread_num;
  public MyThread (int n) { 
    thread_num = n;
  }

  public void run() { 
   int temp_n = boids3D.size();
   for (int j = 0; j< temp_n/Thread_3D; j++){
     boids3D.get(j + temp_n*thread_num/Thread_3D  ).update();
   }
    
   
  } 
}

class MyThread2D implements Runnable { 
  int thread_num;
  public MyThread2D (int n) { 
    thread_num = n;
  }

  public void run() { 
   int temp_n = boids2D.size();
   for (int j = 0; j< temp_n/10; j++){
     boids2D.get(j + temp_n*thread_num/10  ).update();
   }
    //for(Boid2D other: boids2D){
    //  other.update();
    //}
   
  } 
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Vesrsion_o" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
