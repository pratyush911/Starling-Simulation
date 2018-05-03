import java.util.*;
import java.util.Collections;



int select_2D = 0;
int select_3D = 0;
int[] arr_2D = {250,450,400,100, 100};
int[] arr_3D = {750, 450,400,100, 30};
int[] arr_back_real = {10,10,400,100};

//  initialise_positions()
void setup() {
  size(1920, 1080, P3D);
}

void settings(){
  size(displayWidth, displayHeight, P3D);
}


void keyPressed(){
    //LURD
    if (key == 'a' && select_3D == 1){
       for (int i = 0; i<50; i++){
         
       Boid v = new Boid(mouseX, mouseY,random(300,900));
       synchronized (boids) {
       boids.add(v);
        }
       
       }
    }
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



void draw() {
  if (select_2D == 1){
    ;
  }
  else if (select_3D == 1){
    draw3D();
  }
  else{
    background(#ff8c1a);
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

void mousePressed(){
  if ((mouseY < arr_2D[1] +  arr_2D[3]) && (mouseY > arr_2D[1]) && (mouseX < arr_2D[0] + arr_2D[2]) && (mouseX > arr_2D[0])){
     select_2D = 1;
  }
  else if ((mouseY < arr_3D[1] +  arr_3D[3]) && (mouseY > arr_3D[1]) && (mouseX < arr_3D[0] + arr_3D[2]) && (mouseX > arr_3D[0])){
     select_3D = 1;
    boids = new ArrayList<Boid>();
    for(int i=0; i<1000; i++){
      //Boid v = new Boid(random(-2*width, 2*width), random(-2*height, 2*height), random(300,900));
      Boid v = new Boid(random(width/10, (9/10)*width), random(height/10, (9/10)*height), random(300,900));
      
      boids.add(v);
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
