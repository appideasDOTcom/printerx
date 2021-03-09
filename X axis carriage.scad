/* 
Carriage to move the hotend along the X axis
*/

use <Shared-modules.scad>
include <Y carriage bearing retainer.scad>
include <Z axis motor mount.scad>

/* Render quality variables */
$fa = 1;
$fs = 0.1;

xac_distanceBetweenThroughHoles = 31;

xac_neckWidth = 15;

xac_neckCoutoutHeight = 5.8;
xac_neckCoutoutDiameter = 17;

xac_neckHeight = 12;
xac_neckOpeningDiameter = 12.0;
xac_neckClampWidth = 0.4;
xac_neckDistanceFromBody = 22;

xac_neckConnectorXDimension = 8;
xac_neckConnectorYDimension = 8;
xac_neckConnectorZDimension = xac_neckHeight;

xac_cornerDiameter = 4;

xac_neckPlateThickness = 4;

bearingZoffset = (rj4jpLength - baseYDimension) + 5;
xAxisDistanceBetweenRods = 45;

xac_bearingShaftLength = 56;
xac_shellDiameter = shellDiameter + 1.9;
xac_baseThickness = 6.2;

// import( "thirdParty/X-Carriage-mod.stl" );
// constructedXAxisCarriage();
constructedHotendMount( true );

// xac_neck( orientForPrinting = false, buryNutTraps = true );
// fanDuct();


module supportPillar()
{
	hull()
	{
		{

		}
		{
			union()
			{
				cylinder( d = xac_cornerDiameter, h = xac_neckHeight );
				translate( [0, -1 * xac_neckConnectorYDimension, 0] ) cylinder( d = xac_cornerDiameter, h = xac_neckHeight + 0);
				translate( [1.5, 2, -2] ) rotate( [90, 0, 0] ) cylinder( d = xac_cornerDiameter, h = xac_neckHeight );
			}
		}

		
	}
}



// The customized part cooling fan duct
// rotate( [0, 22.5, 0] ) import( "thirdparty/v6_Hotend_Fan_Shroud_and_5015_+_40_Fang_Combo/files/Fang_5015_40mm_fan.stl" );
// translate( [110.65, 100, -35] )
// {
// 	rotate( [0, 0, 0] ) import( "thirdparty/v6_Hotend_Fan_Shroud_and_5015_+_40_Fang_Combo/files/Fang_5015-printerx-fixed.stl" );
// 	translate( [-24.85, -7.9, 0.08] ) cube( [1.1, 6, 12] );
// 	translate( [-24.85, 1.9, 0.089] ) cube( [1.1, 6, 12] );
// }

// translate( [-40.55, 21, -53.5] )
//  rotate( [-67.75, 180, 0] )
//  {
//      rotate( [0, 180, 0] )
//      {
//         %import( "thirdparty/Radial_Fan_Fang_5015.stl" );
//      }
//  }


module fanDuct()
{
    translate( [0, -39, -21] )
    {
        rotate( [0, 270, 0] )
        {
            import( "thirdparty/V6.6_Duct.stl" );
        }
    }


    difference()
    {
        {
            union()
            {
                translate( [11.2, -39, -30] )
                {
                    fanDuctConnectorWall( side = "left" );
                }

                translate( [-14.0, -39, -30] )
                {
                    fanDuctConnectorWall( side = "right" );
                }
            }
        }
        {
			union()
			{
	            translate( [-15, -19, -8] ) rotate( [0, 90, 0] ) m3ThroughHole( height = 30 );
    	        translate( [-15, -33, -8] ) rotate( [0, 90, 0] ) m3ThroughHole( height = 30 );
				translate( [0, -24.2, -36] )sphere( d = 28 );
			}
        }
    }
}



// never used
module fanDuctConnectorWall( side = "right" )
{
	difference()
	{
		{
			hull()
			{
				{

				}
				{
					union()
					{
						translate( [1, 1, -6] ) cylinder( d = 2, h = 31.6 );
						translate( [1.8, 1, -6] ) cylinder( d = 2, h = 31.6 );
						translate( [1, 25, 0] ) cylinder( d = 2, h = 25.6 );
						translate( [1.8, 25, 0] ) cylinder( d = 2, h = 25.6 );

						// translate( [1.4, 1.4, 26] ) sphere( d = 2.8 );
						// translate( [1.4, 22.6, 26] ) sphere( d = 2.8 );
					}
				}
			}
		}
		{
			if( side == "right" )
			{
				translate( [2, 3, -6] ) cylinder( d = 2.7, h = 8 );
			}
			else
			{
				translate( [0.8, 3, -6] ) cylinder( d = 2.7, h = 8 );
			}
		}
	}

}

