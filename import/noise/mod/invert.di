// D import file generated from 'module\invert.d'
module noise.mod.invert;
private import noise.mod.modulebase;

class Invert : Mod
{
    public 
{
    this()
{
super(this.GetSourceModCount());
}
    override const int GetSourceModCount()
{
return 1;
}

    override const double GetValue(double x, double y, double z)
{
assert(m_pSourceMod[0] !is null);
return -m_pSourceMod[0].GetValue(x,y,z);
}

}
}
