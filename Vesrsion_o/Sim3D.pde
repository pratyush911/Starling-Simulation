import java.util.*;
import java.util.Collections;

int Thread_3D = 10;

ArrayList<Boid> boids3D;
float wind_changer = 0.56;
float wind_changer_prev = 0.55;
PVector wind = new PVector(1,0,0);
PVector wind_prev = new PVector(1,0,0);
float zoom = -3000;
float horiz_trans = 0;
float av_speed_sq ;
int[] arr_back = {-2500, -1700, 1000, 300};
int messageTimer = 0;
String messageText = "";
float av_energy;

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
  wind_changer_prev +=0.01;
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
   String av_speed = "Average Energy: " + String.valueOf(av_energy);
   text (av_speed, -500, 1200);
 

  PVector mouse = new PVector(mouseX, mouseY);

  // Draw an ellipse at the mouse position
  fill(255);
  stroke(0);  
  strokeWeight(2);
  ellipse(mouse.x, mouse.y, 48, 48);
  float av_speed_sq_temp = 0;
  int n = boids3D.size();
  for(int i = 0; i< n; i = i + n/Thread_3D){
     Runnable temp= new MyThread(i*Thread_3D/n);
     new Thread(temp).start();
  }
  for (Boid other: boids3D){
     other.display();
     av_speed_sq_temp += (other.velocity.mag())*(other.velocity.mag());
   }
  // Call the appropriate steering behaviors for our agents
  // v.seek(mouse);
    av_speed_sq =  av_speed_sq_temp ;
    av_energy = (0.5*0.075*av_speed_sq)/(boids3D.size())*1000;
  
}