xac_clipWidth = 16.0;
xac_clipHeight = 0.8;
xac_clipDiameter = 5.5;
xac_clipDepth = 8;
xac_wallDepth = 2.4;
xac_wallHeight = 4.6;

// never used
module fanStabilizer()
{
    translate( [-1 * (xac_clipWidth/2), -1 * xac_clipDepth + 1, -1 * (xac_neckHeight) - 10] )
    {
        difference()
        {
            {
                union()
                {
                    // Clip-in piece
                    cube( [xac_clipWidth, xac_clipHeight, xac_clipDepth] );

                    // Clip-in walls
                    cube( [xac_wallDepth, xac_wallHeight, xac_clipDepth] );
                    translate( [xac_clipWidth - xac_wallDepth, 0, 0] ) cube( [xac_wallDepth, xac_wallHeight, xac_clipDepth] );
                    translate( [0, 0, xac_clipDepth - xac_wallDepth + 0.5] ) cube( [xac_clipWidth, xac_wallHeight, xac_wallDepth - 0.5] );

                    fanStabilizerNeckConnector();
                }
                    
            }
            {
                // cutout
                translate( [(xac_clipWidth/2), 10, 1] )
                {
                    rotate( [90, 0, 0] ) cylinder( d = xac_clipDiameter, h = 20 );

                    // %rotate( [90, 0, 0] ) cylinder( d = 10, h = 20 );
                }
            }
        }
    }
}

// never used
module fanStabilizerNeckConnector()
{
    // extend the walls to the fan duct
    hull()
    {
        {

        }
        {
            union()
            {
                translate( [0, xac_wallHeight, xac_clipDepth - (xac_cornerDiameter/2)] ) rotate([90, 0, 0] ) cylinder( d = xac_cornerDiameter, h = xac_wallHeight );
                translate( [-6, xac_wallHeight, xac_clipDepth - (xac_cornerDiameter/2) - 5] ) rotate([90, 0, 0] ) cylinder( d = xac_cornerDiameter, h = xac_wallHeight );
                translate( [-6, xac_wallHeight, xac_clipDepth - (xac_cornerDiameter/2) - 23.7] ) rotate([90, 0, 0] ) cylinder( d = xac_cornerDiameter, h = xac_wallHeight );
                //#translate( [(xac_cornerDiameter/2), xac_wallHeight, -1 * (xac_cornerDiameter/2)] ) rotate( [90, 90, 0] ) essCurve( d = xac_cornerDiameter, h = xac_wallHeight );
                translate( [6.5, xac_wallHeight, xac_clipDepth - (xac_cornerDiameter/2) - 25.6] ) rotate([90, 0, 0] ) cylinder( d = xac_cornerDiameter, h = xac_wallHeight );

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
                translate( [xac_clipWidth, xac_wallHeight, xac_clipDepth - (xac_cornerDiameter/2)] ) rotate([90, 0, 0] ) cylinder( d = xac_cornerDiameter, h = xac_wallHeight );
                translate( [xac_clipWidth + 6, xac_wallHeight, xac_clipDepth - (xac_cornerDiameter/2) - 5] ) rotate([90, 0, 0] ) cylinder( d = xac_cornerDiameter, h = xac_wallHeight );
                translate( [xac_clipWidth + 6, xac_wallHeight, xac_clipDepth - (xac_cornerDiameter/2) - 23.7] ) rotate([90, 0, 0] ) cylinder( d = xac_cornerDiameter, h = xac_wallHeight );
                translate( [xac_clipWidth - 6.5, xac_wallHeight, xac_clipDepth - (xac_cornerDiameter/2) - 25.6] ) rotate([90, 0, 0] ) cylinder( d = xac_cornerDiameter, h = xac_wallHeight );

            }
        }
    }

