/**
 *	A small shape to quickly test pause and resume functionality of printerX
 *
 **/

// Render quality settings
$fs = 1;
$fa = 0.1;

cubeXYDimension = 15;
cubeHeight = 4;
cutoutDiameter = 12;

difference()
{
	{
		cube( [cubeXYDimension, cubeXYDimension, cubeHeight] );
	}
	{
		translate( [(cubeXYDimension/2), (cubeXYDimension/2), -1] ) cylinder( d = cutoutDiameter, h = cubeHeight + 2 );
	}
}
