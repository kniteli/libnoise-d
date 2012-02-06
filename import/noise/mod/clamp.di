// D import file generated from 'module\clamp.d'
module noise.mod.clamp;
private import noise.mod.modulebase;

const double DEFAULT_CLAMP_LOWER_BOUND = -1;

const double DEFAULT_CLAMP_UPPER_BOUND = 1;

class Clamp : Mod
{
    public 
{
    this()
{
super(this.GetSourceModCount());
m_lowerBound = DEFAULT_CLAMP_LOWER_BOUND;
m_upperBound = DEFAULT_CLAMP_UPPER_BOUND;
}
    const double GetLowerBound()
{
return m_lowerBound;
}
    override const int GetSourceModCount()
{
return 1;
}

    const double GetUpperBound()
{
return m_upperBound;
}
    override const double GetValue(double x, double y, double z);

    void SetBounds(double lowerBound, double upperBound)
{
assert(lowerBound < upperBound);
m_lowerBound = lowerBound;
m_upperBound = upperBound;
}
    protected 
{
    double m_lowerBound;
    double m_upperBound;
}
}
}
