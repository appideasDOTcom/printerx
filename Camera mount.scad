/**
* A mount for a Raspberry Pi camera on printerX
*
*/

// Minimum render angle
$fa = 4;
// Minimum render size
$fs = 1;

wallThickness = 3;
cornerRadius = 2;

// add tolerance to the documented spec
pcbWidth = 25.6; // documented: 25.0;
pcbHeight = 24.3; // documented: 23.862
depressionDepth = 4.8;
backingHeight = 10;

faceTolerance = 0.3;
faceWidth = pcbWidth - faceTolerance;
faceHeight = pcbHeight - faceTolerance;
faceBottom = 5.4; // Amount of space beneath the lens opening

connectorWidth = 21.3; // documented: 20.8
connectorHeight = 5.9; // documented: 5.5 (we're extendeing infinitely)
connectorDepth = 1.6; // undocumented

ballInterfaceDiameter = 15.2;
ballInterfaceDepth = 0.8;

m3HeadHeight = 3.3;
m3HeadDiameter = 6;
m3ThroughHoleDiameter = 3.7;
m3NutDiameter = 6.9;
m3NutDepth = 2.6;

m5HeadHeight = 5.1;
m5HeadDiameter = 9;
m5ThroughHoleDiameter = 5.4;
m5NutDiameter = 9.2;
m5NutDepth = 4.3;

armThickness = 7; // Should be >= the height of a corner bracket
armCornerDiameter = 4;
armReach = 70;
// armHeight = 55;
armHeight = 105;
armWidth = 15;
armLiftInset = 3;
extraArmDiameter = 6;
extraArmDepth = 4;
reachWidth = armWidth + extraArmDiameter;

extraArmSideOffset = 35;

cableOpeningWidth = 18;
cableOpeningHeight = 1.4;
cableOpeningStructureHeight = 6;
cableOpeningBottom = 22.5;

faceDepth = depressionDepth - 2.2; // Depth of the face insert
lensCutoutXY = 8.9;
lensCableDepth = 2.4;
lensCableHeight = 7.8;
lensCableOffsetX = 2.4;
lensCableWidth = lensCutoutXY + lensCableOffsetX;

faceCoverDepth = 8;

passthroughGap = 18; // distance between passthrough holes -- currently disabled

/* Printable pieces */
// ballJoint();
// body();
// face();
// armReach();
armLift();
// screw();
// siliconShape_Circle();

/* Fully-articulated pieces */
// renderArticulated();

module renderArticulated() {

	armReach();

	translate( [extraArmSideOffset, -1 * (armThickness/2) + (armCornerDiameter/2), armThickness - armLiftInset + extraArmDepth] ) armLift();

	translate( [armWidth + 3 + extraArmSideOffset, armThickness - 2, armHeight - 25] )
	rotate( [0, 0, 180] )
	rotate( [90, 0, 0] ) {
		translate( [0, 0, 22] ) body();
		translate( [(pcbWidth/2), (pcbHeight/1.5), 0] )
		{
			translate( [0, 0, 22] ) ballJoint();
			translate( [0, 0, 31] ) rotate( [180, 0, 0] ) import( "thirdparty/Ball_Joint/files/Screw_v3.stl" );
		}
	}


	// translate( [8.6, armReach + (armCornerDiameter/2) + 0.4, armThickness + 0.8] ) {
	// 	rotate( [0, 0, 90] ) import( "output/Bed support.stl" );
	// }
}

module screw() {
	import( "thirdparty/Ball_Joint/files/Screw_v3.stl" );
}

module armConnectorRight() {

	difference()
	{
		{
			union()
			{
				hull()
				{
					{

					}
					{
						union()
						{
							translate( [0, 1.5, 0] ) cylinder( d = armCornerDiameter, h = armThickness );
							translate( [0, -35, 0] ) cylinder( d = armCornerDiameter, h = armThickness );
							translate( [armCornerDiameter, -35, 0] ) cylinder( d = armCornerDiameter, h = armThickness );
							translate( [armCornerDiameter, 1.5, 0] ) cylinder( d = armCornerDiameter, h = armThickness );
						}
					}
				}
			}
		}
		{
			// translate( [-31, -1 * (armReach - armCornerDiameter) + 15, 0] ) {
			// 	armThroughHoles();
			// }
		}
	}



}

