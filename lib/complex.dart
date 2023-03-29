import 'dart:math';

class Complex {
  final double real;
  final double imag;

  const Complex(this.real, this.imag);

  // Complex number addition
  Complex operator +(Complex other) {
    return Complex(this.real + other.real, this.imag + other.imag);
  }

  // Complex number subtraction
  Complex operator -(Complex other) {
    return Complex(this.real - other.real, this.imag - other.imag);
  }

  // Complex number multiplication
  Complex operator *(Complex other) {
    return Complex(
      this.real * other.real - this.imag * other.imag,
      this.real * other.imag + this.imag * other.real,
    );
  }

  // Complex number division
  Complex operator /(Complex other) {
    double denominator = other.real * other.real + other.imag * other.imag;
    return Complex(
      (this.real * other.real + this.imag * other.imag) / denominator,
      (this.imag * other.real - this.real * other.imag) / denominator,
    );
  }

  // Magnitude (absolute value) of the complex number
  double abs() {
    return sqrt(real * real + imag * imag);
  }

  // Create a complex number with polar coordinates
  static Complex polar(double magnitude, double angle) {
    return Complex(magnitude * cos(angle), magnitude * sin(angle));
  }

  // Represent the complex number as a string
  @override
  String toString() {
    return '(${real.toStringAsFixed(2)}, ${imag.toStringAsFixed(2)}i)';
  }

  // Zero complex number
  static Complex zero() => Complex(0, 0);
}
