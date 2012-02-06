// D import file generated from 'module\cylinders.d'
module noise.mod.cylinders;
private 
{
    import noise.mod.modulebase;
    import noise.misc;
}
const double DEFAULT_CYLINDERS_FREQUENCY = 1;

class Cylinders : Mod
{
    public 
{
    this()
{
super(GetSourceModCount());
m_frequency = DEFAULT_CYLINDERS_FREQUENCY;
}
    const double GetFrequency()
{
return m_frequency;
}
    override const int GetSourceModCount()
{
return 0;
}

    override const double GetValue(double x, double y, double z)
{
x *= m_frequency;
z *= m_frequency;
double distFromCenter = sqrt(x * x + z * z);
double distFromSmallerSphere = distFromCenter - floor(distFromCenter);
double distFromLargerSphere = 1 - distFromSmallerSphere;
double nearestDist = GetMin(distFromSmallerSphere,distFromLargerSphere);
return 1 - nearestDist * 4;
}

    void SetFrequency(double frequency)
{
m_frequency = frequency;
}
    protected double m_frequency;

}
}
