// gradient
//
// Copyright © 2013 Roderick Gibson
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
// The developer's email is kniteli@gmail.com
//
module noise.mod.gradient;

private {
  import noise.mod.modulebase;
  debug import std.stdio;
}
/// @addtogroup libnoise
/// @{

/// @addtogroup modules
/// @{

/// @addtogroup combinermodules
/// @{

//
// Module that takes two points and creates a gradient vector
// from them.

// Ported from the Accidental Noise Library (author Joshua Tippetts )here: 
// http://accidentalnoise.sourceforge.net/index.html
//
class Gradient : Mod
{

public:

  /// Constructor.
  this(double x1, double y1, double z1, double x2, double y2, double z2)
  {
    super(this.GetSourceModCount());
    m_x1 = x1;
    m_y1 = y1;
    m_z1 = z1;
    m_x2 = x2;
    m_y2 = y2;
    m_z2 = z2;

    m_x=x2-x1;
    m_y=y2-y1;
    m_z=z2-z1;

    m_vlen=(m_x*m_x+m_y*m_y+m_z*m_z);
  }

  override int GetSourceModCount () const
  {
    return 0;
  }

  override double GetValue (double x, double y, double z) const
  {
    double dx=x-m_x1;
    double dy=y-m_y1;
    double dz=z-m_z1;
    double dp=dx*m_x+dy*m_y+dz*m_z;
    dp/=m_vlen;
    //dp=clamp(dp/m_vlen,0.0,1.0);
    //return lerp(dp,1.0,-1.0);
    return dp;    
  }

private:
  double m_x1, m_x2;
  double m_y1, m_y2;
  double m_z1, m_z2;
    double m_x, m_y, m_z;
    double m_vlen;
}