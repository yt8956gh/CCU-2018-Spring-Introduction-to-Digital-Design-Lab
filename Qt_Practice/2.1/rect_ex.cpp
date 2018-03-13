#include <cmath>
#include "rect.h"

using namespace std;


Rect::Rect(double width, double height)
{
    _width = abs(width);
    _height = abs(height);
}

double Rect::CalcDiagonal()
{
    return sqrt(_width*_width + _height*_height);
}

double Rect::CalcArea()
{
    return _width*_height;
}