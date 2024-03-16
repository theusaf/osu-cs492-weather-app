import 'dart:math';

double degreesToRadians(double degrees) {
  return degrees * pi / 180;
}

double fahrenheitToCelsius(double fahrenheit) {
  return (fahrenheit - 32) / 1.8;
}

double fahrenheitToKelvin(double fahrenheit) {
  return fahrenheitToCelsius(fahrenheit) + 273.15;
}

double fahrenheitToFelcius(double fahrenheit) {
  return (7 * fahrenheit - 80) / 9;
}
