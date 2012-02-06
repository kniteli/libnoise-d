// D import file generated from 'module\scalebias.d'
module noise.mod.scalebias;
private import noise.mod.modulebase;

const double DEFAULT_BIAS = 0;

const double DEFAULT_SCALE = 1;

class ScaleBias : Mod
{
    public 
{
    this()
{
super(this.GetSourceModCount());
m_bias = DEFAULT_BIAS;
m_scale = DEFAULT_SCALE;
}
    const double GetBias()
{
return m_bias;
}
    const double GetScale()
{
return m_scale;
}
    override const int GetSourceModCount()
{
return 1;
}

    override const double GetValue(double x, double y, double z)
{
assert(m_pSourceMod[0] !is null);
return m_pSourceMod[0].GetValue(x,y,z) * m_scale + m_bias;
}

    void SetBias(double bias)
{
m_bias = bias;
}
    void SetScale(double scale)
{
m_scale = scale;
}
    protected 
{
    double m_bias;
    double m_scale;
}
}
}
