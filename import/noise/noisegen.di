// D import file generated from 'noisegen.d'
module noise.noisegen;
import noise.interp;
import noise.vectortable;
import noise.basictypes;
import std.math;
const int NOISE_VERSION = 2;

static if(NOISE_VERSION == 1)
{
    const int X_NOISE_GEN = 1;

    const int Y_NOISE_GEN = 31337;

    const int Z_NOISE_GEN = 263;

    const int SEED_NOISE_GEN = 1013;

    const int SHIFT_NOISE_GEN = 13;

}
else
{
    const int X_NOISE_GEN = 1619;

    const int Y_NOISE_GEN = 31337;

    const int Z_NOISE_GEN = 6971;

    const int SEED_NOISE_GEN = 1013;

    const int SHIFT_NOISE_GEN = 8;

}
enum NoiseQuality 
{
QUALITY_FAST = 0,
QUALITY_STD = 1,
QUALITY_BEST = 2,
}
double GradientCoherentNoise3D(double x, double y, double z, int seed = 0, NoiseQuality noiseQuality = NoiseQuality.QUALITY_STD);
double GradientNoise3D(double fx, double fy, double fz, int ix, int iy, int iz, int seed = 0)
{
int vectorIndex = X_NOISE_GEN * ix + Y_NOISE_GEN * iy + Z_NOISE_GEN * iz + SEED_NOISE_GEN * seed & -1u;
vectorIndex ^= vectorIndex >> SHIFT_NOISE_GEN;
vectorIndex &= 255;
double xvGradient = g_randomVectors[vectorIndex << 2];
double yvGradient = g_randomVectors[(vectorIndex << 2) + 1];
double zvGradient = g_randomVectors[(vectorIndex << 2) + 2];
double xvPoint = fx - cast(double)ix;
double yvPoint = fy - cast(double)iy;
double zvPoint = fz - cast(double)iz;
return (xvGradient * xvPoint + yvGradient * yvPoint + zvGradient * zvPoint) * 2.12;
}
int IntValueNoise3D(int x, int y, int z, int seed = 0)
{
int n = X_NOISE_GEN * x + Y_NOISE_GEN * y + Z_NOISE_GEN * z + SEED_NOISE_GEN * seed & 2147483647;
n = n >> 13 ^ n;
return n * (n * n * 60493 + 19990303) + 1376312589 & 2147483647;
}
double MakeInt32Range(double n);
double ValueCoherentNoise3D(double x, double y, double z, int seed = 0, NoiseQuality noiseQuality = NoiseQuality.QUALITY_STD);
double ValueNoise3D(int x, int y, int z, int seed = 0)
{
return 1 - cast(double)IntValueNoise3D(x,y,z,seed) / 0x1p+30;
}
