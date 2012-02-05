// select.h
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
module noise.mod.select;

private {
  import noise.mod.modulebase;
  import noise.interp;
}

/// @addtogroup libnoise
/// @{

/// @addtogroup modules
/// @{

/// @addtogroup selectormodules
/// @{

/// Default edge-falloff value for the module::Select noise module.
const double DEFAULT_SELECT_EDGE_FALLOFF = 0.0;

/// Default lower bound of the selection range for the
/// module::Select noise module.
const double DEFAULT_SELECT_LOWER_BOUND = -1.0;

/// Default upper bound of the selection range for the
/// module::Select noise module.
const double DEFAULT_SELECT_UPPER_BOUND = 1.0;

/// Noise module that outputs the value selected from one of two source
/// modules chosen by the output value from a control module.
///
/// @image html moduleselect.png
///
/// Unlike most other noise modules, the index value assigned to a source
/// module determines its role in the selection operation:
/// - Source module 0 (upper left in the diagram) outputs a value.
/// - Source module 1 (lower left in the diagram) outputs a value.
/// - Source module 2 (bottom of the diagram) is known as the <i>control
///   module</i>.  The control module determines the value to select.  If
///   the output value from the control module is within a range of values
///   known as the <i>selection range</i>, this noise module outputs the
///   value from the source module with an index value of 1.  Otherwise,
///   this noise module outputs the value from the source module with an
///   index value of 0.
///
/// To specify the bounds of the selection range, call the SetBounds()
/// method.
///
/// An application can pass the control module to the SetControlMod()
/// method instead of the SetSourceMod() method.  This may make the
/// application code easier to read.
///
/// By default, there is an abrupt transition between the output values
/// from the two source modules at the selection-range boundary.  To
/// smooth the transition, pass a non-zero value to the SetEdgeFalloff()
/// method.  Higher values result in a smoother transition.
///
/// This noise module requires three source modules.
class Select : Mod
{

  public:

    /// Constructor.
    ///
    /// The default falloff value at the edge transition is set to
    /// module::DEFAULT_SELECT_EDGE_FALLOFF.
    ///
    /// The default lower bound of the selection range is set to
    /// module::DEFAULT_SELECT_LOWER_BOUND.
    ///
    /// The default upper bound of the selection range is set to
    /// module::DEFAULT_SELECT_UPPER_BOUND.
    this()
    {
        super(this.GetSourceModCount ());
        m_edgeFalloff = DEFAULT_SELECT_EDGE_FALLOFF;
        m_lowerBound = DEFAULT_SELECT_LOWER_BOUND;
        m_upperBound = DEFAULT_SELECT_UPPER_BOUND;
    }

    /// Returns the control module.
    ///
    /// @returns A reference to the control module.
    ///
    /// @pre A control module has been added to this noise module via a
    /// call to SetSourceMod() or SetControlMod().
    ///
    /// @throw new ExceptionNoMod See the preconditions for more
    /// information.
    ///
    /// The control module determines the output value to select.  If the
    /// output value from the control module is within a range of values
    /// known as the <i>selection range</i>, the GetValue() method outputs
    /// the value from the source module with an index value of 1.
    /// Otherwise, this method outputs the value from the source module
    /// with an index value of 0.
    ref const(Mod) GetControlMod () const
    {
      if (m_pSourceMod == null || m_pSourceMod[2] == null) {
        throw new ExceptionNoMod ();
      }
      return *(m_pSourceMod[2]);
    }

    /// Returns the falloff value at the edge transition.
    ///
    /// @returns The falloff value at the edge transition.
    ///
    /// The falloff value is the width of the edge transition at either
    /// edge of the selection range.
    ///
    /// By default, there is an abrupt transition between the output
    /// values from the two source modules at the selection-range
    /// boundary.
    double GetEdgeFalloff () const
    {
      return m_edgeFalloff;
    }

    /// Returns the lower bound of the selection range.
    ///
    /// @returns The lower bound of the selection range.
    ///
    /// If the output value from the control module is within the
    /// selection range, the GetValue() method outputs the value from the
    /// source module with an index value of 1.  Otherwise, this method
    /// outputs the value from the source module with an index value of 0.
    double GetLowerBound () const
    {
      return m_lowerBound;
    }

    override int GetSourceModCount () const
    {
      return 3;
    }

    /// Returns the upper bound of the selection range.
    ///
    /// @returns The upper bound of the selection range.
    ///
    /// If the output value from the control module is within the
    /// selection range, the GetValue() method outputs the value from the
    /// source module with an index value of 1.  Otherwise, this method
    /// outputs the value from the source module with an index value of 0.
    double GetUpperBound () const
    {
      return m_upperBound;
    }

