import java.util.*;
import java.util.Collections;


ArrayList<Boid> boids;
float wind_changer = 0.56;
PVector wind = new PVector(1,0,0);
float zoom = -3000;
float horiz_trans = 0;
float av_speed_sq ;
int[] arr_back = {-2500, -1700, 1000, 300};
int messageTimer = 0;
String messageText = "";
float av_energy;


//void settings(){
//  size(displayWidth, displayHeight, P3D);
//}

//void mousePressed(){
//  Boid v = new Boid(mouseX, mouseY,0);
//  boids.add(v);
//  System.out.println("here123");

//}



void draw3D() {
  background(#7ec0ee);
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
  wind_changer +=0.01;
  wind.x = 0.08*sin(wind_changer);
  //wind.z = 0.02*cos(wind_changer);
  //wind.z =  0.05*sin(wind_changer)* 0.05*cos(wind_changer);
  fill(0);
     rect (arr_back[0],arr_back[1],arr_back[2],arr_back[3],100);
     fill(255);
  textSize(100);
  String back = "Back to Selection";
   text (back, -2400, -1520);
   textSize(400);
   String num_boids = "Number of Boids: " + Integer.toString(boids.size());
   text (num_boids, -500, 700);
   String av_speed = "Average Energy: " + String.valueOf(av_energy);
   text (av_speed, -500, 1200);
 

  PVector mouse = new PVector(mouseX, mouseY);

  // Draw an ellipse at the mouse position
  fill(255);
  stroke(0);  
  strokeWeight(2);
  ellipse(mouse.x, mouse.y, 48, 48);
  float av_speed_sq_temp = 0;
  int n = boids.size();
  for(int i = 0; i< n; i = i + n/10){
     Runnable temp= new MyThread(i*10/n);
     new Thread(temp).start();
  }
  for (Boid other: boids){
     other.display();
     av_speed_sq_temp += (other.velocity.mag())*(other.velocity.mag());}
  // Call the appropriate steering behaviors for our agents
  // v.seek(mouse);
    av_speed_sq =  av_speed_sq_temp ;
    av_energy = (0.5*0.075*av_speed_sq)/(boids.size())*1000;
  
}
