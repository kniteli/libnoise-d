// D import file generated from 'module\curve.d'
module noise.mod.curve;
private 
{
    import noise.mod.modulebase;
    import noise.interp;
    import noise.misc;
}
struct ControlPoint
{
    double inputValue;
    double outputValue;
}
class Curve : Mod
{
    public 
{
    this()
{
super(this.GetSourceModCount());
m_pControlPoints = null;
m_controlPointCount = 0;
}
    ~this()
{
}
    void AddControlPoint(double inputValue, double outputValue)
{
int insertionPos = FindInsertionPos(inputValue);
InsertAtPos(insertionPos,inputValue,outputValue);
}
    void ClearAllControlPoints()
{
m_pControlPoints = null;
m_controlPointCount = 0;
}
    const const(ControlPoint)[] GetControlPointArray()
{
return m_pControlPoints;
}
    const int GetControlPointCount()
{
return m_controlPointCount;
}
    override const int GetSourceModCount()
{
return 1;
}

    override const double GetValue(double x, double y, double z);

    protected 
{
    int FindInsertionPos(double inputValue);
    void InsertAtPos(int insertionPos, double inputValue, double outputValue);
    int m_controlPointCount;
    ControlPoint[] m_pControlPoints;
}
}
}