    // make the bottom of the shaoe a nicer curve
    hull()
    {
        {

        }
        {
            union()
            {
                translate( [8, xac_wallHeight, xac_clipDepth - (xac_cornerDiameter/2) - 25.8] ) rotate([90, 0, 0] ) cylinder( d = xac_cornerDiameter, h = xac_wallHeight );
                translate( [10, xac_wallHeight, xac_clipDepth - (xac_cornerDiameter/2) - 25.5] ) rotate([90, 0, 0] ) cylinder( d = xac_cornerDiameter, h = xac_wallHeight );
                translate( [6, xac_wallHeight, xac_clipDepth - (xac_cornerDiameter/2) - 25.5] ) rotate([90, 0, 0] ) cylinder( d = xac_cornerDiameter, h = xac_wallHeight );
            }
        }
    }
}


module constructedHotendMount( orientForPrinting = true )
{
    union()
    {
        translate( [-1 * (xac_neckWidth/2), -6, 0] ) rotate( [-90, 0, 0] ) xac_neck( orientForPrinting = orientForPrinting, buryNutTraps = true );

        translate( [-16, -11.5, -1 * xac_neckPlateThickness] )
        {
            xac_neckBaseplate();

            translate( [(xac_neckWidth/2) + 1, 11.5 - (xac_cornerDiameter/2) - 6, -1 * (xac_cornerDiameter/2)] ) rotate( [270, 0, -90] ) essCurve( d = xac_cornerDiameter, h = xac_neckWidth );
            translate( [ xac_neckWidth * 1.5 + 1, 11.5  + (xac_cornerDiameter/2) + xac_neckHeight - 6, -1 * (xac_cornerDiameter/2)] ) rotate( [270, 0, 90] ) essCurve( d = xac_cornerDiameter, h = xac_neckWidth );
        }
    }
}

module xac_neckBaseplate()
{
    difference()
    {
        {
            hull()
            {
                {
                    cube( [32, 24, xac_neckPlateThickness ] );
                }
                {
                    union()
                    {
                        cylinder( d = xac_cornerDiameter, h = xac_neckPlateThickness );
                        translate( [0, 24, 0] ) cylinder( d = xac_cornerDiameter, h = xac_neckPlateThickness );
                        translate( [32, 0, 0] ) cylinder( d = xac_cornerDiameter, h = xac_neckPlateThickness );
                        translate( [32, 24, 0] ) cylinder( d = xac_cornerDiameter, h = xac_neckPlateThickness );
                    }
                }
            }
        }
        {
            translate( [16, 11.5, xac_neckPlateThickness] ) xac_baseplateBoltCutouts();
        }
    }

}

module constructedXAxisCarriage()
{
    difference()
    {
        {
            union()
            {
                xac_retainerShafts();
                xac_baseplate();
                xac_beltRetainers();
                xac_shaftSpaceFillers();
            }
        }
        {
            union()
            {
                xac_baseplateBoltCutouts();
                xac_bearingReliefCutouts();
            }
        }
    }
}

module xac_bearingReliefCutouts()
{
    union()
    {
        translate( [-1 * (xac_bearingShaftLength/2) - 1, -1 * (xAxisDistanceBetweenRods/2) - 4, 18.6] )
        {
            cube( [xac_bearingShaftLength + 2, 8, 7] );
        }

        translate( [-1 * (xac_bearingShaftLength/2) - 1, (xAxisDistanceBetweenRods/2) - 4, 18.6] )
        {
            cube( [xac_bearingShaftLength + 2, 8, 7] );
        }
    }
}

module xac_baseplateBoltCutouts()
{
    translate( [-13, 8, -5] )
    { 
        m3ThroughHole();
        translate( [0, 0, 8.5] ) m3Nut( height = 2.8 );
    }


    translate( [13, 8, -5] )
    {
        m3ThroughHole();
        translate( [0, 0, 8.5] ) m3Nut( height = 2.8 );
    }

    translate( [-13, -8, -5] )
    {
        m3ThroughHole();
        translate( [0, 0, 8.5] ) m3Nut( height = 2.8 );
    }

    translate( [13, -8, -5] )
    {
        m3ThroughHole();
        translate( [0, 0, 8.5] ) m3Nut( height = 2.8 );
    }
}



module xac_shaftSpaceFillers()
{
    translate( [-1 * (xac_bearingShaftLength/2), ((xAxisDistanceBetweenRods + xac_shellDiameter)/2) - 3, xac_baseThickness] ) cube( [xac_bearingShaftLength, 3, 7.5] );
    translate( [-1 * (xac_bearingShaftLength/2), 11.55, xac_baseThickness] ) cube( [xac_bearingShaftLength, 3, 7.5] );