    override double GetValue (double x, double y, double z) const
    {
      assert (m_pSourceMod[0] !is null);
      assert (m_pSourceMod[1] !is null);
      assert (m_pSourceMod[2] !is null);

      double controlValue = m_pSourceMod[2].GetValue (x, y, z);
      double alpha;
      if (m_edgeFalloff > 0.0) {
        if (controlValue < (m_lowerBound - m_edgeFalloff)) {
          // The output value from the control module is below the selector
          // threshold; return the output value from the first source module.
          return m_pSourceMod[0].GetValue (x, y, z);

        } else if (controlValue < (m_lowerBound + m_edgeFalloff)) {
          // The output value from the control module is near the lower end of the
          // selector threshold and within the smooth curve. Interpolate between
          // the output values from the first and second source modules.
          double lowerCurve = (m_lowerBound - m_edgeFalloff);
          double upperCurve = (m_lowerBound + m_edgeFalloff);
          alpha = SCurve3 (
            (controlValue - lowerCurve) / (upperCurve - lowerCurve));
          return LinearInterp (m_pSourceMod[0].GetValue (x, y, z),
            m_pSourceMod[1].GetValue (x, y, z),
            alpha);

        } else if (controlValue < (m_upperBound - m_edgeFalloff)) {
          // The output value from the control module is within the selector
          // threshold; return the output value from the second source module.
          return m_pSourceMod[1].GetValue (x, y, z);

        } else if (controlValue < (m_upperBound + m_edgeFalloff)) {
          // The output value from the control module is near the upper end of the
          // selector threshold and within the smooth curve. Interpolate between
          // the output values from the first and second source modules.
          double lowerCurve = (m_upperBound - m_edgeFalloff);
          double upperCurve = (m_upperBound + m_edgeFalloff);
          alpha = SCurve3 (
            (controlValue - lowerCurve) / (upperCurve - lowerCurve));
          return LinearInterp (m_pSourceMod[1].GetValue (x, y, z),
            m_pSourceMod[0].GetValue (x, y, z),
            alpha);

        } else {
          // Output value from the control module is above the selector threshold;
          // return the output value from the first source module.
          return m_pSourceMod[0].GetValue (x, y, z);
        }
      } else {
        if (controlValue < m_lowerBound || controlValue > m_upperBound) {
          return m_pSourceMod[0].GetValue (x, y, z);
        } else {
          return m_pSourceMod[1].GetValue (x, y, z);
        }
      }
    }

    /// Sets the lower and upper bounds of the selection range.
    ///
    /// @param lowerBound The lower bound.
    /// @param upperBound The upper bound.
    ///
    /// @pre The lower bound must be less than or equal to the upper
    /// bound.
    ///
    /// @throw new ExceptionInvalidParam An invalid parameter was
    /// specified; see the preconditions for more information.
    ///
    /// If the output value from the control module is within the
    /// selection range, the GetValue() method outputs the value from the
    /// source module with an index value of 1.  Otherwise, this method
    /// outputs the value from the source module with an index value of 0.
    void SetBounds (double lowerBound, double upperBound)
    {
      assert (lowerBound < upperBound);

      m_lowerBound = lowerBound;
      m_upperBound = upperBound;

      // Make sure that the edge falloff curves do not overlap.
      SetEdgeFalloff (m_edgeFalloff);
    }

    /// Sets the control module.
    ///
    /// @param controlMod The control module.
    ///
    /// The control module determines the output value to select.  If the
    /// output value from the control module is within a range of values
    /// known as the <i>selection range</i>, the GetValue() method outputs
    /// the value from the source module with an index value of 1.
    /// Otherwise, this method outputs the value from the source module
    /// with an index value of 0.
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
      assert (m_pSourceMod !is null);
      m_pSourceMod[2] = &controlMod;
    }

    /// Sets the falloff value at the edge transition.
    ///
    /// @param edgeFalloff The falloff value at the edge transition.
    ///
    /// The falloff value is the width of the edge transition at either
    /// edge of the selection range.
    ///
    /// By default, there is an abrupt transition between the values from
    /// the two source modules at the boundaries of the selection range.
    ///
    /// For example, if the selection range is 0.5 to 0.8, and the edge
    /// falloff value is 0.1, then the GetValue() method outputs:
    /// - the output value from the source module with an index value of 0
    ///   if the output value from the control module is less than 0.4
    ///   ( = 0.5 - 0.1).
    /// - a linear blend between the two output values from the two source
    ///   modules if the output value from the control module is between
    ///   0.4 ( = 0.5 - 0.1) and 0.6 ( = 0.5 + 0.1).
    /// - the output value from the source module with an index value of 1
    ///   if the output value from the control module is between 0.6
    ///   ( = 0.5 + 0.1) and 0.7 ( = 0.8 - 0.1).
    /// - a linear blend between the output values from the two source
    ///   modules if the output value from the control module is between
    ///   0.7 ( = 0.8 - 0.1 ) and 0.9 ( = 0.8 + 0.1).
    /// - the output value from the source module with an index value of 0
    ///   if the output value from the control module is greater than 0.9
    ///   ( = 0.8 + 0.1).
    void SetEdgeFalloff (double edgeFalloff)
    {
      // Make sure that the edge falloff curves do not overlap.
      double boundSize = m_upperBound - m_lowerBound;
      m_edgeFalloff = (edgeFalloff > boundSize / 2)? boundSize / 2: edgeFalloff;
    }

  protected:

    /// Edge-falloff value.
    double m_edgeFalloff;

    /// Lower bound of the selection range.
    double m_lowerBound;

    /// Upper bound of the selection range.
    double m_upperBound;

};

/// @}

/// @}

/// @}
