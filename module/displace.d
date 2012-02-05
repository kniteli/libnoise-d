// displace.h
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
module noise.mod.displace;

private {
    import noise.mod.modulebase;
}

/// @addtogroup libnoise
/// @{

/// @addtogroup modules
/// @{

/// @defgroup transformermodules Transformer Mods
/// @addtogroup transformermodules
/// @{

/// Noise module that uses three source modules to displace each
/// coordinate of the input value before returning the output value from
/// a source module.
///
/// @image html moduledisplace.png
///
/// Unlike most other noise modules, the index value assigned to a source
/// module determines its role in the displacement operation:
/// - Source module 0 (left in the diagram) outputs a value.
/// - Source module 1 (lower left in the diagram) specifies the offset to
///   apply to the @a x coordinate of the input value.
/// - Source module 2 (lower center in the diagram) specifies the
///   offset to apply to the @a y coordinate of the input value.
/// - Source module 3 (lower right in the diagram) specifies the offset
///   to apply to the @a z coordinate of the input value.
///
/// The GetValue() method modifies the ( @a x, @a y, @a z ) coordinates of
/// the input value using the output values from the three displacement
/// modules before retrieving the output value from the source module.
///
/// The module::Turbulence noise module is a special case of the
/// displacement module; internally, there are three Perlin-noise modules
/// that perform the displacement operation.
///
/// This noise module requires four source modules.
class Displace : Mod
{

  public:

  /// Constructor.
  this()
  {
    super(this.GetSourceModCount());
  }

  override int GetSourceModCount () const
  {
    return 4;
  }

  override double GetValue (double x, double y, double z) const
  {
    assert (m_pSourceMod[0] != NULL);
    assert (m_pSourceMod[1] != NULL);
    assert (m_pSourceMod[2] != NULL);
    assert (m_pSourceMod[3] != NULL);

    // Get the output values from the three displacement modules.  Add each
    // value to the corresponding coordinate in the input value.
    double xDisplace = x + (m_pSourceMod[1].GetValue (x, y, z));
    double yDisplace = y + (m_pSourceMod[2].GetValue (x, y, z));
    double zDisplace = z + (m_pSourceMod[3].GetValue (x, y, z));

    // Retrieve the output value using the offsetted input value instead of
    // the original input value.
    return m_pSourceMod[0].GetValue (xDisplace, yDisplace, zDisplace);
  }

  /// Returns the @a x displacement module.
  ///
  /// @returns A reference to the @a x displacement module.
  ///
  /// @pre This displacement module has been added to this noise module
  /// via a call to SetSourceMod() or SetXDisplaceMod().
  ///
  /// @throw ExceptionNoMod See the preconditions for more
  /// information.
  ///
  /// The GetValue() method displaces the input value by adding the output
  /// value from this displacement module to the @a x coordinate of the
  /// input value before returning the output value from the source
  /// module.
  const ref Mod GetXDisplaceMod () const
  {
    if (m_pSourceMod == NULL || m_pSourceMod[1] == NULL) {
      throw ExceptionNoMod ();
    }
    return *(m_pSourceMod[1]);
  }

  /// Returns the @a y displacement module.
  ///
  /// @returns A reference to the @a y displacement module.
  ///
  /// @pre This displacement module has been added to this noise module
  /// via a call to SetSourceMod() or SetYDisplaceMod().
  ///
  /// @throw ExceptionNoMod See the preconditions for more
  /// information.
  ///
  /// The GetValue() method displaces the input value by adding the output
  /// value from this displacement module to the @a y coordinate of the
  /// input value before returning the output value from the source
  /// module.
  const ref Mod GetYDisplaceMod () const
  {
    if (m_pSourceMod == NULL || m_pSourceMod[2] == NULL) {
      throw ExceptionNoMod ();
    }
    return *(m_pSourceMod[2]);
  }

