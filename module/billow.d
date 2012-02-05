// billow.h
//
// Copyright (C) 2004 Jason Bevins
//
// This library is free software; you can redistribute it and/or modify it
// under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation; either version 2.1 of the License, or (at
// your option) any later version.
//
// This library is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
// FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public
// License (COPYING.txt) for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with this library; if not, write to the Free Software Foundation,
// Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
//
// The developer's email is jlbezigvins@gmzigail.com (for great email, take
// off every 'zig'.)
//
module noise.module.billow;

import noise.module.modulebase;

/// @addtogroup libnoise
/// @{

/// @addtogroup modules
/// @{

/// @addtogroup generatormodules
/// @{

/// Default frequency for the noise::module::Billow noise module.
const double DEFAULT_BILLOW_FREQUENCY = 1.0;

/// Default lacunarity for the the noise::module::Billow noise module.
const double DEFAULT_BILLOW_LACUNARITY = 2.0;

/// Default number of octaves for the the noise::module::Billow noise
/// module.
const int DEFAULT_BILLOW_OCTAVE_COUNT = 6;

/// Default persistence value for the the noise::module::Billow noise
/// module.
const double DEFAULT_BILLOW_PERSISTENCE = 0.5;

/// Default noise quality for the the noise::module::Billow noise module.
const NoiseQuality DEFAULT_BILLOW_QUALITY = QUALITY_STD;

/// Default noise seed for the the noise::module::Billow noise module.
const int DEFAULT_BILLOW_SEED = 0;

/// Maximum number of octaves for the the noise::module::Billow noise
/// module.
const int BILLOW_MAX_OCTAVE = 30;

/// Noise module that outputs three-dimensional "billowy" noise.
///
/// @image html modulebillow.png
///
/// This noise module generates "billowy" noise suitable for clouds and
/// rocks.
///
/// This noise module is nearly identical to noise::module::Perlin except
/// this noise module modifies each octave with an absolute-value
/// function.  See the documentation of noise::module::Perlin for more
/// information.
class Billow : Module
{

  public:

    /// Constructor.
    ///
    /// The default frequency is set to
    /// noise::module::DEFAULT_BILLOW_FREQUENCY.
    ///
    /// The default lacunarity is set to
    /// noise::module::DEFAULT_BILLOW_LACUNARITY.
    ///
    /// The default number of octaves is set to
    /// noise::module::DEFAULT_BILLOW_OCTAVE_COUNT.
    ///
    /// The default persistence value is set to
    /// noise::module::DEFAULT_BILLOW_PERSISTENCE.
    ///
    /// The default seed value is set to
    /// noise::module::DEFAULT_BILLOW_SEED.
    this () 
    {
        super(this.GetSourceModuleCount());
        m_frequency = DEFAULT_BILLOW_FREQUENCY;
        m_lacunarity = DEFAULT_BILLOW_LACUNARITY;
        m_noiseQuality = DEFAULT_BILLOW_QUALITY;
        m_octaveCount = DEFAULT_BILLOW_OCTAVE_COUNT;
        m_persistence = DEFAULT_BILLOW_PERSISTENCE;
        m_seed = DEFAULT_BILLOW_SEED;
    }

    /// Returns the frequency of the first octave.
    ///
    /// @returns The frequency of the first octave.
    double GetFrequency () const
    {
      return m_frequency;
    }

    /// Returns the lacunarity of the billowy noise.
    ///
    /// @returns The lacunarity of the billowy noise.
    /// 
    /// The lacunarity is the frequency multiplier between successive
    /// octaves.
    double GetLacunarity () const
    {
      return m_lacunarity;
    }

    /// Returns the quality of the billowy noise.
    ///
    /// @returns The quality of the billowy noise.
    ///
    /// See noise::NoiseQuality for definitions of the various
    /// coherent-noise qualities.
    NoiseQuality GetNoiseQuality () const
    {
      return m_noiseQuality;
    }

    /// Returns the number of octaves that generate the billowy noise.
    ///
    /// @returns The number of octaves that generate the billowy noise.
    ///
    /// The number of octaves controls the amount of detail in the billowy
    /// noise.
    int GetOctaveCount () const
    {
      return m_octaveCount;
    }

