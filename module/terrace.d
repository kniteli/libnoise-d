// terrace.h
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
module noise.module.terrace;

import noise.module.modulebase;
import noise.misc;
import noise.interp;

/// @addtogroup libnoise
/// @{

/// @addtogroup modules
/// @{

/// @addtogroup modifiermodules
/// @{

/// Noise module that maps the output value from a source module onto a
/// terrace-forming curve.
///
/// @image html moduleterrace.png
///
/// This noise module maps the output value from the source module onto a
/// terrace-forming curve.  The start of this curve has a slope of zero;
/// its slope then smoothly increases.  This curve also contains
/// <i>control points</i> which resets the slope to zero at that point,
/// producing a "terracing" effect.  Refer to the following illustration:
///
/// @image html terrace.png
///
/// To add a control point to this noise module, call the
/// AddControlPoint() method.
///
/// An application must add a minimum of two control points to the curve.
/// If this is not done, the GetValue() method fails.  The control points
/// can have any value, although no two control points can have the same
/// value.  There is no limit to the number of control points that can be
/// added to the curve.
///
/// This noise module clamps the output value from the source module if
/// that value is less than the value of the lowest control point or
/// greater than the value of the highest control point.
///
/// This noise module is often used to generate terrain features such as
/// your stereotypical desert canyon.
///
/// This noise module requires one source module.
class Terrace : Module
{

    public:

	/// Constructor.
	this()
	{
		  super(this.GetSourceModuleCount ());
	  m_controlPointCount = 0;
	  m_invertTerraces = false;
	  m_pControlPoints = NULL;
	}

	/// Destructor.
	~this(){}

	/// Adds a control point to the terrace-forming curve.
	///
	/// @param value The value of the control point to add.
	///
	/// @pre No two control points have the same value.
	///
	/// @throw ExceptionInvalidParam An invalid parameter was
	/// specified; see the preconditions for more information.
	///
	/// Two or more control points define the terrace-forming curve.  The
	/// start of this curve has a slope of zero; its slope then smoothly
	/// increases.  At the control points, its slope resets to zero.
	///
	/// It does not matter which order these points are added.
	void AddControlPoint (double value)
	{
	  // Find the insertion point for the new control point and insert the new
	  // point at that position.  The control point array will remain sorted by
	  // value.
	  int insertionPos = FindInsertionPos (value);
	  InsertAtPos (insertionPos, value);
	}

	/// Deletes all the control points on the terrace-forming curve.
	///
	/// @post All control points on the terrace-forming curve are deleted.
	void ClearAllControlPoints ()
	{
	  m_pControlPoints = NULL;
	  m_controlPointCount = 0;
	}

	/// Returns a pointer to the array of control points on the
	/// terrace-forming curve.
	///
	/// @returns A pointer to the array of control points in this noise
	/// module.
	///
	/// Two or more control points define the terrace-forming curve.  The
	/// start of this curve has a slope of zero; its slope then smoothly
	/// increases.  At the control points, its slope resets to zero.
	///
	/// Before calling this method, call GetControlPointCount() to
	/// determine the number of control points in this array.
	///
	/// It is recommended that an application does not store this pointer
	/// for later use since the pointer to the array may change if the
	/// application calls another method of this object.
	const double* GetControlPointArray () const
	{
	return m_pControlPoints;
	}

	/// Returns the number of control points on the terrace-forming curve.
	///
	/// @returns The number of control points on the terrace-forming
	/// curve.
	int GetControlPointCount () const
	{
	return m_controlPointCount;
	}

	override int GetSourceModuleCount () const
	{
	return 1;
	}

	/// Enables or disables the inversion of the terrace-forming curve
	/// between the control points.
	///
	/// @param invert Specifies whether to invert the curve between the
	/// control points.
	void InvertTerraces (bool invert = true)
	{
	m_invertTerraces = invert;
	}

	/// Determines if the terrace-forming curve between the control
	/// points is inverted.
	///
	/// @returns
	/// - @a true if the curve between the control points is inverted.
	/// - @a false if the curve between the control points is not
	///   inverted.
	bool IsTerracesInverted () const
	{
	return m_invertTerraces;
	}

