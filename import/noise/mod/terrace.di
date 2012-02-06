// D import file generated from 'module\terrace.d'
module noise.mod.terrace;
private 
{
    import noise.mod.modulebase;
    import noise.misc;
    import noise.interp;
}
class Terrace : Mod
{
    public 
{
    this()
{
super(this.GetSourceModCount());
m_controlPointCount = 0;
m_invertTerraces = false;
m_pControlPoints = null;
}
    ~this()
{
}
    void AddControlPoint(double value)
{
int insertionPos = FindInsertionPos(value);
InsertAtPos(insertionPos,value);
}
    void ClearAllControlPoints()
{
m_pControlPoints = null;
m_controlPointCount = 0;
}
    const const(double)[] GetControlPointArray()
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

    void InvertTerraces(bool invert = true)
{
m_invertTerraces = invert;
}
    const bool IsTerracesInverted()
{
return m_invertTerraces;
}
    override const double GetValue(double x, double y, double z);

    void MakeControlPoints(int controlPointCount);
    protected 
{
    int FindInsertionPos(double value);
    void InsertAtPos(int insertionPos, double value);
    int m_controlPointCount;
    bool m_invertTerraces;
    double[] m_pControlPoints;
}
}
}
