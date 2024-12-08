float MandelColor(int n) {
  
  float hu = ((1000 * n / MaxIteration) + 180) % 360 ;
  
  return hu;
}
