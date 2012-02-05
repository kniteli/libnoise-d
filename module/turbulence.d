// turbulence.h
//
// Copyright (C) 2003, 2004 Jason Bevins
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
module noise.module.translatepoint;

import noise.module.modulebase;
import noise.module.perlin;

/// @addtogroup libnoise
/// @{

/// @addtogroup modules
/// @{

/// @addtogroup transformermodules
/// @{

/// Default frequency for the module::Turbulence noise module.
const double DEFAULT_TURBULENCE_FREQUENCY = DEFAULT_PERLIN_FREQUENCY;

/// Default power for the module::Turbulence noise module.
const double DEFAULT_TURBULENCE_POWER = 1.0;

/// Default roughness for the module::Turbulence noise module.
const int DEFAULT_TURBULENCE_ROUGHNESS = 3;

/// Default noise seed for the module::Turbulence noise module.
const int DEFAULT_TURBULENCE_SEED = DEFAULT_PERLIN_SEED;

/// Noise module that randomly displaces the input value before
/// returning the output value from a source module.
///
/// @image html moduleturbulence.png
///
/// @a Turbulence is the pseudo-random displacement of the input value.
/// The GetValue() method randomly displaces the ( @a x, @a y, @a z )
/// coordinates of the input value before retrieving the output value from
/// the source module.  To control the turbulence, an application can
/// modify its frequency, its power, and its roughness.
///
/// The frequency of the turbulence determines how rapidly the
/// displacement amount changes.  To specify the frequency, call the
/// SetFrequency() method.
///
/// The power of the turbulence determines the scaling factor that is
/// applied to the displacement amount.  To specify the power, call the
/// SetPower() method.
///
/// The roughness of the turbulence determines the roughness of the
/// changes to the displacement amount.  Low values smoothly change the
/// displacement amount.  High values roughly change the displacement
/// amount, which produces more "kinky" changes.  To specify the
/// roughness, call the SetRoughness() method.
///
/// Use of this noise module may require some trial and error.  Assuming
/// that you are using a generator module as the source module, you
/// should first:
/// - Set the frequency to the same frequency as the source module.
/// - Set the power to the reciprocal of the frequency.
///
/// From these initial frequency and power values, modify these values
/// until this noise module produce the desired changes in your terrain or
/// texture.  For example:
/// - Low frequency (1/8 initial frequency) and low power (1/8 initial
///   power) produces very minor, almost unnoticeable changes.
/// - Low frequency (1/8 initial frequency) and high power (8 times
///   initial power) produces "ropey" lava-like terrain or marble-like
///   textures.
/// - High frequency (8 times initial frequency) and low power (1/8
///   initial power) produces a noisy version of the initial terrain or
///   texture.
/// - High frequency (8 times initial frequency) and high power (8 times
///   initial power) produces nearly pure noise, which isn't entirely
///   useful.
///
/// Displacing the input values result in more realistic terrain and
/// textures.  If you are generating elevations for terrain height maps,
/// you can use this noise module to produce more realistic mountain
/// ranges or terrain features that look like flowing lava rock.  If you
/// are generating values for textures, you can use this noise module to
/// produce realistic marble-like or "oily" textures.
///
/// Internally, there are three module::Perlin noise modules
/// that displace the input value; one for the @a x, one for the @a y,
/// and one for the @a z coordinate.
///
/// This noise module requires one source module.
class Turbulence : Module
{

  public:

    /// Constructor.
    ///
    /// The default frequency is set to
    /// module::DEFAULT_TURBULENCE_FREQUENCY.
    ///    
    /// The default power is set to
    /// module::DEFAULT_TURBULENCE_POWER.
    ///
    /// The default roughness is set to
    /// module::DEFAULT_TURBULENCE_ROUGHNESS.
    ///
    /// The default seed value is set to
    /// module::DEFAULT_TURBULENCE_SEED.
    this()
    {
        super(this.GetSourceModuleCount());
        m_power = DEFAULT_TURBULENCE_POWER;
        SetSeed (DEFAULT_TURBULENCE_SEED);
        SetFrequency (DEFAULT_TURBULENCE_FREQUENCY);
        SetRoughness (DEFAULT_TURBULENCE_ROUGHNESS);
    }

    /// Returns the frequency of the turbulence.
    ///
    /// @returns The frequency of the turbulence.
    ///
    /// The frequency of the turbulence determines how rapidly the
    /// displacement amount changes.
    double GetFrequency () const
    {
      // Since each module::Perlin noise module has the same frequency, it
      // does not matter which module we use to retrieve the frequency.
      return m_xDistortModule.GetFrequency ();
    }

    /// Returns the power of the turbulence.
    ///
    /// @returns The power of the turbulence.
    ///
    /// The power of the turbulence determines the scaling factor that is
    /// applied to the displacement amount.
    double GetPower () const
    {
      return m_power;
    }

    /// Returns the roughness of the turbulence.
    ///
    /// @returns The roughness of the turbulence.
    ///
    /// The roughness of the turbulence determines the roughness of the
    /// changes to the displacement amount.  Low values smoothly change
    /// the displacement amount.  High values roughly change the
    /// displacement amount, which produces more "kinky" changes.
    int GetRoughnessCount () const
    {
      return m_xDistortModule.GetOctaveCount ();
    }

