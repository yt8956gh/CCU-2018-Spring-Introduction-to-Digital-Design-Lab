class Rect
{
	private:
		double _width;
		double _height;

	public:
		Rect (double width, double height);
		double GetWidth(){return _width; }
		double GetHeight(){return _height; }

		//function

		double CalcDiagonal();
		double CalcArea();
};
