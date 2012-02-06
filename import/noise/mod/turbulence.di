// D import file generated from 'module\turbulence.d'
module noise.mod.turbulence;
private 
{
    import noise.mod.modulebase;
    import noise.mod.perlin;
}
const double DEFAULT_TURBULENCE_FREQUENCY = DEFAULT_PERLIN_FREQUENCY;

const double DEFAULT_TURBULENCE_POWER = 1;

const int DEFAULT_TURBULENCE_ROUGHNESS = 3;

const int DEFAULT_TURBULENCE_SEED = DEFAULT_PERLIN_SEED;

class Turbulence : Mod
{
    public 
{
    this()
{
super(this.GetSourceModCount());
m_power = DEFAULT_TURBULENCE_POWER;
SetSeed(DEFAULT_TURBULENCE_SEED);
SetFrequency(DEFAULT_TURBULENCE_FREQUENCY);
SetRoughness(DEFAULT_TURBULENCE_ROUGHNESS);
}
    const double GetFrequency()
{
return m_xDistortMod.GetFrequency();
}
    const double GetPower()
{
return m_power;
}
    const int GetRoughnessCount()
{
return m_xDistortMod.GetOctaveCount();
}
    const int GetSeed()
{
return m_xDistortMod.GetSeed();
}
    override const int GetSourceModCount()
{
return 1;
}

    override const double GetValue(double x, double y, double z)
{
assert(m_pSourceMod[0] !is null);
double x0,y0,z0;
double x1,y1,z1;
double x2,y2,z2;
x0 = x + 12414 / 65536;
y0 = y + 65124 / 65536;
z0 = z + 31337 / 65536;
x1 = x + 26519 / 65536;
y1 = y + 18128 / 65536;
z1 = z + 60493 / 65536;
x2 = x + 53820 / 65536;
y2 = y + 11213 / 65536;
z2 = z + 44845 / 65536;
double xDistort = x + m_xDistortMod.GetValue(x0,y0,z0) * m_power;
double yDistort = y + m_yDistortMod.GetValue(x1,y1,z1) * m_power;
double zDistort = z + m_zDistortMod.GetValue(x2,y2,z2) * m_power;
return m_pSourceMod[0].GetValue(xDistort,yDistort,zDistort);
}

    void SetFrequency(double frequency)
{
m_xDistortMod.SetFrequency(frequency);
m_yDistortMod.SetFrequency(frequency);
m_zDistortMod.SetFrequency(frequency);
}
    void SetPower(double power)
{
m_power = power;
}
    void SetRoughness(int roughness)
{
m_xDistortMod.SetOctaveCount(roughness);
m_yDistortMod.SetOctaveCount(roughness);
m_zDistortMod.SetOctaveCount(roughness);
}
    void SetSeed(int seed)
{
m_xDistortMod.SetSeed(seed);
m_yDistortMod.SetSeed(seed + 1);
m_zDistortMod.SetSeed(seed + 2);
}
    protected 
{
    double m_power;
    Perlin m_xDistortMod;
    Perlin m_yDistortMod;
    Perlin m_zDistortMod;
}
}
}