module armConnectorLeft() {

	difference()
	{
		{
			union()
			{
				hull()
				{
					{

					}
					{
						union()
						{
							translate( [-1.5, 0, 0] ) cylinder( d = armCornerDiameter, h = armThickness );
							translate( [13 + armWidth + (armCornerDiameter/2) + extraArmSideOffset, 0, 0] ) cylinder( d = armCornerDiameter, h = armThickness );
							translate( [13 + armWidth + (armCornerDiameter/2) + extraArmSideOffset, -1 * armCornerDiameter, 0] ) cylinder( d = armCornerDiameter, h = armThickness );
							translate( [-1.5, -1 * armCornerDiameter, 0] ) cylinder( d = armCornerDiameter, h = armThickness );
						}
					}
				}
				// translate( [16, -35.98, 0] ) rotate( [0, 0, 180] ) essCurve( d = 60, h = armThickness );
				translate( [37 + armWidth + armCornerDiameter, -1 * (armCornerDiameter * 2) + 28.98, 0] ) rotate( [0, 0, 0] ) essCurve( d = 38, h = armThickness );

				translate( [10.5, -1 * armCornerDiameter, 0]  )
				{
					hull()
					{
						{

						}
						{
							union()
							{
								cylinder( d = armCornerDiameter, h = armThickness );
								translate( [armCornerDiameter * 2, 0, 0] ) cylinder( d = armCornerDiameter, h = armThickness );
								translate( [armCornerDiameter * 2 + 30, -45, 0] ) cylinder( d = armCornerDiameter, h = armThickness );
								translate( [armCornerDiameter * 2 + 30, -45 - (armCornerDiameter * 2), 0] ) cylinder( d = armCornerDiameter, h = armThickness );
							}
						}
					}

				}
			}
		}
	{
	// 	armThroughHoles();
	}
}





}

module armThroughHoles() {
	translate( [0, 0, (armThickness/2) - 0.1] ) {

		translate( [2.7, 10, 0] ) rotate( [90, 0, 0] ) {
			m3ThroughHole( height = 20);
			translate( [0, 0, 16 - m3HeadHeight + 0.1] ) m3Head();
		}

		// translate( [4, -4, 0] ) rotate( [0, 90, 0] ) {
		// 	m3ThroughHole( height = 20);
		// 	translate( [0, 0, 7.2 + m3NutDepth + 1.6] ) {
		// 		rotate( [0, 0, 30] ) m3Nut();
		// 		translate( [-5, -1 * (m3NutDiameter/2), 0.0] ) cube( [5, m3NutDiameter, m3NutDepth + 0.2] );
		// 	}
		// }
		// translate( [4, -15, 0] ) rotate( [0, 90, 0] ) {
		// 	m3ThroughHole( height = 20);
		// 	translate( [0, 0, 7.2 + m3NutDepth + 1.6] ) {
		// 		rotate( [0, 0, 30] ) m3Nut();
		// 		translate( [-5, -1 * (m3NutDiameter/2), 0.0] ) cube( [5, m3NutDiameter, m3NutDepth + 0.2] );
		// 	}
		// }

		// translate( [19, -20, 0] ) rotate( [0, 90, 0] ) {
		// 	m3ThroughHole( height = 20);
		// 	translate( [0, 0, 10 - m3NutDepth - 1.6] ) {
		// 		rotate( [0, 0, 30] ) m3Nut();
		// 		translate( [-5, -1 * (m3NutDiameter/2), 0.0] ) cube( [5, m3NutDiameter, m3NutDepth + 0.2] );
		// 	}
		// }
		// translate( [19, -9.5, 0] ) rotate( [0, 90, 0] ) {
		// 	m3ThroughHole( height = 20);
		// 	translate( [0, 0, 10 - m3NutDepth - 1.6] ) {
		// 		rotate( [0, 0, 30] ) m3Nut();
		// 		translate( [-5, -1 * (m3NutDiameter/2), 0.0] ) cube( [5, m3NutDiameter, m3NutDepth + 0.2] );
		// 	}
		// }

		translate( [19, 28.3, 0] ) rotate( [0, 90, 0] ) {
			m3ThroughHole( height = 20);
			translate( [0, 0, 18 - m3HeadHeight + 0.1] ) m3Head();
		}
	}


}

module armReach()
{