    translate( [-1 * (xac_bearingShaftLength/2), -1 * ((xAxisDistanceBetweenRods + xac_shellDiameter)/2), xac_baseThickness] ) cube( [xac_bearingShaftLength, 3, 7.5] );
    translate( [-1 * (xac_bearingShaftLength/2), -14.55, xac_baseThickness] ) cube( [xac_bearingShaftLength, 3, 7.5] );
}

module xac_beltRetainers()
{
    hull()
    {
        {
            translate( [-9, -0.5, 0] ) cylinder( d = 6, h = 17.7 );
        }
        {
            translate( [-9, -0.5, 0] ) cylinder( d = 8, h = 16.7 );
        }
    }

    hull()
    {
        {
            translate( [9, -0.5, 0] ) cylinder( d = 6, h = 17.7 );
        }
        {
            translate( [9, -0.5, 0] ) cylinder( d = 8, h = 16.7 );
        }
    }

   translate( [0, 0.2, 0] )
    {
        hull()
        {
            {
                translate( [-24, 6.2, 0] ) cube( [8, 8.5, 16.8] );
            }
            {
                translate( [-24, 4.7, 0] ) cube( [6.5, 8.5, 15.2] );
            }
        }

        hull()
        {
            {
                translate( [16, 6.2, 0] ) cube( [8, 8.5, 16.8] );
            }
            {
                translate( [17.5, 4.7, 0] ) cube( [6.5, 8.5, 15.2] );
            }
        }
    }

    hull()
    {
        {
            translate( [-24, -3.5, 0] ) cube( [8, 4.7, 16.8] );
        }
        {
            union()
            {
                translate( [-24, -2, 0] ) cube( [6.5, 4.7, 15.2] );
                translate( [-22.5, -5.5, 0] ) cube( [5, 4.7, 16.8] );
            }
        }
    }

    hull()
    {
        {
            translate( [16, -3.5, 0] ) cube( [8, 4.7, 16.8] );
        }
        {
            union()
            {
                translate( [17.5, -2, 0] ) cube( [6.5, 4.7, 15.2] );
                translate( [17.5, -5.5, 0] ) cube( [5, 4.7, 16.8] );
            }
        }
    }
    


    
    
}

module xac_baseplate()
{
    translate( [-1 * (xac_bearingShaftLength/2), -1 * ((xAxisDistanceBetweenRods + xac_shellDiameter)/2), 0] )
    {
        cube( [xac_bearingShaftLength, xAxisDistanceBetweenRods + xac_shellDiameter, xac_baseThickness] );
    }
}

module xac_retainerShafts()
{
    translate( [-29, -22.5, 13.6] )
    {
        rotate( [0, 90, 0] )
        {
            difference()
            {
                {
                    translate( [0, 0, 1] ) cylinder( d = xac_shellDiameter, h = xac_bearingShaftLength );
                }
                {
                    xac_bearingCutout();
                }
            }
        }

        translate( [0, xAxisDistanceBetweenRods, 0] )
        {
            rotate( [0, 90, 0] )
            {
                difference()
                {
                    {
                        translate( [0, 0, 1] ) cylinder( d = xac_shellDiameter, h = xac_bearingShaftLength );
                    }
                    {
                        xac_bearingCutout();
                    }
                }
            }
        }
    }
}

module xac_bearingCutout()
{
    union()
    {
        translate( [0, 0, bearingZoffset - 1] ) xac_bearingCutoutPieces();
        translate( [0, 0, baseYDimension - 1] ) xac_bearingCutoutPieces();
    }
}

