// scalebias.h
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
module noise.module.scalebias;

import noise.module.modulebase;

/// @addtogroup libnoise
/// @{

/// @addtogroup modules
/// @{

/// @addtogroup modifiermodules
/// @{

/// Default bias for the module::ScaleBias noise module.
const double DEFAULT_BIAS = 0.0;

/// Default scale for the module::ScaleBias noise module.
const double DEFAULT_SCALE = 1.0;

/// Noise module that applies a scaling factor and a bias to the output
/// value from a source module.
///
/// @image html modulescalebias.png
///
/// The GetValue() method retrieves the output value from the source
/// module, multiplies it with a scaling factor, adds a bias to it, then
/// outputs the value.
///
/// This noise module requires one source module.
class ScaleBias : Module
{

  public:

    /// Constructor.
    ///
    /// The default bias is set to module::DEFAULT_BIAS.
    ///
    /// The default scaling factor is set to module::DEFAULT_SCALE.
    this()
    {
        super(this.GetSourceModuleCount ());
        m_bias = DEFAULT_BIAS;
        m_scale = DEFAULT_SCALE;
    }

    /// Returns the bias to apply to the scaled output value from the
    /// source module.
    ///
    /// @returns The bias to apply.
    ///
    /// The GetValue() method retrieves the output value from the source
    /// module, multiplies it with the scaling factor, adds the bias to
    /// it, then outputs the value.
    double GetBias () const
    {
      return m_bias;
    }

    /// Returns the scaling factor to apply to the output value from the
    /// source module.
    ///
    /// @returns The scaling factor to apply.
    ///
    /// The GetValue() method retrieves the output value from the source
    /// module, multiplies it with the scaling factor, adds the bias to
    /// it, then outputs the value.
    double GetScale () const
    {
      return m_scale;
    }

    override int GetSourceModuleCount () const
    {
      return 1;
    }

    override double GetValue (double x, double y, double z) const
    {
      assert (m_pSourceModule[0] != NULL);

      return m_pSourceModule[0].GetValue (x * m_xScale, y * m_yScale,
        z * m_zScale);
    }

    /// Sets the bias to apply to the scaled output value from the source
    /// module.
    ///
    /// @param bias The bias to apply.
    ///
    /// The GetValue() method retrieves the output value from the source
    /// module, multiplies it with the scaling factor, adds the bias to
    /// it, then outputs the value.
    void SetBias (double bias)
    {
      m_bias = bias;
    }

    /// Sets the scaling factor to apply to the output value from the
    /// source module.
    ///
    /// @param scale The scaling factor to apply.
    ///
    /// The GetValue() method retrieves the output value from the source
    /// module, multiplies it with the scaling factor, adds the bias to
    /// it, then outputs the value.
    void SetScale (double scale)
    {
      m_scale = scale;
    }

  protected:

    /// Bias to apply to the scaled output value from the source module.
    double m_bias;

    /// Scaling factor to apply to the output value from the source
    /// module.
    double m_scale;

};

/// @}

/// @}

/// @}