	difference()
	{
		{
			union()
			{
				translate( [-1 * (extraArmDiameter/2) + extraArmSideOffset, 0, 0] )
				linear_extrude( height = armThickness )
					offset( r = (armCornerDiameter/2) )
					square( size = [(reachWidth - armCornerDiameter), (armReach - armCornerDiameter)] );



				translate( [-16, armReach - armCornerDiameter, 0] ) {
					armConnectorLeft();
				}

				translate( [15, armReach - armCornerDiameter + 31, 0] ) {
					armConnectorRight();
				}

				translate( [(armWidth/2) - (armCornerDiameter/2) +  extraArmSideOffset, 0, 0] ) {
					cylinder( d = armWidth + extraArmDiameter, h = armThickness + extraArmDepth );
				}
			}
		}
		{
			translate( [-1 * armWidth - 1, armReach - 4, 0] ) armThroughHoles();
			translate( [(armWidth/2) - (armCornerDiameter/2) +  extraArmSideOffset, 0, armThickness - armLiftInset + extraArmDepth] ) {
				cylinder( d = armWidth + 0.8, h = armLiftInset + 0.1 );
				translate( [0, 0, -10] ) m5ThroughHole( height = 20 );
				translate( [0, 0, -9 - extraArmDepth + m5HeadHeight - 0.2 ] ) m5Head();
			}
		}
	}

	// Bridge over this hole for better printing and an easy drill to clean-up
	translate( [(armWidth/2) - (armCornerDiameter/2) +  extraArmSideOffset, 0, m5HeadHeight - 0.1] ) {
		cylinder( d = m5ThroughHoleDiameter, h = 0.2 );
	}

}

module siliconShape_Circle() {
	translate( [5.525, 1.5, 0] )
	{
		difference()
		{
			{
				cylinder( d = armWidth , h = 7 );
			}
			{
				translate( [0, 0, 3] )
				m5ThroughHole( height = 4.1);
			}
		}
	}

}

module armLift() {

	difference()
	{
		{
			union()
			{
				// A semi-circle at the bottom for stability
				translate( [5.525, 1.5, 0] )
				{
					difference()
					{
						{
							cylinder( d = armWidth , h = 2 );
						}
						{
							translate( [-1 * (armWidth/2), -1 * (armWidth/2) - armCornerDiameter + 0.5 + 3, -0.1] ) cube( [armWidth, (armWidth/2) + 1, 2.2] );
						}
					}

				}

				hull()
				{
					{

					}
					{
						union()
						{
							cylinder( d = armCornerDiameter, h = armHeight - (armCornerDiameter/2) );
							translate( [armWidth - armCornerDiameter, 0, 0] ) cylinder( d = armCornerDiameter, h = armHeight - (armCornerDiameter/2) );
							translate( [armWidth - armCornerDiameter, armThickness - armCornerDiameter, 0] ) cylinder( d = armCornerDiameter, h = armHeight - (armCornerDiameter/2) );
							translate( [0, armThickness - armCornerDiameter, 0] ) cylinder( d = armCornerDiameter, h = armHeight - (armCornerDiameter/2) );

							translate( [0, 0, armHeight - (armCornerDiameter/2)] ) {
								sphere( d = armCornerDiameter );
								translate( [armWidth - armCornerDiameter, 0, 0] ) sphere( d = armCornerDiameter );
								translate( [armWidth - armCornerDiameter, armThickness - armCornerDiameter, 0] ) sphere( d = armCornerDiameter );
								translate( [0, armThickness - armCornerDiameter, 0] ) sphere( d = armCornerDiameter );
							}

						}
					}
				}


				translate( [5.2, -1 * (armCornerDiameter/2) + armThickness, armHeight - 13.8] ) {
					rotate( [90, 0, 0] ) {
						cylinder( d = 23, h = armThickness );
						translate( [0, 0, -9.9] ) rotate( [0, 180, 0] ) import( "thirdparty/Ball_Joint/files/Base_v3.stl" );
					}
				}

				translate( [5.2, -1 * (armCornerDiameter/2) + armThickness, cableOpeningBottom] ) {
					cablePassthroughShape();
					// translate( [0, 0, passthroughGap] ) cablePassthroughShape();
				}

			}
		}
		{
			translate( [(armWidth/2) - (armCornerDiameter/2), (armCornerDiameter/2) - 0.5, 0] ) {
				translate( [0, 0, -3.1] ) m5ThroughHole( height = 26 );
				translate( [0, 0, 10] ) m5Nut();
				translate( [-1 * (m5NutDiameter/2), 0, m5HeadHeight - 0.1 + 5] ) cube( [m5NutDiameter, 5, m5NutDepth] );
			}

			translate( [5.2, -1 * (armCornerDiameter/2) + armThickness + 0.1, cableOpeningBottom] ) {

				// HERE
				cablePassthroughCutout();
				// translate( [0, 0, passthroughGap] ) cablePassthroughCutout();
			}

		}


	}
}