module xac_neck( orientForPrinting = false, buryNutTraps = false )
{
    difference()
    {
        {
            union()
            {
                // inside neck part
                cube( [xac_neckWidth, xac_neckDistanceFromBody - (xac_neckClampWidth/2), xac_neckHeight] );
                // Connector pieces
                // arms
                translate( [-1 * xac_neckConnectorXDimension, xac_neckDistanceFromBody - xac_neckConnectorYDimension - (xac_neckClampWidth/2), 0] ) cube( [xac_neckConnectorXDimension, xac_neckConnectorYDimension, xac_neckConnectorZDimension] );
                translate( [xac_neckWidth, xac_neckDistanceFromBody - xac_neckConnectorYDimension - (xac_neckClampWidth/2), 0] ) cube( [xac_neckConnectorXDimension, xac_neckConnectorYDimension, xac_neckConnectorZDimension] );
                // ess curves
                translate( [-1 * (xac_cornerDiameter/2), xac_neckDistanceFromBody - xac_neckConnectorYDimension - (xac_neckClampWidth/2) - (xac_cornerDiameter/2), 0] ) rotate( [0, 0, 180] ) essCurve( d = xac_cornerDiameter, h = xac_neckHeight );
                translate( [xac_neckWidth + (xac_cornerDiameter/2), xac_neckDistanceFromBody - xac_neckConnectorYDimension - (xac_neckClampWidth/2) - (xac_cornerDiameter/2), 0] ) rotate( [0, 0, 270] ) essCurve( d = xac_cornerDiameter, h = xac_neckHeight );
                // endcaps
                translate( [-1 * xac_neckConnectorXDimension, xac_neckDistanceFromBody - (xac_neckClampWidth/2) - (xac_neckConnectorYDimension/2), 0] ) cylinder( d = xac_neckConnectorYDimension, h = xac_neckConnectorZDimension );
                translate( [xac_neckWidth + xac_neckConnectorXDimension, xac_neckDistanceFromBody - (xac_neckClampWidth/2) - (xac_neckConnectorYDimension/2), 0] ) cylinder( d = xac_neckConnectorYDimension, h = xac_neckConnectorZDimension );

                // End of neck
                if( orientForPrinting == false )
                {
                    translate( [0, xac_neckDistanceFromBody + ((xac_neckClampWidth/2)), 0] )
                    {
                        xac_endOfNeck();
                    }
                }
                else
                {
                    translate( [0, xac_neckHeight, 25.5] ) rotate( [90, 0, 0] ) xac_endOfNeck();
                }

				// Add built-in supports to improve print time and quality
				// comment the translate line to make the built-in support removable
				translate( [(xac_neckWidth/2),0, 6] ) rotate( [90, 0, 0] ) 
				{
					translate( [0.06, 0, -2] )
					{
						translate( [15.88, 4, -13.4] ) supportPillar();
						translate( [-16, -4, -13.4] ) rotate( [0, 0, 180] ) supportPillar();
					}
				}
            }
        }
        {
            // if( orientForPrinting == false )
            // {
                union()
                {
                    translate( [(xac_neckWidth/2), xac_neckDistanceFromBody, -1] )
                    {
                        cylinder( d = xac_neckOpeningDiameter, h = xac_neckHeight + 2 );
                    }

                	translate( [-1 * (xac_neckConnectorXDimension/2) - 1, xac_neckDistanceFromBody + 10, (xac_neckHeight/2)] )
                    {
                        rotate( [90, 0, 0] )
                        {
                            translate( [0, 0, 5] ) m3ThroughHole( height = 20 );
							if( !buryNutTraps )
							{
								translate( [0, 0, 10.1] ) m3Nut();
							}
							else
							{
								translate( [0, 0, 15.8 - 2.5] ) buriedM3Nut( diameter = 6.9, height = 2.6 );
							}
                            
                        }
                    }
                    translate( [xac_neckWidth + (xac_neckConnectorXDimension/2) + 1, xac_neckDistanceFromBody + 10, (xac_neckHeight/2)] )
                    {
                        rotate( [90, 0, 0] )
                        {
                            translate( [0, 0, 5] ) m3ThroughHole( height = 20 );
							if( !buryNutTraps )
							{
								translate( [0, 0, 10.1] ) m3Nut();
							}
							else
							{
								translate( [0, 0, 15.8 - 2.5] ) buriedM3Nut( diameter = 6.9, height = 2.6 );
							}
                        }
                    }

                    //translate( [xac_neckWidth - (xac_neckConnectorXDimension/1) + 0.5, xac_neckHeight + (xac_neckCoutoutDiameter/2) + 1.5, (-1 * xac_neckHeight) + xac_cornerDiameter - xac_neckCoutoutHeight] )
                    translate( [(xac_neckCoutoutDiameter/2) - 1, xac_neckHeight + (xac_neckCoutoutDiameter/2) + 1, xac_neckCoutoutHeight] )
                    {
                        cylinder( d = xac_neckCoutoutDiameter, h = 20 );
                    }

// xac_neckCoutoutHeight = 5.8;
// xac_neckCoutoutDiameter = 17;
                }
            // }
            if( orientForPrinting == true )
            {
                translate( [0, xac_neckHeight, -0.5] ) 
                rotate( [90, 0, 0] ) 
                union()
                {
                    translate( [(xac_neckWidth/2), xac_neckDistanceFromBody + 10 - 6, -1] )
                    {
                        cylinder( d = xac_neckOpeningDiameter, h = xac_neckHeight + 2 );
                    }

                    translate( [-1 * (xac_neckConnectorXDimension/2) - 1, xac_neckDistanceFromBody + 10, (xac_neckHeight/2)] )
                    {
                        rotate( [90, 0, 0] )
                        {
                            translate( [0, 0, -10] ) m3ThroughHole( height = 20 );
                            translate( [0, 0, 16] ) m3Nut();
                        }
                    }
                    translate( [xac_neckWidth + (xac_neckConnectorXDimension/2) + 1, xac_neckDistanceFromBody + 10, (xac_neckHeight/2)] )
                    {
                        rotate( [90, 0, 0] )
                        {
                            translate( [0, 0, -10] ) m3ThroughHole( height = 20 );
                            translate( [0, 0, 16] ) m3Nut();
                        }

                        translate( [-1 * ((xac_neckWidth + xac_neckConnectorXDimension)/2) - 1, -6, -26 + xac_neckCoutoutHeight] )
                        {
                            cylinder( d = xac_neckCoutoutDiameter, h = 20 );
                        }
                    }
                }
            }

        }

    }
}

