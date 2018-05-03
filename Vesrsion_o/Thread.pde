import java.util.*;

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