module cablePassthroughShape()
{

	hull()
	{
		{

		}
		{
			union()
			{
				// Added a little thickness to reduce flex and vibration
				translate( [(cableOpeningWidth/2), 0, 0] ) rotate( [90, 0, 0] ) cylinder( d = cableOpeningStructureHeight, h = armThickness );
				translate( [(cableOpeningWidth/2) - (cableOpeningStructureHeight/2), 0, (cableOpeningStructureHeight/2)] ) rotate( [90, 0, 0] ) cylinder( d = cableOpeningStructureHeight, h = armThickness );
				translate( [(cableOpeningWidth/2) - (cableOpeningStructureHeight/2), 0, -1 * (cableOpeningStructureHeight/2)] ) rotate( [90, 0, 0] ) cylinder( d = cableOpeningStructureHeight, h = armThickness );

				translate( [-1 * (cableOpeningWidth/2), 0, 0] ) rotate( [90, 0, 0] ) cylinder( d = cableOpeningStructureHeight, h = armThickness );
				translate( [-1 * (cableOpeningWidth/2) + (cableOpeningStructureHeight/2), 0, (cableOpeningStructureHeight/2)] ) rotate( [90, 0, 0] ) cylinder( d = cableOpeningStructureHeight, h = armThickness );
				translate( [-1 * (cableOpeningWidth/2) + (cableOpeningStructureHeight/2), 0, -1 *(cableOpeningStructureHeight/2)] ) rotate( [90, 0, 0] ) cylinder( d = cableOpeningStructureHeight, h = armThickness );
			}
		}
	}


}

module cablePassthroughCutout() {
	hull()
	{
		{

		}
		{
			union()
			{
				translate( [(cableOpeningWidth/2), 0, 0] ) rotate( [90, 0, 0] ) cylinder( d = cableOpeningHeight, h = armThickness + 0.2 );
				translate( [-1 * (cableOpeningWidth/2), 0, 0] ) rotate( [90, 0, 0] ) cylinder( d = cableOpeningHeight, h = armThickness + 0.2 );
			}
		}
	}
}


module body()
{
	difference()
	{
		{
			housingBody();
		}
		{
			housingCutouts();
		}
	}
}

module ballJoint()
{
	nutBuryDepth = 7;
	throughHoleBuryDepth = 15;

	difference()
	{
		{
			translate( [0, 0, -12] ) import( "thirdparty/Ball_Joint/files/Ball_v3-solid.stl" );
		}
		{
			union()
			{
				translate( [0, 0, (-1 * throughHoleBuryDepth)] ) m3ThroughHole( height = 20 );
				translate( [0, 0, (-1 * m3NutDepth) - nutBuryDepth] ) m3Nut();
			}

		}
	}
}

module face() {



	translate( [(faceTolerance/2), (faceTolerance/2), 6] )
	{
		difference()
		{
			{
				union()
				{
					cube( [faceWidth, faceHeight, faceDepth] );
					translate( [0, 0, faceDepth] ) linear_extrude( height = faceCoverDepth )
					{
						offset( r = cornerRadius ) offset( delta = (wallThickness - cornerRadius)) square( size = [pcbWidth, pcbHeight] );
					}
				}
			}
			{
				union()
				{
					translate( [(faceWidth/2) - (lensCutoutXY/2), faceBottom, -0.1] ) {
						cube( [lensCutoutXY, lensCutoutXY, faceDepth + faceCoverDepth + 0.2] );
						translate( [-1 * (lensCableOffsetX), lensCutoutXY, 0] ) cube( [lensCableWidth, lensCableHeight, lensCableDepth] );


						lensCutout();
					}
				}
			}
		}
	}

}

