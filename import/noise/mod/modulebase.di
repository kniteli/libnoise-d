// D import file generated from 'module\modulebase.d'
module noise.mod.modulebase;
package 
{
    import std.math;
    import noise.basictypes;
    import noise.exception;
    import noise.noisegen;
}
class Mod
{
    public 
{
    this(int sourceModCount);
    ~this()
{
}
    ref const const(Mod) GetSourceMod(int index);

    abstract const int GetSourceModCount();

    abstract const double GetValue(double x, double y, double z);

    void SetSourceMod(int index, ref const(Mod) sourceMod);
    protected 
{
    const(Mod)*[] m_pSourceMod;
    private final ref const(Mod) opAssign(ref const(Mod) m)
{
return this;
}


}
}
}
