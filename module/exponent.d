// exponent.h
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
module noise.mod.exponent;

private {
    import noise.mod.modulebase;
}

/// @addtogroup libnoise
/// @{

/// @addtogroup modules
/// @{

/// @addtogroup modifiermodules
/// @{

/// Default exponent for the module::Exponent noise module.
const double DEFAULT_EXPONENT = 1.0;

/// Noise module that maps the output value from a source module onto an
/// exponential curve.
///
/// @image html moduleexponent.png
///
/// Because most noise modules will output values that range from -1.0 to
/// +1.0, this noise module first normalizes this output value (the range
/// becomes 0.0 to 1.0), maps that value onto an exponential curve, then
/// rescales that value back to the original range.
///
/// This noise module requires one source module.
class Exponent : Mod
{

  public:

    /// Constructor.
    ///
    /// The default exponent is set to module::DEFAULT_EXPONENT.
    this ()
    {
        super(GetSourceModCount ());
        m_exponent = DEFAULT_EXPONENT;
    }

    /// Returns the exponent value to apply to the output value from the
    /// source module.
    ///
    /// @returns The exponent value.
    ///
    /// Because most noise modules will output values that range from -1.0
    /// to +1.0, this noise module first normalizes this output value (the
    /// range becomes 0.0 to 1.0), maps that value onto an exponential
    /// curve, then rescales that value back to the original range.
    double GetExponent () const
    {
      return m_exponent;
    }

    override int GetSourceModCount () const
    {
      return 1;
    }

    override double GetValue (double x, double y, double z) const
    {
      assert (m_pSourceMod[0] != NULL);

      double value = m_pSourceMod[0].GetValue (x, y, z);
      return (pow (fabs ((value + 1.0) / 2.0), m_exponent) * 2.0 - 1.0);
    }

    /// Sets the exponent value to apply to the output value from the
    /// source module.
    ///
    /// @param exponent The exponent value.
    ///
    /// Because most noise modules will output values that range from -1.0
    /// to +1.0, this noise module first normalizes this output value (the
    /// range becomes 0.0 to 1.0), maps that value onto an exponential
    /// curve, then rescales that value back to the original range.
    void SetExponent (double exponent)
    {
      m_exponent = exponent;
    }

  protected:

    /// Exponent to apply to the output value from the source module.
    double m_exponent;

};

/// @}

/// @}

/// @}