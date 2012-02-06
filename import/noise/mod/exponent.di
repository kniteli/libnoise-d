// D import file generated from 'module\exponent.d'
module noise.mod.exponent;
private import noise.mod.modulebase;

const double DEFAULT_EXPONENT = 1;

class Exponent : Mod
{
    public 
{
    this()
{
super(GetSourceModCount());
m_exponent = DEFAULT_EXPONENT;
}
    const double GetExponent()
{
return m_exponent;
}
    override const int GetSourceModCount()
{
return 1;
}

    override const double GetValue(double x, double y, double z)
{
assert(m_pSourceMod[0] !is null);
double value = m_pSourceMod[0].GetValue(x,y,z);
return pow(fabs((value + 1) / 2),m_exponent) * 2 - 1;
}

    void SetExponent(double exponent)
{
m_exponent = exponent;
}
    protected double m_exponent;

}
}
