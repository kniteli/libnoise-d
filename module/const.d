// const.h
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
module noise.mod.constantsants;

import noise.mod.modulebase;

/// @addtogroup libnoise
/// @{

/// @addtogroup modules
/// @{

/// @defgroup generatormodules Generator Mods
/// @addtogroup generatormodules
/// @{

/// Default constant value for the module::Const noise module.
const double DEFAULT_CONST_VALUE = 0.0;

/// Noise module that outputs a constant value.
///
/// @image html moduleconst.png
///
/// To specify the constant value, call the SetConstValue() method.
///
/// This noise module is not useful by itself, but it is often used as a
/// source module for other noise modules.
///
/// This noise module does not require any source modules.
class Const : Mod
{

  public:

    /// Constructor.
    ///
    /// The default constant value is set to
    /// module::DEFAULT_CONST_VALUE.
    this()
    {
        super(this.GetSourceModCount());
        m_constValue = DEFAULT_CONST_VALUE;
    }

    /// Returns the constant output value for this noise module.
    ///
    /// @returns The constant output value for this noise module.
    double GetConstValue () const
    {
      return m_constValue;
    }

    override int GetSourceModCount () const
    {
      return 0;
    }

    override double GetValue (double x, double y, double z) const
    {
      return m_constValue;
    }

    /// Sets the constant output value for this noise module.
    ///
    /// @param constValue The constant output value for this noise module.
    void SetConstValue (double constValue)
    {
      m_constValue = constValue;
    }

  protected:

    /// Constant value.
    double m_constValue;

};

/// @}

/// @}

/// @}
