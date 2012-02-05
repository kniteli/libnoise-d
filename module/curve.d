// curve.h
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
module noise.module.curve;

private {
    import noise.module.modulebase;
    import noise.interp;
    import noise.misc;
}

/// @addtogroup libnoise
/// @{

/// This structure defines a control point.
///
/// Control points are used for defining splines.
struct ControlPoint
{

  /// The input value.
  double inputValue;

  /// The output value that is mapped from the input value.
  double outputValue;

};

/// @addtogroup modules
/// @{

/// @addtogroup modifiermodules
/// @{

/// Noise module that maps the output value from a source module onto an
/// arbitrary function curve.
///
/// @image html modulecurve.png
///
/// This noise module maps the output value from the source module onto an
/// application-defined curve.  This curve is defined by a number of
/// <i>control points</i>; each control point has an <i>input value</i>
/// that maps to an <i>output value</i>.  Refer to the following
/// illustration:
///
/// @image html curve.png
///
/// To add the control points to this curve, call the AddControlPoint()
/// method.
///
/// Since this curve is a cubic spline, an application must add a minimum
/// of four control points to the curve.  If this is not done, the
/// GetValue() method fails.  Each control point can have any input and
/// output value, although no two control points can have the same input
/// value.  There is no limit to the number of control points that can be
/// added to the curve.  
///
/// This noise module requires one source module.
class Curve : Module
{

  public:

    /// Constructor.
    this ()
    {
        super(this.GetSourceModuleCount ());
        m_pControlPoints = NULL;
        m_controlPointCount = 0;
    }

    /// Destructor.
    ~this (){}

    /// Adds a control point to the curve.
    ///
    /// @param inputValue The input value stored in the control point.
    /// @param outputValue The output value stored in the control point.
    ///
    /// @pre No two control points have the same input value.
    ///
    /// @throw ExceptionInvalidParam An invalid parameter was
    /// specified; see the preconditions for more information.
    ///
    /// It does not matter which order these points are added.
    void AddControlPoint (double inputValue, double outputValue)
    {
      // Find the insertion point for the new control point and insert the new
      // point at that position.  The control point array will remain sorted by
      // input value.
      int insertionPos = FindInsertionPos (inputValue);
      InsertAtPos (insertionPos, inputValue, outputValue);
    }

    /// Deletes all the control points on the curve.
    ///
    /// @post All points on the curve are deleted.
    void ClearAllControlPoints ()
    {
      m_pControlPoints = NULL;
      m_controlPointCount = 0;
    }

    /// Returns a pointer to the array of control points on the curve.
    ///
    /// @returns A pointer to the array of control points.
    ///
    /// Before calling this method, call GetControlPointCount() to
    /// determine the number of control points in this array.
    ///
    /// It is recommended that an application does not store this pointer
    /// for later use since the pointer to the array may change if the
    /// application calls another method of this object.
    const ControlPoint* GetControlPointArray () const
    {
      return m_pControlPoints;
    }

    /// Returns the number of control points on the curve.
    ///
    /// @returns The number of control points on the curve.
    int GetControlPointCount () const
    {
      return m_controlPointCount;
    }

    override int GetSourceModuleCount () const
    {
      return 1;
    }

