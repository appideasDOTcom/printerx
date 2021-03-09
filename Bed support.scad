/**
* Bed corner braces for printerX
*
*/

// Minimum render angle
$fa = 1;
// Minimum render size
$fs = 0.1;

glassHeight = 3;
glassXY = 213;

plateHeight = 1.6;
plateXY = glassXY;

protuberanceAmount = 4.4;
cornerRadius = 2;

inlayAmount = glassHeight + plateHeight + 0.8;
inlayTolerance = 0.8;

bodyHeight = inlayAmount + 8;
bodyX = 25;
bodyY = 25;

carriageBoltCornerOffset = 5;

floorWidth = 7;

m3HeadHeight = 3.3;
m3HeadDiameter = 6;
m3ThroughHoleDiameter = 3.7;
m3NutDiameter = 6.9;
m3NutDepth = 2.6;

m3HexHeadDiameter = 6.9;
m3HexHeadHeight = 2.4;

springCatchDiamter = 11;
springCatchDepth = 3.4;
springCatchRingThickness = 0.6;

printJig = true;


// glass();
// plate();
bodyConstruction();

module bodyConstruction()
{
	difference()
	{
		{
			union()
			{
				body();
			}
		}
		{
			
			union()
			{
				if( !printJig ) {
					plateCutout();
					carriageCutout();
				}
				tiedownCutout();
			}
		}
	}
	if( !printJig ) {
		springCatchSupport();
	}
}

tiedownWidth = 8.2;
tiedownCornerOffset = 2;
tiedownAngle = 45;
tiedownTopDepth = 1;
tiedownSideDepth = 1;

module tiedownCutout()
{
	translate( [0, 0, inlayAmount - tiedownTopDepth] )
	{
		translate( [34, -33, 0] )
		{
			rotate( [0, 0, tiedownAngle] )
			{
				tiedownForm();
			}
		}

		difference()
		{
			{
				translate( [38.4, (-1 * protuberanceAmount) + tiedownSideDepth, -33] )
				{
					rotate( [0, -45, 0] )
					{
						rotate( [90, 0, 0] )
						{
							tiedownForm();
						}
					}
				}
			}
			{
				translate( [-50, -10, 0] ) cube( [100, 30, 50] );
			}
		}

		difference()
		{
			{
				translate( [(-1 * (protuberanceAmount + 2)) + tiedownSideDepth, 38.4, -33] )
				{
					rotate([45, 0, 0]) rotate( [0, 90, 0] ) rotate( [0, 0, 90] )
					{
						tiedownForm();
					}
				}
			}
			{
				union()
				{
					translate( [-50, -10, 0] ) cube( [100, 30, 50] );
				}
			}
		}

		// translate( [(-1 * protuberanceAmount) + tiedownSideDepth, 2, (-1 * tiedownTopDepth) + 1] )
		// {
		// 	edgeCutout();
		// }

		// translate( [2, -1 * tiedownSideDepth - 0.2, (-1 * tiedownTopDepth) + 2] )
		// {
		// 	edgeCutoutCopy();
		// }
	}

	translate( [-1 * protuberanceAmount - inlayTolerance, (bodyY/2) + protuberanceAmount + 2.8, -1 * protuberanceAmount] ) 
	{
		if( !printJig ) {
			translate( [-2, 0, 0] ) rotate( [0, 90, 0] ) m3ThroughHole( height = (10 + protuberanceAmount) );
			translate( [protuberanceAmount, 0, 0] ) rotate( [30, 0, 0] ) rotate( [0, 90, 0] ) m3Nut();
			translate( [protuberanceAmount, (-1 * (m3NutDiameter/2)), 0] ) cube( [m3NutDepth + 0.2, m3NutDiameter, 5] );
		} else {
			translate( [-2, 0, 0] ) rotate( [0, 90, 0] ) m3ThroughHole( height = (20 + protuberanceAmount) );
		}
	}

	translate( [(bodyX/2) + protuberanceAmount + 2.8, -1 * inlayTolerance, -1 * protuberanceAmount] ) 
	{
		if( !printJig ) {
			translate( [0, 8, 0] ) rotate( [90, 0, 0] ) m3ThroughHole( height = (10 + protuberanceAmount) );
			translate( [0, m3NutDepth + 0.2, 0] ) rotate( [0, 0, 0] ) rotate( [90, 0, 0] ) m3Nut();
			rotate( [0, 0, 90] ) translate( [0, (-1 * (m3NutDiameter/2)), 0] ) cube( [m3NutDepth + 0.2, m3NutDiameter, 5] );
		} else {
			translate( [0, 18, 0] ) rotate( [90, 0, 0] ) m3ThroughHole( height = (20 + protuberanceAmount) );
		}
	}

}

