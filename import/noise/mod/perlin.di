// D import file generated from 'module\perlin.d'
module noise.mod.perlin;
private import noise.mod.modulebase;

const double DEFAULT_PERLIN_FREQUENCY = 1;

const double DEFAULT_PERLIN_LACUNARITY = 2;

const int DEFAULT_PERLIN_OCTAVE_COUNT = 6;

const double DEFAULT_PERLIN_PERSISTENCE = 0.5;

const NoiseQuality DEFAULT_PERLIN_QUALITY = NoiseQuality.QUALITY_STD;

const int DEFAULT_PERLIN_SEED = 0;

const int PERLIN_MAX_OCTAVE = 30;

class Perlin : Mod
{
    public 
{
    this()
{
super(this.GetSourceModCount());
m_frequency = DEFAULT_PERLIN_FREQUENCY;
m_lacunarity = DEFAULT_PERLIN_LACUNARITY;
m_noiseQuality = DEFAULT_PERLIN_QUALITY;
m_octaveCount = DEFAULT_PERLIN_OCTAVE_COUNT;
m_persistence = DEFAULT_PERLIN_PERSISTENCE;
m_seed = DEFAULT_PERLIN_SEED;
}
    const double GetFrequency()
{
return m_frequency;
}
    const double GetLacunarity()
{
return m_lacunarity;
}
    const NoiseQuality GetNoiseQuality()
{
return m_noiseQuality;
}
    const int GetOctaveCount()
{
return m_octaveCount;
}
    const double GetPersistence()
{
return m_persistence;
}
    const int GetSeed()
{
return m_seed;
}
    override const int GetSourceModCount()
{
return 0;
}

    override const double GetValue(double x, double y, double z);

    void SetFrequency(double frequency)
{
m_frequency = frequency;
}
    void SetLacunarity(double lacunarity)
{
m_lacunarity = lacunarity;
}
    void SetNoiseQuality(NoiseQuality noiseQuality)
{
m_noiseQuality = noiseQuality;
}
    void SetOctaveCount(int octaveCount);
    void SetPersistence(double persistence)
{
m_persistence = persistence;
}
    void SetSeed(int seed)
{
m_seed = seed;
}
    protected 
{
    double m_frequency;
    double m_lacunarity;
    NoiseQuality m_noiseQuality;
    int m_octaveCount;
    double m_persistence;
    int m_seed;
}
}
}
