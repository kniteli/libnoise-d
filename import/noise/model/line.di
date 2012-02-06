// D import file generated from 'model\line.d'
module noise.model.line;
private 
{
    import std.math;
    import noise.mod.modulebase;
}
class Line
{
    public 
{
    this()
{
m_attenuate = true;
m_pMod = null;
m_x0 = 0;
m_x1 = 1;
m_y0 = 0;
m_y1 = 1;
m_z0 = 0;
m_z1 = 1;
}
    this(ref const(Mod) mod)
{
m_attenuate = true;
m_pMod = &mod;
m_x0 = 0;
m_x1 = 1;
m_y0 = 0;
m_y1 = 1;
m_z0 = 0;
m_z1 = 1;
}
    const bool GetAttenuate()
{
return m_attenuate;
}
    ref const const(Mod) GetMod()
{
assert(m_pMod !is null);
return *m_pMod;
}

    const double GetValue(double p);
    void SetAttenuate(bool att)
{
m_attenuate = att;
}
    void SetEndPoint(double x, double y, double z)
{
m_x1 = x;
m_y1 = y;
m_z1 = z;
}
    void SetMod(ref const(Mod) mod)
{
m_pMod = &mod;
}
    void SetStartPoint(double x, double y, double z)
{
m_x0 = x;
m_y0 = y;
m_z0 = z;
}
    private 
{
    bool m_attenuate;
    const(Mod)* m_pMod;
    double m_x0;
    double m_x1;
    double m_y0;
    double m_y1;
    double m_z0;
    double m_z1;
}
}
}