module edgeCutout()
{
	hull()
	{
		{

		}
		{
			union()
			{
				translate( [-0.1, 0.1, 0] ) rotate( [0, 0, -45] ) cube( [0.1, 0.1, 0.1] );
				translate( [(-1 * tiedownSideDepth), 1, 0] )
				{
					rotate( [0, 0, -45] ) cube( [0.1, 0.1, 0.1] );
					translate( [0, 0.8, -0.8] )
					{
						cube( [0.1, 0.1, 0.1] );
						translate( [0, -0.75, 0.33] ) cube( [0.1, 0.1, 0.1] );
						translate( [tiedownSideDepth - 0.1, 0, 0] ) cube( [0.1, 0.1, 0.1] );
						translate( [tiedownSideDepth - 0.1, 0, 1] ) cube( [0.1, 0.1, 0.1] );
					}
				}
			}
		}
	}
}

module edgeCutoutCopy()
{
	hull()
	{
		{

		}
		{
			union()
			{
				translate( [0.1, 0.1, (-1 * tiedownSideDepth)] ) rotate( [0, 0, -45] ) cube( [0.1, 0.1, 0.1] );
				translate( [(tiedownSideDepth) - 0.1, -1 * tiedownSideDepth + 0.3, (-1 * tiedownSideDepth)] )
				{
					translate( [0.05, -0.05, 0] ) rotate( [0, 0, -45] ) cube( [0.1, 0.1, 0.1] );
					translate( [0, 0.9 + (-1 * tiedownSideDepth), -0.8] )
					{
						translate( [ 0.9, 0, 0 ] ) cube( [0.1, 0.1, 0.1] );
						translate( [0.2, 0, 0.33] ) cube( [0.1, 0.1, 0.1] );
						translate( [tiedownSideDepth - 0.1, tiedownSideDepth - 0.1, 0] ) cube( [0.1, 0.1, 0.1] );
						translate( [tiedownSideDepth - 0.1, tiedownSideDepth - 0.1, 1] ) cube( [0.1, 0.1, 0.1] );
					}
				}
			}
		}
	}
}

module tiedownForm()
{
	cube( [tiedownWidth, 100, 2] );
}


module plateCutout() {

	linear_extrude( height = 20)
	{
		offset( delta = inlayTolerance ) square( size = [glassXY, glassXY] );
	}

}

module carriageCutout()
{
	translate( [carriageBoltCornerOffset, carriageBoltCornerOffset, 0] )
	{
		translate( [0, 0, -19.9] )
		{
			m3ThroughHole( height = 20 );
		}

		translate( [0, 0, (-1 * m3HexHeadHeight)] ) cylinder( d = m3HexHeadDiameter, h = m3HexHeadHeight + 0.1, $fn = 6 );
		translate( [0, 0, (-1 * bodyHeight) + glassHeight + plateHeight + inlayTolerance - 0.1] ) cylinder( d = springCatchDiamter, h = springCatchDepth + 0.1 );
	}
}


module glass() {
	color( "blue" )
	{
		translate( [0, 0, plateHeight] ) cube( [glassXY, glassXY, glassHeight] );
	}
}

module plate() {
	color( "red" )
	{
		cube( [plateXY, plateXY, plateHeight] );
	}
}

module springCatchSupport()
{
	translate( [carriageBoltCornerOffset, carriageBoltCornerOffset, (-1 * bodyHeight) + inlayAmount] )
	{
		difference()
		{
			{
				union()
				{
					linear_extrude( height = springCatchDepth )
					{
						offset( delta = springCatchRingThickness ) circle( d = m3ThroughHoleDiameter );
					}
				}
			}
			{
				translate( [0, 0, 0-.1] ) cylinder( d = m3ThroughHoleDiameter, h = springCatchDepth + 0.2 );
			}
		}

	}
}

module body()
{
	translate( [0, 0, (-1 * bodyHeight) + inlayAmount] )
	{
		linear_extrude( height = bodyHeight )
		{
			offset( r = cornerRadius ) offset( r = (protuberanceAmount - cornerRadius)) square( size = [bodyX, floorWidth] );
			offset( r = cornerRadius ) offset( r = (protuberanceAmount - cornerRadius)) square( size = [floorWidth, bodyY] );
		}
	}




}



// An M3 head cutout
module m3Head()
{
    cylinder( d = m3HeadDiameter, h = m3HeadHeight );
}

// A through-hole for an M3 bolt
module m3ThroughHole( height )
{
	cylinder( d = m3ThroughHoleDiameter, h = height );
}

// A nut trap for an M3 bolt
module m3Nut()
{
    cylinder( d = m3NutDiameter, h = (m3NutDepth + 0.2), $fn = 6 );
}

module m3HexHead()
{
	cylinder( d = m3HexHeadDiameter, h = m3HexHeadHeight );
}