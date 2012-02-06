// D import file generated from 'module\ridgedmulti.d'
module noise.mod.ridgedmulti;
private import noise.mod.modulebase;

const double DEFAULT_RIDGED_FREQUENCY = 1;

const double DEFAULT_RIDGED_LACUNARITY = 2;

const int DEFAULT_RIDGED_OCTAVE_COUNT = 6;

const NoiseQuality DEFAULT_RIDGED_QUALITY = NoiseQuality.QUALITY_STD;

const int DEFAULT_RIDGED_SEED = 0;

const int RIDGED_MAX_OCTAVE = 30;

class RidgedMulti : Mod
{
    public 
{
    this()
{
super(this.GetSourceModCount());
m_frequency = DEFAULT_RIDGED_FREQUENCY;
m_lacunarity = DEFAULT_RIDGED_LACUNARITY;
m_noiseQuality = DEFAULT_RIDGED_QUALITY;
m_octaveCount = DEFAULT_RIDGED_OCTAVE_COUNT;
m_seed = DEFAULT_RIDGED_SEED;
this.CalcSpectralWeights();
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
CalcSpectralWeights();
}
    void SetNoiseQuality(NoiseQuality noiseQuality)
{
m_noiseQuality = noiseQuality;
}
    void SetOctaveCount(int octaveCount);
    void SetSeed(int seed)
{
m_seed = seed;
}
    protected 
{
    void CalcSpectralWeights();
    double m_frequency;
    double m_lacunarity;
    NoiseQuality m_noiseQuality;
    int m_octaveCount;
    double[RIDGED_MAX_OCTAVE] m_pSpectralWeights;
    int m_seed;
}
}
}
