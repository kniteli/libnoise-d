// D import file generated from 'module\billow.d'
module noise.mod.billow;
private import noise.mod.modulebase;

const double DEFAULT_BILLOW_FREQUENCY = 1;

const double DEFAULT_BILLOW_LACUNARITY = 2;

const int DEFAULT_BILLOW_OCTAVE_COUNT = 6;

const double DEFAULT_BILLOW_PERSISTENCE = 0.5;

const NoiseQuality DEFAULT_BILLOW_QUALITY = NoiseQuality.QUALITY_STD;

const int DEFAULT_BILLOW_SEED = 0;

const int BILLOW_MAX_OCTAVE = 30;

class Billow : Mod
{
    public 
{
    this()
{
super(this.GetSourceModCount());
m_frequency = DEFAULT_BILLOW_FREQUENCY;
m_lacunarity = DEFAULT_BILLOW_LACUNARITY;
m_noiseQuality = DEFAULT_BILLOW_QUALITY;
m_octaveCount = DEFAULT_BILLOW_OCTAVE_COUNT;
m_persistence = DEFAULT_BILLOW_PERSISTENCE;
m_seed = DEFAULT_BILLOW_SEED;
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
