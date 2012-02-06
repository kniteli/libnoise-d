// D import file generated from 'latlon.d'
module noise.latlon;
private 
{
    import std.math;
    import noise.mathconsts;
}
void LatLonToXYZ(double lat, double lon, ref double x, ref double y, ref double z)
{
double r = cos(DEG_TO_RAD * lat);
x = r * cos(DEG_TO_RAD * lon);
y = sin(DEG_TO_RAD * lat);
z = r * sin(DEG_TO_RAD * lon);
}
