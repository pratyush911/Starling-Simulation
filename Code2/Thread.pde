import java.util.*;
class MyThread implements Runnable { 
  int thread_num;
  public MyThread (int n) { 
    thread_num = n;
  }

  public void run() { 
   int temp_n = boids.size();
   for (int j = 0; j< temp_n/10; j++){
     boids.get(j + temp_n*thread_num/10  ).update();
   }
    
   
  } 
}
