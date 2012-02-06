// D import file generated from 'module\max.d'
module noise.mod.max;
private 
{
    import noise.mod.modulebase;
    import noise.misc;
}
class Max : Mod
{
    public 
{
    this()
{
super(this.GetSourceModCount());
}
    override const int GetSourceModCount()
{
return 2;
}

    override const double GetValue(double x, double y, double z)
{
assert(m_pSourceMod[0] !is null);
assert(m_pSourceMod[1] !is null);
double v0 = m_pSourceMod[0].GetValue(x,y,z);
double v1 = m_pSourceMod[1].GetValue(x,y,z);
return GetMax(v0,v1);
}

}
}
