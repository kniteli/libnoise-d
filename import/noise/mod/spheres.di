// D import file generated from 'module\spheres.d'
module noise.mod.spheres;
private 
{
    import noise.mod.modulebase;
    import noise.misc;
}
const double DEFAULT_SPHERES_FREQUENCY = 1;

class Spheres : Mod
{
    public 
{
    this()
{
super(this.GetSourceModCount());
m_frequency = DEFAULT_SPHERES_FREQUENCY;
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
y *= m_frequency;
z *= m_frequency;
double distFromCenter = sqrt(x * x + y * y + z * z);
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
