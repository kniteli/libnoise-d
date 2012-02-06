// D import file generated from 'misc.d'
module noise.misc;
int ClampValue(int value, int lowerBound, int upperBound);
template GetMax(T)
{
T GetMax(ref const T a, ref const T b)
{
return a > b ? a : b;
}
}
template GetMin(T)
{
T GetMin(ref const T a, ref const T b)
{
return a < b ? a : b;
}
}
template SwapValues(T)
{
void SwapValues(ref T a, ref T b)
{
T c = a;
a = b;
b = c;
}
}
