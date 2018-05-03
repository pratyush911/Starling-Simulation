import java.util.*;
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