	override double GetValue (double x, double y, double z) const
	{
	  assert (m_pSourceModule[0] != NULL);
	  assert (m_controlPointCount >= 2);

	  // Get the output value from the source module.
	  double sourceModuleValue = m_pSourceModule[0].GetValue (x, y, z);

	  // Find the first element in the control point array that has a value
	  // larger than the output value from the source module.
	  int indexPos;
	  for (indexPos = 0; indexPos < m_controlPointCount; indexPos++) {
	    if (sourceModuleValue < m_pControlPoints[indexPos]) {
	      break;
	    }
	  }

	  // Find the two nearest control points so that we can map their values
	  // onto a quadratic curve.
	  int index0 = ClampValue (indexPos - 1, 0, m_controlPointCount - 1);
	  int index1 = ClampValue (indexPos    , 0, m_controlPointCount - 1);

	  // If some control points are missing (which occurs if the output value from
	  // the source module is greater than the largest value or less than the
	  // smallest value of the control point array), get the value of the nearest
	  // control point and exit now.
	  if (index0 == index1) {
	    return m_pControlPoints[index1];
	  }

	  // Compute the alpha value used for linear interpolation.
	  double value0 = m_pControlPoints[index0];
	  double value1 = m_pControlPoints[index1];
	  double alpha = (sourceModuleValue - value0) / (value1 - value0);
	  if (m_invertTerraces) {
	    alpha = 1.0 - alpha;
	    SwapValues (value0, value1);
	  }

	  // Squaring the alpha produces the terrace effect.
	  alpha *= alpha;

	  // Now perform the linear interpolation given the alpha value.
	  return LinearInterp (value0, value1, alpha);
	}


	/// Creates a number of equally-spaced control points that range from
	/// -1 to +1.
	///
	/// @param controlPointCount The number of control points to generate.
	///
	/// @pre The number of control points must be greater than or equal to
	/// 2.
	///
	/// @post The previous control points on the terrace-forming curve are
	/// deleted.
	///
	/// @throw ExceptionInvalidParam An invalid parameter was
	/// specified; see the preconditions for more information.
	///
	/// Two or more control points define the terrace-forming curve.  The
	/// start of this curve has a slope of zero; its slope then smoothly
	/// increases.  At the control points, its slope resets to zero.
	void MakeControlPoints (int controlPointCount)
	{
	  if (controlPointCount < 2) {
	    throw ExceptionInvalidParam ();
	  }

	  ClearAllControlPoints ();

	  double terraceStep = 2.0 / ((double)controlPointCount - 1.0);
	  double curValue = -1.0;
	  for (int i = 0; i < (int)controlPointCount; i++) {
	    AddControlPoint (curValue);
	    curValue += terraceStep;
	  }
	}

	protected:

	/// Determines the array index in which to insert the control point
	/// into the internal control point array.
	///
	/// @param value The value of the control point.
	///
	/// @returns The array index in which to insert the control point.
	///
	/// @pre No two control points have the same value.
	///
	/// @throw ExceptionInvalidParam An invalid parameter was
	/// specified; see the preconditions for more information.
	///
	/// By inserting the control point at the returned array index, this
	/// class ensures that the control point array is sorted by value.
	/// The code that maps a value onto the curve requires a sorted
	/// control point array.
	int FindInsertionPos (double value)
	{
	  int insertionPos;
	  for (insertionPos = 0; insertionPos < m_controlPointCount; insertionPos++) {
	    if (value < m_pControlPoints[insertionPos]) {
	      // We found the array index in which to insert the new control point.
	      // Exit now.
	      break;
	    } else if (value == m_pControlPoints[insertionPos]) {
	      // Each control point is required to contain a unique value, so throw
	      // an exception.
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
	/// @param value The value of the control point.
	///
	/// To make room for this new control point, this method reallocates
	/// the control point array and shifts all control points occurring
	/// after the insertion position up by one.
	///
	/// Because the curve mapping algorithm in this noise module requires
	/// that all control points in the array be sorted by value, the new
	/// control point should be inserted at the position in which the
	/// order is still preserved.
	void InsertAtPos (int insertionPos, double value)
	{
	  // Make room for the new control point at the specified position within
	  // the control point array.  The position is determined by the value of
	  // the control point; the control points must be sorted by value within
	  // that array.
	  double* newControlPoints = new double[m_controlPointCount + 1];
	  for (int i = 0; i < m_controlPointCount; i++) {
	    if (i < insertionPos) {
	      newControlPoints[i] = m_pControlPoints[i];
	    } else {
	      newControlPoints[i + 1] = m_pControlPoints[i];
	    }
	  }
	  m_pControlPoints = newControlPoints;
	  ++m_controlPointCount;

	  // Now that we've made room for the new control point within the array,
	  // add the new control point.
	  m_pControlPoints[insertionPos] = value;
	}

	/// Number of control points stored in this noise module.
	int m_controlPointCount;

	/// Determines if the terrace-forming curve between all control points
	/// is inverted.
	bool m_invertTerraces;

	/// Array that stores the control points.
	double* m_pControlPoints;

};

/// @}

/// @}

/// @}