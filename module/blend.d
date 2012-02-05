// blend.h
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
module noise.mod.blend;

private {
    import noise.mod.modulebase;
    import noise.interp;
}

/// @addtogroup libnoise
/// @{

/// @addtogroup modules
/// @{

/// @defgroup selectormodules Selector Mods
/// @addtogroup selectormodules
/// @{

/// Noise module that outputs a weighted blend of the output values from
/// two source modules given the output value supplied by a control module.
///
/// @image html moduleblend.png
///
/// Unlike most other noise modules, the index value assigned to a source
/// module determines its role in the blending operation:
/// - Source module 0 (upper left in the diagram) outputs one of the
///   values to blend.
/// - Source module 1 (lower left in the diagram) outputs one of the
///   values to blend.
/// - Source module 2 (bottom of the diagram) is known as the <i>control
///   module</i>.  The control module determines the weight of the
///   blending operation.  Negative values weigh the blend towards the
///   output value from the source module with an index value of 0.
///   Positive values weigh the blend towards the output value from the
///   source module with an index value of 1.
///
/// An application can pass the control module to the SetControlMod()
/// method instead of the SetSourceMod() method.  This may make the
/// application code easier to read.
///
/// This noise module uses linear interpolation to perform the blending
/// operation.
///
/// This noise module requires three source modules.
class Blend : Mod
{

  public:

    /// Constructor.
    this () {
        super(this.GetSourceModCount());
    }

    /// Returns the control module.
    ///
    /// @returns A reference to the control module.
    ///
    /// @pre A control module has been added to this noise module via a
    /// call to SetSourceMod() or SetControlMod().
    ///
    /// @throw new noise::ExceptionNoMod See the preconditions for more
    /// information.
    ///
    /// The control module determines the weight of the blending
    /// operation.  Negative values weigh the blend towards the output
    /// value from the source module with an index value of 0.  Positive
    /// values weigh the blend towards the output value from the source
    /// module with an index value of 1.
    ref const(Mod) GetControlMod () const
    {
      if (m_pSourceMod == null || m_pSourceMod[2] == null) {
        throw new ExceptionNoMod ();
      }
      return *(m_pSourceMod[2]);
    }

    override int GetSourceModCount () const
    {
      return 3;
    }

    override double GetValue (double x, double y, double z) const
    {
      assert (m_pSourceMod[0] != null);
      assert (m_pSourceMod[1] != null);
      assert (m_pSourceMod[2] != null);

      double v0 = m_pSourceMod[0].GetValue (x, y, z);
      double v1 = m_pSourceMod[1].GetValue (x, y, z);
      double alpha = (m_pSourceMod[2].GetValue (x, y, z) + 1.0) / 2.0;
      return LinearInterp (v0, v1, alpha);
    }   


    /// Sets the control module.
    ///
    /// @param controlMod The control module.
    ///
    /// The control module determines the weight of the blending
    /// operation.  Negative values weigh the blend towards the output
    /// value from the source module with an index value of 0.  Positive
    /// values weigh the blend towards the output value from the source
    /// module with an index value of 1.
    ///
    /// This method assigns the control module an index value of 2.
    /// Passing the control module to this method produces the same
    /// results as passing the control module to the SetSourceMod()
    /// method while assigning that noise module an index value of 2.
    ///
    /// This control module must exist throughout the lifetime of this
    /// noise module unless another control module replaces that control
    /// module.
    void SetControlMod (ref const(Mod) controlMod)
    {
      assert (m_pSourceMod != null);
      m_pSourceMod[2] = &controlMod;
    }

}

/// @}

/// @}

/// @}