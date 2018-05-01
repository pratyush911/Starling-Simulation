import java.util.*;
class MyThread implements Runnable { 
  Boid other;
  public MyThread (Boid boid_init) { 
    other = boid_init;
  }

  public void run() { 
   
    other.update();
   
  } 
}
