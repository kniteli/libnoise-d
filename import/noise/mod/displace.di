// D import file generated from 'module\displace.d'
module noise.mod.displace;
private import noise.mod.modulebase;

class Displace : Mod
{
    public 
{
    this()
{
super(this.GetSourceModCount());
}
    override const int GetSourceModCount()
{
return 4;
}

    override const double GetValue(double x, double y, double z)
{
assert(m_pSourceMod[0] !is null);
assert(m_pSourceMod[1] !is null);
assert(m_pSourceMod[2] !is null);
assert(m_pSourceMod[3] !is null);
double xDisplace = x + m_pSourceMod[1].GetValue(x,y,z);
double yDisplace = y + m_pSourceMod[2].GetValue(x,y,z);
double zDisplace = z + m_pSourceMod[3].GetValue(x,y,z);
return m_pSourceMod[0].GetValue(xDisplace,yDisplace,zDisplace);
}

    ref const const(Mod) GetXDisplaceMod();

    ref const const(Mod) GetYDisplaceMod();

    ref const const(Mod) GetZDisplaceMod();

    void SetDisplaceMods(ref const(Mod) xDisplaceMod, ref const(Mod) yDisplaceMod, ref const(Mod) zDisplaceMod)
{
SetXDisplaceMod(xDisplaceMod);
SetYDisplaceMod(yDisplaceMod);
SetZDisplaceMod(zDisplaceMod);
}
    void SetXDisplaceMod(ref const(Mod) xDisplaceMod)
{
assert(m_pSourceMod !is null);
m_pSourceMod[1] = &xDisplaceMod;
}
    void SetYDisplaceMod(ref const(Mod) yDisplaceMod)
{
assert(m_pSourceMod !is null);
m_pSourceMod[2] = &yDisplaceMod;
}
    void SetZDisplaceMod(ref const(Mod) zDisplaceMod)
{
assert(m_pSourceMod !is null);
m_pSourceMod[3] = &zDisplaceMod;
}
}
}
