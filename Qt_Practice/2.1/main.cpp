#include <iostream>
#include "rect.h"

using namespace std;

int main(int argc, char **argv)
{
    Rect sample(3.0, 4.0);
    cout<<"The Diagonal is "<<sample.CalcDiagonal()<<endl;
    cout<<"The Area is "<<sample.CalcArea()<<endl;

    return 0;
}