module xac_endOfNeck()
{
    hull()
    {
        {
            cube( [xac_neckWidth, 9 - (xac_cornerDiameter/2), xac_neckHeight] );
        }
        {
            union()
            {
                translate( [(xac_cornerDiameter/2), 12 - (xac_cornerDiameter/2), 0] ) cylinder( d = xac_cornerDiameter, h = xac_neckHeight );
                translate( [xac_neckWidth - (xac_cornerDiameter/2), 12 - (xac_cornerDiameter/2), 0] ) cylinder( d = xac_cornerDiameter, h = xac_neckHeight );
            }
        }
    }

    // Connector pieces
    // arms
    translate( [-1 * xac_neckConnectorXDimension, 0, 0] ) cube( [xac_neckConnectorXDimension, xac_neckConnectorYDimension, xac_neckConnectorZDimension] );
    translate( [xac_neckWidth, 0, 0] ) cube( [xac_neckConnectorXDimension, xac_neckConnectorYDimension, xac_neckConnectorZDimension] );
    // ess curves
    translate( [-1 * (xac_cornerDiameter/2), (xac_cornerDiameter/2) + xac_neckConnectorYDimension, 0] ) rotate( [0, 0, 90] ) essCurve( d = xac_cornerDiameter, h = xac_neckHeight );
    translate( [xac_neckWidth + (xac_cornerDiameter/2), (xac_cornerDiameter/2) + xac_neckConnectorYDimension, 0] ) rotate( [0, 0, 0] ) essCurve( d = xac_cornerDiameter, h = xac_neckHeight );
    // endcaps
    translate( [-1 * xac_neckConnectorXDimension, (xac_neckConnectorYDimension/2), 0] ) cylinder( d = xac_neckConnectorYDimension, h = xac_neckConnectorZDimension );
    translate( [xac_neckWidth + xac_neckConnectorXDimension, (xac_neckConnectorYDimension/2), 0] ) cylinder( d = xac_neckConnectorYDimension, h = xac_neckConnectorZDimension );
}

// copied from "Y carriage bearing retainer.scad" Copied instead of 'included' to guarantee centering
module xac_bearingCutoutPieces()
{
    // thinner inner cylinder to create the face of the retainer ring
    cylinder( d = bearingOuterDiameter - (trapRingDepth * 2), h = baseYDimension + 2 );

    // main bearing retainer area
    translate( [0, 0, (baseYDimension/2) - (distanceBetweenTrapRings/2) + 1] )
    {
        cylinder( d = bearingOuterDiameter, h = distanceBetweenTrapRings );
    }

    cylinder( d = bearingOuterDiameter, h = cutoutDistanceToEnd );

    translate( [0, 0, baseYDimension - cutoutDistanceToEnd + 2] )
    {
        cylinder( d = bearingOuterDiameter, h = cutoutDistanceToEnd );
    }
}




