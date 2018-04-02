import java.util.*;
import java.util.Collections;


ArrayList<Boid2D> boids2D;
float wind_changer2D = 0.56;
PVector wind2D = new PVector(1,0,0);

float av_speed_sq2D ;
float av_energy2D;

void draw2D() {
  background(#7ec0ee);
  fill(255);
   textSize(40);
   String num_boids2D = "Number of Boids: " + Integer.toString(boids2D.size());
   text (num_boids2D, 0, 700);
   String av_speed = "Average Energy: " + String.valueOf(av_energy);
   text (av_speed, 0, 750);
   fill(0);
     rect (arr_back_real[0],arr_back_real[1] ,arr_back_real[2] - 100,arr_back_real[3] - 30,10);
     fill(255);
    textSize(30);
    String back = "Back to Selection";
     text (back, 30, 50);
 

  PVector mouse = new PVector(mouseX, mouseY);

  // Draw an ellipse at the mouse position
  fill(255);
  stroke(0);  
  strokeWeight(2);
  ellipse(mouse.x, mouse.y, 48, 48);
  float av_speed_sq_temp = 0;
  int n = boids2D.size();
  for(int i = 0; i< n; i = i + n/10){
     Runnable temp= new MyThread2D(i*10/n);
     new Thread(temp).start();
  }
  for (Boid2D other: boids2D){
     other.display();
     //other.update();
     av_speed_sq_temp += (other.velocity.mag())*(other.velocity.mag());}
  av_speed_sq =  av_speed_sq_temp ;
  av_energy = (0.5*0.075*av_speed_sq)/(boids2D.size())*1000;
  
}
