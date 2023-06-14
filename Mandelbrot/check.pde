int CheckMandelbrot(double a, double b) {
  
  int n = 0;
  double tempa = a, tempb = b;
  
  for(n = 0; n < MaxIteration; n++) {
    double re = a*a - b*b + tempa;
    double im = 2*a*b + tempb;
    
    a = re;
    b = im;
    
    if(re*re + im*im > 4) {
      break;
    }
  }
  
  return n;
  
}