module lensCutout() {

	xOffsetFront = 18;
	yOffsetFront = -5;
	topMultiplier = 1.25;

	hull()
	{
		{

		}
		{
			union()
			{
				translate( [0, 0, faceDepth + 0.5] )
				{
					hull()
					{
						{

						}
						{
							union()
							{
								sphere( d = 0.1 );
								translate( [lensCutoutXY, 0, 0] ) sphere( d = 0.1 );

								translate( [xOffsetFront, yOffsetFront, faceCoverDepth] ) sphere( d = 2 );
								translate( [lensCutoutXY - xOffsetFront, yOffsetFront, faceCoverDepth] ) sphere( d = 2 );
							}
						}
					}

					hull()
					{
						{

						}
						{
							union()
							{
								sphere( d = 0.1 );
								translate( [0, lensCutoutXY, 0] ) sphere( d = 0.1 );
								translate( [lensCutoutXY - xOffsetFront, yOffsetFront, faceCoverDepth] ) sphere( d = 2 );
								translate( [lensCutoutXY - xOffsetFront, lensCutoutXY - (yOffsetFront * topMultiplier), faceCoverDepth] ) sphere( d = 2 );
							}
						}
					}

					hull()
					{
						{

						}
						{
							union()
							{
								translate( [0, lensCutoutXY, 0] )
								{
									sphere( d = 0.1 );
									translate( [lensCutoutXY, 0, 0] ) sphere( d = 0.1 );
									translate( [xOffsetFront, (-1 * topMultiplier) * (yOffsetFront), faceCoverDepth] ) sphere( d = 2 );

									translate( [lensCutoutXY - xOffsetFront, (-1 * topMultiplier) * (yOffsetFront), faceCoverDepth] ) sphere( d = 2 );

								}
							}
						}
					}

					hull()
					{
						{

						}
						{
							union()
							{
								translate( [lensCutoutXY, 0, 0] ) {
									sphere( d = 0.1 );
									translate( [0, lensCutoutXY, 0] ) sphere( d = 0.1 );
									translate( [xOffsetFront - lensCutoutXY, yOffsetFront, faceCoverDepth] ) sphere( d = 2 );
									translate( [xOffsetFront - lensCutoutXY, lensCutoutXY - (topMultiplier * yOffsetFront), faceCoverDepth] ) sphere( d = 2 );
								}
							}
						}
					}
				}
			}
		}
	}












}

module housingBody()
{
	linear_extrude( height = backingHeight )
	{
		offset( r = cornerRadius ) offset( delta = (wallThickness - cornerRadius)) square( size = [pcbWidth, pcbHeight] );
	}


}

module housingCutouts()
{
	union()
	{
		translate( [0, 0, (backingHeight - depressionDepth)] ) cube( [pcbWidth, pcbHeight, (depressionDepth + 0.1)] );
		translate( [(pcbWidth/2) - (connectorWidth/2), (-1 * wallThickness) - 0.1, (backingHeight - depressionDepth - connectorDepth)] ) cube( [connectorWidth, connectorHeight + wallThickness + 0.1, connectorDepth + 5] );

		translate( [(pcbWidth/2), (pcbHeight/1.5), backingHeight - m3HeadHeight - depressionDepth + 0.1] )
		{
			m3Head();
			translate( [0, 0, -10] ) m3ThroughHole( height = 20 );
		}

		// Arbitrarily placed pry cutouts
		translate( [-3.9, (pcbHeight/2), 10] ) scale( [1, 2.4, 1.3] ) sphere( d = 6 );
		translate( [-4 + pcbWidth + 8.3, (pcbHeight/2), 10] ) scale( [1, 2.4, 1.3] ) sphere( d = 6 );

		// translate( [(pcbWidth/2), (pcbHeight/1.5), 0] )
		// {
		// 	translate( [0, 0, -0.1] ) cylinder( d = ballInterfaceDiameter, h = ballInterfaceDepth + 0.1 );
		// }
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

module m5Head()
{
    cylinder( d = m5HeadDiameter, h = m5HeadHeight );
}

module m5ThroughHole( height )
{
	cylinder( d = m5ThroughHoleDiameter, h = height );
}

module m5Nut()
{
    cylinder( d = m5NutDiameter, h = m5NutDepth, $fn = 6 );
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