// D import file generated from 'module\multiply.d'
module noise.mod.multiply;
private import noise.mod.modulebase;

class Multiply : Mod
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
return m_pSourceMod[0].GetValue(x,y,z) * m_pSourceMod[1].GetValue(x,y,z);
}

}
}
