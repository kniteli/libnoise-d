// D import file generated from 'interp.d'
module noise.interp;
double CubicInterp(double n0, double n1, double n2, double n3, double a)
{
double p = n3 - n2 - (n0 - n1);
double q = n0 - n1 - p;
double r = n2 - n0;
double s = n1;
return p * a * a * a + q * a * a + r * a + s;
}
double LinearInterp(double n0, double n1, double a)
{
return (1 - a) * n0 + a * n1;
}
double SCurve3(double a)
{
return a * a * (3 - 2 * a);
}
double SCurve5(double a)
{
double a3 = a * a * a;
double a4 = a3 * a;
double a5 = a4 * a;
return 6 * a5 - 15 * a4 + 10 * a3;
}
