// D import file generated from 'module\translatepoint.d'
module noise.mod.translatepoint;
private import noise.mod.modulebase;

const double DEFAULT_TRANSLATE_POINT_X = 0;

const double DEFAULT_TRANSLATE_POINT_Y = 0;

const double DEFAULT_TRANSLATE_POINT_Z = 0;

class TranslatePoint : Mod
{
    public 
{
    this()
{
super(this.GetSourceModCount());
m_xTranslation = DEFAULT_TRANSLATE_POINT_X;
m_yTranslation = DEFAULT_TRANSLATE_POINT_Y;
m_zTranslation = DEFAULT_TRANSLATE_POINT_Z;
}
    override const int GetSourceModCount()
{
return 1;
}

    override const double GetValue(double x, double y, double z)
{
assert(m_pSourceMod[0] !is null);
return m_pSourceMod[0].GetValue(x + m_xTranslation,y + m_yTranslation,z + m_zTranslation);
}

    const double GetXTranslation()
{
return m_xTranslation;
}
    const double GetYTranslation()
{
return m_yTranslation;
}
    const double GetZTranslation()
{
return m_zTranslation;
}
    void SetTranslation(double translation)
{
m_xTranslation = translation;
m_yTranslation = translation;
m_zTranslation = translation;
}
    void SetTranslation(double xTranslation, double yTranslation, double zTranslation)
{
m_xTranslation = xTranslation;
m_yTranslation = yTranslation;
m_zTranslation = zTranslation;
}
    void SetXTranslation(double xTranslation)
{
m_xTranslation = xTranslation;
}
    void SetYTranslation(double yTranslation)
{
m_yTranslation = yTranslation;
}
    void SetZTranslation(double zTranslation)
{
m_zTranslation = zTranslation;
}
    protected 
{
    double m_xTranslation;
    double m_yTranslation;
    double m_zTranslation;
}
}
}
