/**
 * A 3D printed block to aid in mounting CNC router pieces
 *
 * Nothing more than a rectangle with rounded corners so it can be printed faster without defects.
 * Recommend printing with 5 shell layers, 0 top/bottom layers and 10-20% infill
 **/

$fa = 1;
$fs = 0.1;

blockXDimension = 82;
blockYDimension = 180;
blockZDimension = 18;

cornerDiameter = 10;

boltCutoutDepth = 5;
boltCutoutHeight = 8;

topBlockZDimension = boltCutoutHeight;
bottomBlockZDimension = blockZDimension - boltCutoutHeight;

layerWidth = 0.45;
wallThicknes = layerWidth * 9; // Set the wall thickness to a number of perimeter loops to make slicer settings easier to choose
// wallThickness multiplier of '9' is 4 perimeters in each direction plus one middle loop

cutoutXOffset = (cornerDiameter/2) + boltCutoutDepth + wallThicknes;
cutoutYDistance = blockYDimension - (cutoutXOffset * 2) + cornerDiameter;
cutoutXDistance = blockXDimension - (cutoutXOffset * 2) + boltCutoutDepth;

difference()
{
	{
		union()
		{
			bottomBodyShape();
			topBodyShape();
		}
	}
	{
		cutoutShapes();
	}
}

module cutoutShapes()
{
	translate( [cutoutXOffset, (cornerDiameter/2) + wallThicknes, -1] )
	{
		hull()
		{
			{}
			{
				union()
				{
					translate( [cornerDiameter + (wallThicknes), cutoutYDistance, 0] ) cylinder( d = cornerDiameter, h = blockZDimension + 2 );
					translate( [cutoutXDistance - cornerDiameter - (wallThicknes), cutoutYDistance, 0] ) cylinder( d = cornerDiameter, h = blockZDimension + 2 );
					translate( [cutoutXDistance/2, cutoutYDistance/2 + (cornerDiameter * 2) + (wallThicknes * 2), 0] ) cylinder( d = cornerDiameter, h = blockZDimension + 2 );
				}
			}
		}

		hull()
		{
			{}
			{
				union()
				{
					translate( [cornerDiameter + wallThicknes, 0, 0] ) cylinder( d = cornerDiameter, h = blockZDimension + 2 );
					translate( [cutoutXDistance - (cornerDiameter + wallThicknes), 0, 0] ) cylinder( d = cornerDiameter, h = blockZDimension + 2 );
					translate( [cutoutXDistance/2, cutoutYDistance/2 - (cornerDiameter * 2) - (wallThicknes * 2), 0] ) cylinder( d = cornerDiameter, h = blockZDimension + 2 );
				}
			}
		}

		hull()
		{
			{}
			{
				union()
				{
					translate( [cutoutXDistance, cutoutYDistance, 0] ) cylinder( d = cornerDiameter, h = blockZDimension + 2 );
					translate( [cutoutXDistance, cutoutYDistance/2 + (cornerDiameter/2) + (wallThicknes/2), 0] ) cylinder( d = cornerDiameter, h = blockZDimension + 2 );
					translate( [cutoutXDistance/2 + (cornerDiameter/2) + (wallThicknes/2), cutoutYDistance/2 + (cornerDiameter/2) + (wallThicknes/2), 0] ) cylinder( d = cornerDiameter, h = blockZDimension + 2 );
				}
			}
		}

		hull()
		{
			{}
			{
				union()
				{
					translate( [cutoutXDistance, 0, 0] ) cylinder( d = cornerDiameter, h = blockZDimension + 2 );
					translate( [cutoutXDistance, cutoutYDistance/2 - (cornerDiameter/2) - (wallThicknes/2), 0] ) cylinder( d = cornerDiameter, h = blockZDimension + 2 );
					translate( [cutoutXDistance/2 + (cornerDiameter/2) + (wallThicknes/2), cutoutYDistance/2 - (cornerDiameter/2) - (wallThicknes/2), 0] ) cylinder( d = cornerDiameter, h = blockZDimension + 2 );
				}
			}
		}

		hull()
		{
			{}
			{
				union()
				{
					translate( [0, cutoutYDistance/2 + (cornerDiameter/2) + (wallThicknes/2), 0] ) cylinder( d = cornerDiameter, h = blockZDimension + 2 );
					translate( [0, cutoutYDistance, 0] ) cylinder( d = cornerDiameter, h = blockZDimension + 2 );
					translate( [cutoutXDistance/2 - (cornerDiameter/2) - (wallThicknes/2), cutoutYDistance/2 + (cornerDiameter/2) + (wallThicknes/2), 0] ) cylinder( d = cornerDiameter, h = blockZDimension + 2 );
				}
			}
		}

		hull()
		{
			{}
			{
				union()
				{
					cylinder( d = cornerDiameter, h = blockZDimension + 2 );
					translate( [0, cutoutYDistance/2 - (cornerDiameter/2) - (wallThicknes/2), 0] ) cylinder( d = cornerDiameter, h = blockZDimension + 2 );
					translate( [cutoutXDistance/2 - (cornerDiameter/2) - (wallThicknes/2), cutoutYDistance/2 - (cornerDiameter/2) - (wallThicknes/2), 0] ) cylinder( d = cornerDiameter, h = blockZDimension + 2 );
				}
			}
		}

		// translate( [cutoutXDistance/2, cutoutYDistance/2, 0] ) cylinder( d = cornerDiameter, h = blockZDimension + 2 );
	}
}

module topBodyShape()
{
	translate( [boltCutoutDepth + (cornerDiameter/2), (cornerDiameter/2), (blockZDimension - boltCutoutHeight)] )
	{
		hull()
		{
			{
				// cube( [(blockXDimension - boltCutoutDepth - cornerDiameter), (blockYDimension - cornerDiameter), topBlockZDimension] );
			}
			{
				union()
				{
					cylinder( d = cornerDiameter, h = topBlockZDimension );
					translate( [(blockXDimension - boltCutoutDepth - cornerDiameter), 0, 0] ) cylinder( d = cornerDiameter, h = topBlockZDimension );
					translate( [0, (blockYDimension - cornerDiameter), 0] ) cylinder( d = cornerDiameter, h = topBlockZDimension );
					translate( [(blockXDimension - boltCutoutDepth - cornerDiameter), (blockYDimension - cornerDiameter), 0] ) cylinder( d = cornerDiameter, h = topBlockZDimension );
				}
			}
		}
	}
}



module bottomBodyShape()
{
	hull()
	{
		{
			// translate( [(cornerDiameter/2), (cornerDiameter/2), 0] ) cube( [(blockXDimension - cornerDiameter), (blockYDimension - cornerDiameter), blockZDimension] );
		}
		{
			union()
			{
				translate( [(cornerDiameter/2), (cornerDiameter/2), 0] ) cylinder( d = cornerDiameter, h = (blockZDimension - boltCutoutHeight) );
				translate( [(cornerDiameter/2), (blockYDimension - (cornerDiameter/2)), 0] ) cylinder( d = cornerDiameter, h = (blockZDimension - boltCutoutHeight) );
				translate( [(blockXDimension - (cornerDiameter/2)), (cornerDiameter/2), 0] ) cylinder( d = cornerDiameter, h = (blockZDimension - boltCutoutHeight) );
				translate( [(blockXDimension - (cornerDiameter/2)), (blockYDimension - (cornerDiameter/2)), 0] ) cylinder( d = cornerDiameter, h = (blockZDimension - boltCutoutHeight) );
			}
		}
	}
}





