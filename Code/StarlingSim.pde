import java.util.*;
import java.util.Collections;
ArrayList<Boid> boids;
float wind_changer = 0.56;
PVector wind = new PVector(1,0,0);
//  initialise_positions()
void setup() {
  size(1920, 1080, P3D);

  boids = new ArrayList<Boid>();
  for(int i=0; i<500; i++){
    Boid v = new Boid(random(width/10, width*9/10), random(height/10, height*9/10), random(300,900));
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
       Boid v = new Boid(mouseX, mouseY,random(300,900));
       boids.add(v);
    }
}

void draw() {
  background(#7ec0ee);
  beginCamera();
  camera();
  translate(0,0,-1000);
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
  wind_changer +=0.01;
  wind.x = 0.02*sin(wind_changer);
  wind.z = 0.02*cos(wind_changer);
  //wind.z =  0.05*sin(wind_changer)* 0.05*cos(wind_changer);

  
  
  PVector mouse = new PVector(mouseX, mouseY);

  // Draw an ellipse at the mouse position
  fill(255);
  stroke(0);  
  strokeWeight(2);
  ellipse(mouse.x, mouse.y, 48, 48);

  // Call the appropriate steering behaviors for our agents
  // v.seek(mouse);
  for(Boid other: boids){
    other.update();
  }

  for(Boid other: boids){
    other.flap = 10*sin(other.t);
    other.t += random(0.1,0.2);
    other.display();
  }
}
