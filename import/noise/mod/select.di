// D import file generated from 'module\select.d'
module noise.mod.select;
private 
{
    import noise.mod.modulebase;
    import noise.interp;
}
const double DEFAULT_SELECT_EDGE_FALLOFF = 0;

const double DEFAULT_SELECT_LOWER_BOUND = -1;

const double DEFAULT_SELECT_UPPER_BOUND = 1;

class Select : Mod
{
    public 
{
    this()
{
super(this.GetSourceModCount());
m_edgeFalloff = DEFAULT_SELECT_EDGE_FALLOFF;
m_lowerBound = DEFAULT_SELECT_LOWER_BOUND;
m_upperBound = DEFAULT_SELECT_UPPER_BOUND;
}
    ref const const(Mod) GetControlMod();

    const double GetEdgeFalloff()
{
return m_edgeFalloff;
}
    const double GetLowerBound()
{
return m_lowerBound;
}
    override const int GetSourceModCount()
{
return 3;
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
SetEdgeFalloff(m_edgeFalloff);
}
    void SetControlMod(ref const(Mod) controlMod)
{
assert(m_pSourceMod !is null);
m_pSourceMod[2] = &controlMod;
}
    void SetEdgeFalloff(double edgeFalloff)
{
double boundSize = m_upperBound - m_lowerBound;
m_edgeFalloff = edgeFalloff > boundSize / 2 ? boundSize / 2 : edgeFalloff;
}
    protected 
{
    double m_edgeFalloff;
    double m_lowerBound;
    double m_upperBound;
}
}
}
