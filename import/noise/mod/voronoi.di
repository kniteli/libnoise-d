// D import file generated from 'module\voronoi.d'
module noise.mod.voronoi;
private 
{
    import noise.mod.modulebase;
    import noise.mathconsts;
}
const double DEFAULT_VORONOI_DISPLACEMENT = 1;

const double DEFAULT_VORONOI_FREQUENCY = 1;

const int DEFAULT_VORONOI_SEED = 0;

class Voronoi : Mod
{
    public 
{
    this()
{
super(this.GetSourceModCount());
m_displacement = DEFAULT_VORONOI_DISPLACEMENT;
m_enableDistance = false;
m_frequency = DEFAULT_VORONOI_FREQUENCY;
m_seed = DEFAULT_VORONOI_SEED;
}
    void EnableDistance(bool enable = true)
{
m_enableDistance = enable;
}
    const double GetDisplacement()
{
return m_displacement;
}
    const double GetFrequency()
{
return m_frequency;
}
    override const int GetSourceModCount()
{
return 0;
}

    const int GetSeed()
{
return m_seed;
}
    const bool IsDistanceEnabled()
{
return m_enableDistance;
}
    override const double GetValue(double x, double y, double z);

    void SetDisplacement(double displacement)
{
m_displacement = displacement;
}
    void SetFrequency(double frequency)
{
m_frequency = frequency;
}
    void SetSeed(int seed)
{
m_seed = seed;
}
    protected 
{
    double m_displacement;
    bool m_enableDistance;
    double m_frequency;
    int m_seed;
}
}
}
