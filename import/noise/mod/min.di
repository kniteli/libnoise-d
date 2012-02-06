// D import file generated from 'module\min.d'
module noise.mod.min;
private 
{
    import noise.mod.modulebase;
    import noise.misc;
}
class Min : Mod
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
return GetMin(v0,v1);
}

}
}