    /// Returns the seed value of the internal Perlin-noise modules that
    /// are used to displace the input values.
    ///
    /// @returns The seed value.
    ///
    /// Internally, there are three module::Perlin noise modules
    /// that displace the input value; one for the @a x, one for the @a y,
    /// and one for the @a z coordinate.  
    int GetSeed () const
    {
      return m_xDistortModule.GetSeed ();
    }

    override int GetSourceModuleCount () const
    {
      return 1;
    }

    override double GetValue (double x, double y, double z) const
    {
      assert (m_pSourceModule[0] != NULL);

      // Get the values from the three module::Perlin noise modules and
      // add each value to each coordinate of the input value.  There are also
      // some offsets added to the coordinates of the input values.  This prevents
      // the distortion modules from returning zero if the (x, y, z) coordinates,
      // when multiplied by the frequency, are near an integer boundary.  This is
      // due to a property of gradient coherent noise, which returns zero at
      // integer boundaries.
      double x0, y0, z0;
      double x1, y1, z1;
      double x2, y2, z2;
      x0 = x + (12414.0 / 65536.0);
      y0 = y + (65124.0 / 65536.0);
      z0 = z + (31337.0 / 65536.0);
      x1 = x + (26519.0 / 65536.0);
      y1 = y + (18128.0 / 65536.0);
      z1 = z + (60493.0 / 65536.0);
      x2 = x + (53820.0 / 65536.0);
      y2 = y + (11213.0 / 65536.0);
      z2 = z + (44845.0 / 65536.0);
      double xDistort = x + (m_xDistortModule.GetValue (x0, y0, z0)
        * m_power);
      double yDistort = y + (m_yDistortModule.GetValue (x1, y1, z1)
        * m_power);
      double zDistort = z + (m_zDistortModule.GetValue (x2, y2, z2)
        * m_power);

      // Retrieve the output value at the offsetted input value instead of the
      // original input value.
      return m_pSourceModule[0].GetValue (xDistort, yDistort, zDistort);
    }

    /// Sets the frequency of the turbulence.
    ///
    /// @param frequency The frequency of the turbulence.
    ///
    /// The frequency of the turbulence determines how rapidly the
    /// displacement amount changes.
    void SetFrequency (double frequency)
    {
      // Set the frequency of each Perlin-noise module.
      m_xDistortModule.SetFrequency (frequency);
      m_yDistortModule.SetFrequency (frequency);
      m_zDistortModule.SetFrequency (frequency);
    }

    /// Sets the power of the turbulence.
    ///
    /// @param power The power of the turbulence.
    ///
    /// The power of the turbulence determines the scaling factor that is
    /// applied to the displacement amount.
    void SetPower (double power)
    {
      m_power = power;
    }

    /// Sets the roughness of the turbulence.
    ///
    /// @param roughness The roughness of the turbulence.
    ///
    /// The roughness of the turbulence determines the roughness of the
    /// changes to the displacement amount.  Low values smoothly change
    /// the displacement amount.  High values roughly change the
    /// displacement amount, which produces more "kinky" changes.
    ///
    /// Internally, there are three module::Perlin noise modules
    /// that displace the input value; one for the @a x, one for the @a y,
    /// and one for the @a z coordinate.  The roughness value is equal to
    /// the number of octaves used by the module::Perlin noise
    /// modules.
    void SetRoughness (int roughness)
    {
      // Set the octave count for each Perlin-noise module.
      m_xDistortModule.SetOctaveCount (roughness);
      m_yDistortModule.SetOctaveCount (roughness);
      m_zDistortModule.SetOctaveCount (roughness);
    }

    /// Sets the seed value of the internal noise modules that are used to
    /// displace the input values.
    ///
    /// @param seed The seed value.
    ///
    /// Internally, there are three module::Perlin noise modules
    /// that displace the input value; one for the @a x, one for the @a y,
    /// and one for the @a z coordinate.  This noise module assigns the
    /// following seed values to the module::Perlin noise modules:
    /// - It assigns the seed value (@a seed + 0) to the @a x noise module.
    /// - It assigns the seed value (@a seed + 1) to the @a y noise module.
    /// - It assigns the seed value (@a seed + 2) to the @a z noise module.
    void SetSeed (int seed)
    {
      // Set the seed of each module::Perlin noise modules.  To prevent any
      // sort of weird artifacting, use a slightly different seed for each noise
      // module.
      m_xDistortModule.SetSeed (seed    );
      m_yDistortModule.SetSeed (seed + 1);
      m_zDistortModule.SetSeed (seed + 2);
    }

  protected:

    /// The power (scale) of the displacement.
    double m_power;

    /// Noise module that displaces the @a x coordinate.
    Perlin m_xDistortModule;

    /// Noise module that displaces the @a y coordinate.
    Perlin m_yDistortModule;

    /// Noise module that displaces the @a z coordinate.
    Perlin m_zDistortModule;

};

/// @}

/// @}

/// @}