    override double GetValue (double x, double y, double z) const
    {
      assert (m_pSourceModule[0] != NULL);
      assert (m_controlPointCount >= 4);

      // Get the output value from the source module.
      double sourceModuleValue = m_pSourceModule[0].GetValue (x, y, z);

      // Find the first element in the control point array that has an input value
      // larger than the output value from the source module.
      int indexPos;
      for (indexPos = 0; indexPos < m_controlPointCount; indexPos++) {
        if (sourceModuleValue < m_pControlPoints[indexPos].inputValue) {
          break;
        }
      }

      // Find the four nearest control points so that we can perform cubic
      // interpolation.
      int index0 = ClampValue (indexPos - 2, 0, m_controlPointCount - 1);
      int index1 = ClampValue (indexPos - 1, 0, m_controlPointCount - 1);
      int index2 = ClampValue (indexPos    , 0, m_controlPointCount - 1);
      int index3 = ClampValue (indexPos + 1, 0, m_controlPointCount - 1);

      // If some control points are missing (which occurs if the value from the
      // source module is greater than the largest input value or less than the
      // smallest input value of the control point array), get the corresponding
      // output value of the nearest control point and exit now.
      if (index1 == index2) {
        return m_pControlPoints[index1].outputValue;
      }
      
      // Compute the alpha value used for cubic interpolation.
      double input0 = m_pControlPoints[index1].inputValue;
      double input1 = m_pControlPoints[index2].inputValue;
      double alpha = (sourceModuleValue - input0) / (input1 - input0);

      // Now perform the cubic interpolation given the alpha value.
      return CubicInterp (
        m_pControlPoints[index0].outputValue,
        m_pControlPoints[index1].outputValue,
        m_pControlPoints[index2].outputValue,
        m_pControlPoints[index3].outputValue,
        alpha);
    }

  protected:

    /// Determines the array index in which to insert the control point
    /// into the internal control point array.
    ///
    /// @param inputValue The input value of the control point.
    ///
    /// @returns The array index in which to insert the control point.
    ///
    /// @pre No two control points have the same input value.
    ///
    /// @throw ExceptionInvalidParam An invalid parameter was
    /// specified; see the preconditions for more information.
    ///
    /// By inserting the control point at the returned array index, this
    /// class ensures that the control point array is sorted by input
    /// value.  The code that maps a value onto the curve requires a
    /// sorted control point array.
    int FindInsertionPos (double inputValue)
    {
      int insertionPos;
      for (insertionPos = 0; insertionPos < m_controlPointCount; insertionPos++) {
        if (inputValue < m_pControlPoints[insertionPos].inputValue) {
          // We found the array index in which to insert the new control point.
          // Exit now.
          break;
        } else if (inputValue == m_pControlPoints[insertionPos].inputValue) {
          // Each control point is required to contain a unique input value, so
          // throw an exception.
          throw ExceptionInvalidParam ();
        }
      }
      return insertionPos;
    }

    /// Inserts the control point at the specified position in the
    /// internal control point array.
    ///
    /// @param insertionPos The zero-based array position in which to
    /// insert the control point.
    /// @param inputValue The input value stored in the control point.
    /// @param outputValue The output value stored in the control point.
    ///
    /// To make room for this new control point, this method reallocates
    /// the control point array and shifts all control points occurring
    /// after the insertion position up by one.
    ///
    /// Because the curve mapping algorithm used by this noise module
    /// requires that all control points in the array must be sorted by
    /// input value, the new control point should be inserted at the
    /// position in which the order is still preserved.
    void InsertAtPos (int insertionPos, double inputValue,
      double outputValue)
    {
      // Make room for the new control point at the specified position within the
      // control point array.  The position is determined by the input value of
      // the control point; the control points must be sorted by input value
      // within that array.
      ControlPoint* newControlPoints = new ControlPoint[m_controlPointCount + 1];
      for (int i = 0; i < m_controlPointCount; i++) {
        if (i < insertionPos) {
          newControlPoints[i] = m_pControlPoints[i];
        } else {
          newControlPoints[i + 1] = m_pControlPoints[i];
        }
      }
      m_pControlPoints = newControlPoints;
      ++m_controlPointCount;

      // Now that we've made room for the new control point within the array, add
      // the new control point.
      m_pControlPoints[insertionPos].inputValue  = inputValue ;
      m_pControlPoints[insertionPos].outputValue = outputValue;
    }

    /// Number of control points on the curve.
    int m_controlPointCount;

    /// Array that stores the control points.
    ControlPoint* m_pControlPoints;

};

/// @}

/// @}

/// @}