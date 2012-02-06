// D import file generated from 'model\cylinder.d'
module noise.model.cylinder;
private 
{
    import noise.mathconsts;
    import std.math;
    import noise.mod.modulebase;
}
class Cylinder
{
    public this()
{
m_pMod = null;
}

    public this(ref const(Mod) mod)
{
m_pMod = &mod;
}

    public ref const const(Mod) GetMod()
{
assert(m_pMod !is null);
return *m_pMod;
}


    public const double GetValue(double angle, double height)
{
assert(m_pMod !is null);
double x,y,z;
x = cos(angle * DEG_TO_RAD);
y = height;
z = sin(angle * DEG_TO_RAD);
return m_pMod.GetValue(x,y,z);
}

    public void SetMod(ref const(Mod) mod)
{
m_pMod = &mod;
}

    private const(Mod)* m_pMod;

}
