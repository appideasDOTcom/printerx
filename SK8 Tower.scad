/**
* An SK8 tower
*
*/

$fa = 1;
$fs = 0.1;

baseWidth = 44;
baseDepth = 14;
baseHeight = 6;
bodyWidth = 18;
bodyHeight = 32;
cornerDiameter = 3;
tempOffset = 2; // An arbitrary offset to match an initial model dimensions
rodDiameter = 8;
rodHeightOffset = 20;
gapWidth = 1.2;

construction();

module construction()
{
	difference()
	{
		{
			union()
			{
				sk8Base();
				sk8Body();
				translate( [0, baseHeight + (cornerDiameter/2), 0] )
				{
					translate( [(baseWidth/2) + (bodyWidth/2) - (0.5), 0, 0] ) essCurve( d = cornerDiameter, h = baseDepth );
					translate( [-(0.5) + (baseWidth/2) - (bodyWidth/2) - cornerDiameter, 0, 0] ) rotate( [0, 0, 90] ) essCurve( d = cornerDiameter, h = baseDepth );
				}
			}
		}
		{
			cutouts();
		}

	}
}

module sk8Body() 
{
	translate( [-5.5, (-1 * (cornerDiameter/2)), 0] )
	{
		linear_extrude( height = baseDepth )
		{
			minkowski() {
				translate( [cornerDiameter/2, cornerDiameter/2, 0] ) square( size = [(bodyWidth - cornerDiameter), (bodyHeight - cornerDiameter)] );
				translate( [bodyWidth - (cornerDiameter/2), (cornerDiameter/2), 0] ) circle( d = cornerDiameter );
			}
		}

	}
}

module sk8Base()
{
	translate( [-1 * tempOffset, baseHeight, 0] )
	{
		rotate( [90, 0, 0] )
		{
			linear_extrude( height = baseHeight )
			{
				minkowski()
				{
					square( size = [(baseWidth - cornerDiameter), (baseDepth - cornerDiameter)] );
					translate( [(cornerDiameter/2), (cornerDiameter/2), 0] ) circle( d = cornerDiameter );
				}
			}

		}
	}
}

module cutouts()
{
	translate( [(baseWidth/2) - (rodDiameter/2) + tempOffset, rodHeightOffset, -1] )
	{
		cylinder( d = rodDiameter, h = 20 );
		translate( [-1 * (gapWidth/2), 0, 0] ) cube( [gapWidth, 20, 20] );
		translate( [-10, (rodDiameter/2) + 2.5 + 1, (baseDepth/2) + 1.25] )
		{
			rotate( [90, 0, 0] )
			{
 				translate( [baseWidth - bodyWidth, 0, 15] ) m4ThroughHole();
				translate( [-6, 0, 15] ) m4ThroughHole();
			}
			
			rotate( [0, 90, 0] )
			{
				m4ThroughHole();
				translate( [0, 0, 0.9] ) m4Head();
				translate( [0, 0, bodyWidth - 1.9] ) m4Nut();
			}
		}
	}
}

module m4Head()
{
    cylinder( h = 3.9, r = 3.6 );
}

module m4Nut()
{
    cylinder( h = 3.0, r = 4.1, $fn=6 );
}

module m4ThroughHole()
{
    cylinder( r=2.5, h=20, center=false );
}

module essCurve( d, h )
{
  xDimension = d;
  yDimension = d;
  zDimension = h;

  difference()
    {
      {
        translate( [(-1 * (xDimension / 2)), (-1 * (yDimension / 2)), 0] )
        {
          cube( [xDimension, yDimension, zDimension] );
        }
      }
      {
        translate( [ 0, 0, -1 ] )
        {
          translate( [0, (-1 * yDimension), 0] )
          {
            cube( [xDimension, yDimension * 2, (zDimension + 2)] );
          }
          translate( [(-1 * xDimension), 0, 0] )
          {
            cube( [xDimension, yDimension, (zDimension + 2)] );
          }

          linear_extrude( height=(zDimension + 2), twist=0, scale=[1, 1], center=false)
          {
            $fn=64;    //set sides to 64
            circle(r=(xDimension / 2));
          }
          
        }

      }
    
  }
}