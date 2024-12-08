class Complex {
  double re, im;

  Complex(double re, double im) {
    this.re = re;
    this.im = im;
  }

  Complex add(Complex ot) {
    double nre = this.re + ot.re;
    double nim = this.im + ot.im;
    return new Complex(nre, nim);
  }

  Complex mul(Complex ot) {
    double nre = this.re * ot.re - this.im * ot.im;
    double nim = this.re * ot.im + this.im * ot.re;
    return new Complex(nre, nim);
  }
  
  Complex scholorMul(double i) {
    this.re *= i;
    this.im *= i;
    return this;
  }
  
  Complex recip() {
    return this.conj().scholorMul(1.0 / this.normsq());
  }
  
  Complex div(Complex ot) {
    return this.mul(ot.recip());
  }

  double normsq() {
    return this.re * this.re + this.im * this.im;
  }

  double norm() {
    return Math.sqrt(this.re * this.re + this.im * this.im);
  }
  
  Complex conj() {
    return new Complex(this.re, -this.im);
  }
  
  double arg() {
    return Math.atan2(this.im, this.re);
  }


  String toString() {
    return this.re + " + " + this.im + "i";
  }
}
