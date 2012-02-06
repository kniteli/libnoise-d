// D import file generated from 'module\rotatepoint.d'
module noise.mod.rotatepoint;
private 
{
    import noise.mod.modulebase;
    import noise.mathconsts;
}
const double DEFAULT_ROTATE_X = 0;

const double DEFAULT_ROTATE_Y = 0;

const double DEFAULT_ROTATE_Z = 0;

class RotatePoint : Mod
{
    public 
{
    this()
{
super(this.GetSourceModCount());
SetAngles(DEFAULT_ROTATE_X,DEFAULT_ROTATE_Y,DEFAULT_ROTATE_Z);
}
    override const int GetSourceModCount()
{
return 1;
}

    override const double GetValue(double x, double y, double z)
{
assert(m_pSourceMod[0] !is null);
double nx = m_x1Matrix * x + m_y1Matrix * y + m_z1Matrix * z;
double ny = m_x2Matrix * x + m_y2Matrix * y + m_z2Matrix * z;
double nz = m_x3Matrix * x + m_y3Matrix * y + m_z3Matrix * z;
return m_pSourceMod[0].GetValue(nx,ny,nz);
}

    const double GetXAngle()
{
return m_xAngle;
}
    const double GetYAngle()
{
return m_yAngle;
}
    const double GetZAngle()
{
return m_zAngle;
}
    void SetAngles(double xAngle, double yAngle, double zAngle)
{
double xCos,yCos,zCos,xSin,ySin,zSin;
xCos = cos(xAngle * DEG_TO_RAD);
yCos = cos(yAngle * DEG_TO_RAD);
zCos = cos(zAngle * DEG_TO_RAD);
xSin = sin(xAngle * DEG_TO_RAD);
ySin = sin(yAngle * DEG_TO_RAD);
zSin = sin(zAngle * DEG_TO_RAD);
m_x1Matrix = ySin * xSin * zSin + yCos * zCos;
m_y1Matrix = xCos * zSin;
m_z1Matrix = ySin * zCos - yCos * xSin * zSin;
m_x2Matrix = ySin * xSin * zCos - yCos * zSin;
m_y2Matrix = xCos * zCos;
m_z2Matrix = -yCos * xSin * zCos - ySin * zSin;
m_x3Matrix = -ySin * xCos;
m_y3Matrix = xSin;
m_z3Matrix = yCos * xCos;
m_xAngle = xAngle;
m_yAngle = yAngle;
m_zAngle = zAngle;
}
    void SetXAngle(double xAngle)
{
SetAngles(xAngle,m_yAngle,m_zAngle);
}
    void SetYAngle(double yAngle)
{
SetAngles(m_xAngle,yAngle,m_zAngle);
}
    void SetZAngle(double zAngle)
{
SetAngles(m_xAngle,m_yAngle,zAngle);
}
    protected 
{
    double m_x1Matrix;
    double m_x2Matrix;
    double m_x3Matrix;
    double m_xAngle;
    double m_y1Matrix;
    double m_y2Matrix;
    double m_y3Matrix;
    double m_yAngle;
    double m_z1Matrix;
    double m_z2Matrix;
    double m_z3Matrix;
    double m_zAngle;
}
}
}
