// D import file generated from 'model\plane.d'
module noise.model.plane;
private import noise.mod.modulebase;

class Plane
{
    public 
{
    this()
{
m_pMod = null;
}
    this(ref const(Mod) mod)
{
m_pMod = &mod;
}
    ref const const(Mod) GetMod()
{
assert(m_pMod !is null);
return *m_pMod;
}

    const double GetValue(double x, double z)
{
assert(m_pMod !is null);
return m_pMod.GetValue(x,0,z);
}
    void SetMod(ref const(Mod) mod)
{
m_pMod = &mod;
}
    private const(Mod)* m_pMod;

}
}
