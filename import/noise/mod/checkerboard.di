// D import file generated from 'module\checkerboard.d'
module noise.mod.checkerboard;
private import noise.mod.modulebase;

class Checkerboard : Mod
{
    public 
{
    this()
{
super(this.GetSourceModCount());
}
    override const int GetSourceModCount()
{
return 0;
}

    override const double GetValue(double x, double y, double z)
{
int ix = cast(int)floor(MakeInt32Range(x));
int iy = cast(int)floor(MakeInt32Range(y));
int iz = cast(int)floor(MakeInt32Range(z));
return ix & 1 ^ iy & 1 ^ iz & 1 ? -1 : 1;
}

}
}