  /// Returns the @a z displacement module.
  ///
  /// @returns A reference to the @a z displacement module.
  ///
  /// @pre This displacement module has been added to this noise module
  /// via a call to SetSourceMod() or SetZDisplaceMod().
  ///
  /// @throw ExceptionNoMod See the preconditions for more
  /// information.
  ///
  /// The GetValue() method displaces the input value by adding the output
  /// value from this displacement module to the @a z coordinate of the
  /// input value before returning the output value from the source
  /// module.
  const ref Mod GetZDisplaceMod () const
  {
    if (m_pSourceMod == NULL || m_pSourceMod[3] == NULL) {
      throw ExceptionNoMod ();
    }
    return *(m_pSourceMod[3]);
  }

  /// Sets the @a x, @a y, and @a z displacement modules.
  ///
  /// @param xDisplaceMod Displacement module that displaces the @a x
  /// coordinate of the input value.
  /// @param yDisplaceMod Displacement module that displaces the @a y
  /// coordinate of the input value.
  /// @param zDisplaceMod Displacement module that displaces the @a z
  /// coordinate of the input value.
  ///
  /// The GetValue() method displaces the input value by adding the output
  /// value from each of the displacement modules to the corresponding
  /// coordinates of the input value before returning the output value
  /// from the source module.
  ///
  /// This method assigns an index value of 1 to the @a x displacement
  /// module, an index value of 2 to the @a y displacement module, and an
  /// index value of 3 to the @a z displacement module.
  ///
  /// These displacement modules must exist throughout the lifetime of
  /// this noise module unless another displacement module replaces it.
  void SetDisplaceMods (const ref Mod xDisplaceMod,
    const ref Mod yDisplaceMod, const ref Mod zDisplaceMod)
  {
    SetXDisplaceMod (xDisplaceMod);
    SetYDisplaceMod (yDisplaceMod);
    SetZDisplaceMod (zDisplaceMod);
  }

  /// Sets the @a x displacement module.
  ///
  /// @param xDisplaceMod Displacement module that displaces the @a x
  /// coordinate.
  ///
  /// The GetValue() method displaces the input value by adding the output
  /// value from this displacement module to the @a x coordinate of the
  /// input value before returning the output value from the source
  /// module.
  ///
  /// This method assigns an index value of 1 to the @a x displacement
  /// module.  Passing this displacement module to this method produces
  /// the same results as passing this displacement module to the
  /// SetSourceMod() method while assigning it an index value of 1.
  ///
  /// This displacement module must exist throughout the lifetime of this
  /// noise module unless another displacement module replaces it.
  void SetXDisplaceMod (const ref Mod xDisplaceMod)
  {
    assert (m_pSourceMod != NULL);
    m_pSourceMod[1] = &xDisplaceMod;
  }

  /// Sets the @a y displacement module.
  ///
  /// @param yDisplaceMod Displacement module that displaces the @a y
  /// coordinate.
  ///
  /// The GetValue() method displaces the input value by adding the output
  /// value from this displacement module to the @a y coordinate of the
  /// input value before returning the output value from the source
  /// module.
  ///
  /// This method assigns an index value of 2 to the @a y displacement
  /// module.  Passing this displacement module to this method produces
  /// the same results as passing this displacement module to the
  /// SetSourceMod() method while assigning it an index value of 2.
  ///
  /// This displacement module must exist throughout the lifetime of this
  /// noise module unless another displacement module replaces it.
  void SetYDisplaceMod (const ref Mod yDisplaceMod)
  {
    assert (m_pSourceMod != NULL);
    m_pSourceMod[2] = &yDisplaceMod;
  }

  /// Sets the @a z displacement module.
  ///
  /// @param zDisplaceMod Displacement module that displaces the @a z
  /// coordinate.
  ///
  /// The GetValue() method displaces the input value by adding the output
  /// value from this displacement module to the @a z coordinate of the
  /// input value before returning the output value from the source
  /// module.
  ///
  /// This method assigns an index value of 3 to the @a z displacement
  /// module.  Passing this displacement module to this method produces
  /// the same results as passing this displacement module to the
  /// SetSourceMod() method while assigning it an index value of 3.
  ///
  /// This displacement module must exist throughout the lifetime of this
  /// noise module unless another displacement module replaces it.
  void SetZDisplaceMod (const ref Mod zDisplaceMod)
  {
    assert (m_pSourceMod != NULL);
    m_pSourceMod[3] = &zDisplaceMod;
  }

};

/// @}

/// @}

/// @}