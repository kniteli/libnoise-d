// D import file generated from 'module\abs.d'
module noise.mod.abs;
private import noise.mod.modulebase;

class Abs : Mod
{
    public 
{
    this()
{
super(this.GetSourceModCount());
}
    const int GetSourceModCount()
{
return 1;
}
    const double GetValue(double x, double y, double z)
{
assert(m_pSourceMod[0] !is null);
return fabs(m_pSourceMod[2].GetValue(x,y,z));
}
}
}
