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
xac_neckHeight = 5.8;
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
constructedXAxisCarriage();
// constructedHotendMount();

module constructedHotendMount()
{
    union()
    {
        translate( [-1 * (xac_neckWidth/2), 0, 0] ) rotate( [-90, 0, 0] ) xac_neck( orientForPrinting = true );

        translate( [-16, -11.5, -1 * xac_neckPlateThickness] )
        {
            xac_neckBaseplate();

            translate( [(xac_neckWidth/2) + 1, 11.5 - (xac_cornerDiameter/2), -1 * (xac_cornerDiameter/2)] ) rotate( [270, 0, -90] ) essCurve( d = xac_cornerDiameter, h = xac_neckWidth );
            translate( [ xac_neckWidth * 1.5 + 1, 11.5  + (xac_cornerDiameter/2) + xac_neckHeight, -1 * (xac_cornerDiameter/2)] ) rotate( [270, 0, 90] ) essCurve( d = xac_cornerDiameter, h = xac_neckWidth );
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

module xac_neck( orientForPrinting = false )
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
                    translate( [0, xac_neckHeight, 21.5] ) rotate( [90, 0, 0] ) xac_endOfNeck();
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
                            m3ThroughHole( height = 20 );
                            translate( [0, 0, 16] ) m3Nut();
                        }
                    }
                    translate( [xac_neckWidth + (xac_neckConnectorXDimension/2) + 1, xac_neckDistanceFromBody + 10, (xac_neckHeight/2)] )
                    {
                        rotate( [90, 0, 0] )
                        {
                            m3ThroughHole( height = 20 );
                            translate( [0, 0, 16] ) m3Nut();
                        }
                    }
                }
            // }
            if( orientForPrinting == true )
            {
                translate( [0, xac_neckHeight, -0.5] ) 
                rotate( [90, 0, 0] ) 
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
                            m3ThroughHole( height = 20 );
                            translate( [0, 0, 16] ) m3Nut();
                        }
                    }
                    translate( [xac_neckWidth + (xac_neckConnectorXDimension/2) + 1, xac_neckDistanceFromBody + 10, (xac_neckHeight/2)] )
                    {
                        rotate( [90, 0, 0] )
                        {
                            m3ThroughHole( height = 20 );
                            translate( [0, 0, 16] ) m3Nut();
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