    /// Returns the persistence value of the billowy noise.
    ///
    /// @returns The persistence value of the billowy noise.
    ///
    /// The persistence value controls the roughness of the billowy noise.
    double GetPersistence () const
    {
      return m_persistence;
    }

    /// Returns the seed value used by the billowy-noise function.
    ///
    /// @returns The seed value.
    int GetSeed () const
    {
      return m_seed;
    }

    override int GetSourceModuleCount () const
    {
      return 0;
    }

    override double GetValue (double x, double y, double z) const
    {
      double value = 0.0;
      double signal = 0.0;
      double curPersistence = 1.0;
      double nx, ny, nz;
      int seed;

      x *= m_frequency;
      y *= m_frequency;
      z *= m_frequency;

      for (int curOctave = 0; curOctave < m_octaveCount; curOctave++) {

        // Make sure that these floating-point values have the same range as a 32-
        // bit integer so that we can pass them to the coherent-noise functions.
        nx = MakeInt32Range (x);
        ny = MakeInt32Range (y);
        nz = MakeInt32Range (z);

        // Get the coherent-noise value from the input value and add it to the
        // final result.
        seed = (m_seed + curOctave) & 0xffffffff;
        signal = GradientCoherentNoise3D (nx, ny, nz, seed, m_noiseQuality);
        signal = 2.0 * fabs (signal) - 1.0;
        value += signal * curPersistence;

        // Prepare the next octave.
        x *= m_lacunarity;
        y *= m_lacunarity;
        z *= m_lacunarity;
        curPersistence *= m_persistence;
      }
      value += 0.5;

      return value;
    }

    /// Sets the frequency of the first octave.
    ///
    /// @param frequency The frequency of the first octave.
    void SetFrequency (double frequency)
    {
      m_frequency = frequency;
    }

    /// Sets the lacunarity of the billowy noise.
    ///
    /// @param lacunarity The lacunarity of the billowy noise.
    /// 
    /// The lacunarity is the frequency multiplier between successive
    /// octaves.
    ///
    /// For best results, set the lacunarity to a number between 1.5 and
    /// 3.5.
    void SetLacunarity (double lacunarity)
    {
      m_lacunarity = lacunarity;
    }

    /// Sets the quality of the billowy noise.
    ///
    /// @param noiseQuality The quality of the billowy noise.
    ///
    /// See noise::NoiseQuality for definitions of the various
    /// coherent-noise qualities.
    void SetNoiseQuality (NoiseQuality noiseQuality)
    {
      m_noiseQuality = noiseQuality;
    }

    /// Sets the number of octaves that generate the billowy noise.
    ///
    /// @param octaveCount The number of octaves that generate the billowy
    /// noise.
    ///
    /// @pre The number of octaves ranges from 1 to
    /// noise::module::BILLOW_MAX_OCTAVE.
    ///
    /// @throw noise::ExceptionInvalidParam An invalid parameter was
    /// specified; see the preconditions for more information.
    ///
    /// The number of octaves controls the amount of detail in the billowy
    /// noise.
    ///
    /// The larger the number of octaves, the more time required to
    /// calculate the billowy-noise value.
    void SetOctaveCount (int octaveCount)
    {
      if (octaveCount < 1 || octaveCount > BILLOW_MAX_OCTAVE) {
        throw ExceptionInvalidParam ();
      }
      m_octaveCount = octaveCount;
    }

    /// Sets the persistence value of the billowy noise.
    ///
    /// @param persistence The persistence value of the billowy noise.
    ///
    /// The persistence value controls the roughness of the billowy noise.
    ///
    /// For best results, set the persistence value to a number between
    /// 0.0 and 1.0.
    void SetPersistence (double persistence)
    {
      m_persistence = persistence;
    }

    /// Sets the seed value used by the billowy-noise function.
    ///
    /// @param seed The seed value.
    void SetSeed (int seed)
    {
      m_seed = seed;
    }

  protected:

    /// Frequency of the first octave.
    double m_frequency;

    /// Frequency multiplier between successive octaves.
    double m_lacunarity;

    /// Quality of the billowy noise.
    NoiseQuality m_noiseQuality;

    /// Total number of octaves that generate the billowy noise.
    int m_octaveCount;

    /// Persistence value of the billowy noise.
    double m_persistence;

    /// Seed value used by the billowy-noise function.
    int m_seed;

}

/// @}

/// @}

/// @}
