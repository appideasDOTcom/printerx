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

inlayClamp = 2.0;

inlayAmount = glassHeight + plateHeight + inlayClamp;
inlayTolerance = 0; // clamp a little bit

bodyHeight = inlayAmount + 8;
bodyX = 25;
bodyY = 25;

carriageBoltCornerOffset = 2.5;

floorWidth = 7;

m3HeadHeight = 3.3;
m3HeadDiameter = 6;
m3ThroughHoleDiameter = 3.7;
m3NutDiameter = 6.4;
m3NutDepth = 2.6;

m3HexHeadDiameter = 6.8;
m3HexHeadHeight = 2.4;

springCatchDiamter = 8.5;
springCatchDepth = 3.4; // Currently leaves 2.2mm before the hex head
springCatchRingThickness = 0.4;

printJig = false;


// glass();
// plate();
// bodyConstruction();
// pressFitJig();
pressFitStick();
// siliconShape_Bed();

module siliconShape_Bed() {

	difference() 
	{
		{
			translate( [0, 0, (-1 * bodyHeight) + inlayAmount] )
			{
				linear_extrude( height = bodyHeight - inlayAmount )
				{
					offset( r = cornerRadius ) offset( r = (protuberanceAmount - cornerRadius)) square( size = [bodyX, floorWidth] );
					offset( r = cornerRadius ) offset( r = (protuberanceAmount - cornerRadius)) square( size = [floorWidth, bodyY] );
				}
			}
		}
		{
			union()
			{
				translate( [ 
					-1 * (protuberanceAmount) - 0.1,
					-10, 
					-10 ] ) 
						cube( [protuberanceAmount + 0.1, 50, 20] );
				translate( [
					-10,
					-1 * (protuberanceAmount) - 0.1,
					-10 ] ) 
						cube( [50, protuberanceAmount + 0.1, 20] );
			}
		}
	}


}

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
		// springCatchSupport();
	}

	// A plug that can be easily drilled out to avoid having to print with supports
	translate( [carriageBoltCornerOffset, carriageBoltCornerOffset, -1 * m3HexHeadHeight - 0.2] )
	{
		// m3ThroughHole( height = 0.2 );
		translate( [0, 0, -3.7] ) m3ThroughHole( height = 0.2 );
	}
}

tiedownWidth = 8.3;
tiedownCornerOffset = 2;
tiedownAngle = 45;
tiedownTopDepth = 2.5;
tiedownSideDepth = 1;

pressFitWidth = tiedownWidth - 0.4;

module pressFitStick() 
{
	hull()
	{
		{

		}
		{
			union()
			{
				translate( [2, 2, 1.5] ) cylinder( d = 4, h = 1.5 );
				translate( [tiedownWidth - 2.5, 2, 1.5] ) cylinder( d = 4, h = 1.5 );
				translate( [0.5, 2, 0] ) cube( [6.8, 2, 3] );

				translate( [0.5, 31, 0] ) cube( [6.8, 2, 3] );
				translate( [2, 33, 1.5] ) cylinder( d = 4, h = 1.5 );
				translate( [tiedownWidth - 2.5, 33, 1.5] ) cylinder( d = 4, h = 1.5 );
			}
		}
	}
}

module pressFitJig()
{
	// %bodyConstruction();
	difference()
	{
		{
			translate( [-1 * protuberanceAmount - 5, -1 * protuberanceAmount - 5, inlayAmount - inlayClamp - 0.5] )
			{
				cube( [43.8, 43.8, 7] );
			}
		}
		{
			union()
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
							tiedownCutout();
						}
					}
				}

				translate( [29.4, -15, 0] ) rotate( [0, 0, 45] ) cube( [40, 70, inlayAmount] );
				translate( [0, -25, 0] ) rotate( [0, 0, 45] ) cube( [20, 40, inlayAmount] );

				scaleUpFactor = 1.05;

				translate( [0, 0, inlayAmount - tiedownTopDepth] )
				{
					translate( [40.4 - 0.3, (-1 * protuberanceAmount) + tiedownSideDepth + 0, -33] )
					{
						rotate( [0, -45, 0] )
						{
							rotate( [90, 0, 0] )
							{
								scale( [scaleUpFactor, scaleUpFactor, scaleUpFactor] ) tiedownForm();
							}
						}
					}


					translate( [(-1 * (protuberanceAmount + 2)) + tiedownSideDepth - 1 - 0, 40.4 - 0.3, -33] )
					{
						rotate([45, 0, 0]) rotate( [0, 90, 0] ) rotate( [0, 0, 90] )
						{
							scale( [scaleUpFactor, scaleUpFactor, scaleUpFactor] ) tiedownForm();
						}
					}
				}




			}
		}
	}
}

module tiedownCutout()
{
	translate( [0, 0, inlayAmount - tiedownTopDepth] )
	{
		translate( [35, -32, 0] )
		{
			rotate( [0, 0, tiedownAngle] )
			{
				tiedownForm();
			}
		}

		difference()
		{
			{
				translate( [40.4, (-1 * protuberanceAmount) + tiedownSideDepth, -33] )
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
				translate( [(-1 * (protuberanceAmount + 2)) + tiedownSideDepth - 1, 40.4, -33] )
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

		// Chopp off a little of the overhang so that the metal folds more easily
		translate( [(-1 * protuberanceAmount) - tiedownSideDepth, 4, 0] )
		{
			cube( [5, 4, 3] );
		}
		translate( [4, (-1 * protuberanceAmount) - tiedownSideDepth, 0] )
		{
			cube( [4, 5, 3] );
		}
	}

	translate( [-1 * protuberanceAmount - inlayTolerance, (bodyY/2) + protuberanceAmount + 5, -1 * protuberanceAmount] ) 
	{
		if( !printJig ) {
			translate( [-2, 0, 0] ) rotate( [0, 90, 0] ) m3ThroughHole( height = (10 + protuberanceAmount) );
			translate( [protuberanceAmount + 0, 0, 0] ) rotate( [30, 0, 0] ) rotate( [0, 90, 0] ) m3Nut();
			translate( [protuberanceAmount + 0, (-1 * (m3NutDiameter/2)), 0] ) cube( [m3NutDepth + 0.2, m3NutDiameter, 5] );
		} else {
			translate( [-2, 0, 0] ) rotate( [0, 90, 0] ) m3ThroughHole( height = (20 + protuberanceAmount) );
		}
	}

	translate( [(bodyX/2) + protuberanceAmount + 5, -1 * inlayTolerance, -1 * protuberanceAmount] ) 
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
	cube( [tiedownWidth, 100, 3] );
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

		translate( [0, 0, (-1 * m3HexHeadHeight)] ) {
			cylinder( d = m3HexHeadDiameter, h = m3HexHeadHeight + 10, $fn = 6 );
			// translate( [(-1 * (m3HexHeadDiameter/2)), 0, 0] ) cylinder( d = 0.8, h = 10 );
		}
		translate( [0, 0, (-1 * bodyHeight) + glassHeight + plateHeight + inlayTolerance + 0.3] ) cylinder( d = springCatchDiamter, h = springCatchDepth );
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