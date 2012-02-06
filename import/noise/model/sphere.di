// D import file generated from 'model\sphere.d'
module noise.model.sphere;
private 
{
    import noise.mod.modulebase;
    import noise.latlon;
}
class Sphere
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

    const double GetValue(double lat, double lon)
{
assert(m_pMod !is null);
double x,y,z;
LatLonToXYZ(lat,lon,x,y,z);
return m_pMod.GetValue(x,y,z);
}
    void SetMod(ref const(Mod) mod)
{
m_pMod = &mod;
}
    private const(Mod)* m_pMod;

}
}
