// D import file generated from 'module\scalepoint.d'
module noise.mod.scalepoint;
private import noise.mod.modulebase;

const double DEFAULT_SCALE_POINT_X = 1;

const double DEFAULT_SCALE_POINT_Y = 1;

const double DEFAULT_SCALE_POINT_Z = 1;

class ScalePoint : Mod
{
    public 
{
    this()
{
super(this.GetSourceModCount());
m_xScale = DEFAULT_SCALE_POINT_X;
m_yScale = DEFAULT_SCALE_POINT_Y;
m_zScale = DEFAULT_SCALE_POINT_Z;
}
    override const int GetSourceModCount()
{
return 1;
}

    override const double GetValue(double x, double y, double z)
{
assert(m_pSourceMod[0] !is null);
return m_pSourceMod[0].GetValue(x * m_xScale,y * m_yScale,z * m_zScale);
}

    const double GetXScale()
{
return m_xScale;
}
    const double GetYScale()
{
return m_yScale;
}
    const double GetZScale()
{
return m_zScale;
}
    void SetScale(double scale)
{
m_xScale = scale;
m_yScale = scale;
m_zScale = scale;
}
    void SetScale(double xScale, double yScale, double zScale)
{
m_xScale = xScale;
m_yScale = yScale;
m_zScale = zScale;
}
    void SetXScale(double xScale)
{
m_xScale = xScale;
}
    void SetYScale(double yScale)
{
m_yScale = yScale;
}
    void SetZScale(double zScale)
{
m_zScale = zScale;
}
    protected 
{
    double m_xScale;
    double m_yScale;
    double m_zScale;
}
}
}
