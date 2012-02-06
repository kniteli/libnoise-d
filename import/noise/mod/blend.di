// D import file generated from 'module\blend.d'
module noise.mod.blend;
private 
{
    import noise.mod.modulebase;
    import noise.interp;
}
class Blend : Mod
{
    public 
{
    this()
{
super(this.GetSourceModCount());
}
    ref const const(Mod) GetControlMod();

    override const int GetSourceModCount()
{
return 3;
}

    override const double GetValue(double x, double y, double z)
{
assert(m_pSourceMod[0] !is null);
assert(m_pSourceMod[1] !is null);
assert(m_pSourceMod[2] !is null);
double v0 = m_pSourceMod[0].GetValue(x,y,z);
double v1 = m_pSourceMod[1].GetValue(x,y,z);
double alpha = (m_pSourceMod[2].GetValue(x,y,z) + 1) / 2;
return LinearInterp(v0,v1,alpha);
}

    void SetControlMod(ref const(Mod) controlMod)
{
assert(m_pSourceMod !is null);
m_pSourceMod[2] = &controlMod;
}
}
}
