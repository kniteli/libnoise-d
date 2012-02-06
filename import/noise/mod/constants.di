// D import file generated from 'module\const.d'
module noise.mod.constants;
private import noise.mod.modulebase;

const double DEFAULT_CONST_VALUE = 0;

class Const : Mod
{
    public 
{
    this()
{
super(this.GetSourceModCount());
m_constValue = DEFAULT_CONST_VALUE;
}
    const double GetConstValue()
{
return m_constValue;
}
    override const int GetSourceModCount()
{
return 0;
}

    override const double GetValue(double x, double y, double z)
{
return m_constValue;
}

    void SetConstValue(double constValue)
{
m_constValue = constValue;
}
    protected double m_constValue;

}
}
