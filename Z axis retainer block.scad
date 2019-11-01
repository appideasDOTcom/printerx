include <thirdparty/MCAD/bearing.scad>

// Modifications to Prusa's parts require the modifications I've made to the original models, which are in a public 
//    github fork here: https://github.com/appideasDOTcom/Original-Prusa-i3
// include <thirdparty/prusa/Original-Prusa-i3/Printed-Parts/scad/x-end-idler.scad>
// include <thirdparty/prusa/Original-Prusa-i3/Printed-Parts/scad/x-end-motor.scad>

/* Render quality variables */
$fa = 1;
$fs = 0.1;
/* END Render quality variables */

/* Global variables */
bearingHeight = 7;
/* END Global variables */

/* Lead screw retainer variables */
leadScrewPostDiameter = 8;
leadScrewPostZOffset = 1;
leadScrewPostHeight = (bearingHeight - leadScrewPostZOffset);

leadScrewCapLowerDiamter = 10.5;
leadScrewCapUpperDiamter = 13.5;
leadScrewCapHeight = 10;

leadScrewCutoutDepth = 8;
leadScrewCutoutDiameter = 8.4;

supportGap = 0.1;
/* END Lead screw retainer variables */

/* Bearing retainer variables */
bearingOuterDiameter = 22.0; // Don't squeeze this bearing
bearingRetainerHeight = bearingHeight;
bearingReliefDiameter = 15;
bearingReliefInset = 1;
/* END Bearing retainer variables */

// Bearing spacer (flange) parameters
// Bearing flange superceded the (now obsolete) lead screw retainer
bearingSpacerPostDiameter = 8.2;
bearingSpacerPostZOffset = 1;
bearingSpacerPostHeight = (bearingHeight - bearingSpacerPostZOffset);

bearingSpacerBufferDiameter = 10.5;
bearingSpacerBufferHeight = 2;

bearingSpacerPlatformDiameter = 13;
bearingSpacerPlatformHeight = 0;

/* Linear rod retainer variables */
linearRodCutoutDiameter = 8.0; // It would be OK to squeeze this one a little as long as the plastic isn't compromised
// To make it so that we can use pre-cut 362mm linear motion rods with pre-cut 350mm lead screws, sink
//   the linear rod 6mm deeper on each side
linearRodCutoutDepth = bearingHeight;
linearRodCutoutAdjustedDepth = linearRodCutoutDepth + 6;
/* END Linear rod retainer variables */

pieceHeight = 30 + bearingHeight + bearingSpacerBufferHeight + bearingSpacerPlatformHeight; // 28 puts the bottom of the bearing cutout exactly at the rail
railWidth = 20;

wallThickness = 10;
wallHeight = 24;

distanceBetweenRetainers = 17;
distanceFromTower = 45;
distanceFromInside = (-1 * (railWidth/2)) + 0; // pull it to the center of the rail, then offset
rightSideDistanceFromInside = (-1 * (railWidth/2)) - 30;

cornerDiameter = 4;

pieceWidth = distanceFromInside + railWidth + (bearingOuterDiameter/2) + distanceBetweenRetainers + (linearRodCutoutDiameter/2) - 4;
pieceDepth = distanceFromTower + (bearingOuterDiameter/2) + 14;

insideWallDepth = 5;
insideThroughHoleOffset = 12;
topThroughHoleOffset = 7;

supportWallDistance = 8;
supportCubeDimension = 6;

bottomToCut = 1;

vertRailLength = 330;
horizRailLength = 300;

bottomRailLength = 90.3;

topPieceHeight = 19;
topWallWidth = 18.2;

zIdlerSpacerInnerDiameter = 5.6;
zIdlerSpacerOuterDiameter = 10;
zIdlerSpacerHeight = 2;


// Build things

// Model of a 608 bearing for fit
// #bearing( model= "SkateBearing" );

/* Constructed components */

// leadScrewBearingAdapter(); // obsolete
// zAxisIdlerPulleySpacer(); // obsolete

// These are probably the things you will want to print
bearingFlange();
// bottomLeftBase();
// bottomRightBase();
// topLeftBase();
// topRightBase();

// constructedUnit();

// These are helpers, and not necessarily useful as stand-alone prints
// retainerCutouts();
// rails();
// bearingUnit();

// Tests & support
// xIdlerTest();
// xMotorTest();

// x_end_idler();
// x_end_motor();

// Below here is module code

module constructedUnit()
{
    translate( [-1 * pieceDepth - 0.1, -1 * railWidth - 0.1, -0.1] )
    {
        %rails();
    }

    color( "blue" ) bottomLeftBase();

    translate( [0, -1 * horizRailLength - (railWidth * 2), 0] )
    {
        color( "blue" ) bottomRightBase();
    }

    translate( [0, 0, vertRailLength + railWidth] )
    {
        color( "blue" ) topLeftBase();
    }

    translate( [0, -1 * (horizRailLength + (railWidth * 2)), vertRailLength + railWidth] )
    {
        color( "blue" ) topRightBase();
    }

}

module topLeftBase()
{
    topToCut = railWidth - 0.9;

    union()
    {
        {
            translate( [0, 0, topToCut] )
            {
                difference()
                {
                    {
                        translate( [0, 0, bottomToCut] )
                        {
                            rotate( [180, 0, 0] )
                            {
                                bottomRightBase( 0 );
                            }
                        }
                    }
                    {
                        translate( [-79, -50, -1 * topToCut] )
                        {
                            cube( [80, 80, topToCut + 0.1] );
                        }
                    }
                }
            }
        }
        {
            difference()
            {
                {
                    translate( [0, 0, 0] )
                    {
                        topSideBracketConnector();
                    }
                }
                {
                    translate( [-10, -3, 0] )
                    {
                        cube( [35, 26, 1] );
                    }
                }
            }


        }
    }
}

module topRightBase()
{
    mirror( [0, 1, 0] )
    {
        topLeftBase();
    }
}

module topSideBracketConnector()
{
    hullOffset = 22.0 - bearingOuterDiameter;
    difference()
    {
        {
            hull()
            {
                {
                    translate( [(cornerDiameter/2), (cornerDiameter/2), -1 * (topPieceHeight + wallHeight) + 0.1] )
                    {
                        cube( [railWidth - cornerDiameter, topWallWidth - cornerDiameter, topPieceHeight + wallHeight] );
                    }
                }
                {
                    union()
                    {
                        translate( [railWidth - (cornerDiameter/2), railWidth - cornerDiameter + hullOffset, -1 * (topPieceHeight + wallHeight) + 0.1] )
                        {
                            cylinder( d= cornerDiameter, h = topPieceHeight + wallHeight );
                        }

                        translate( [railWidth - (cornerDiameter), 0, -1 * (topPieceHeight + wallHeight) + 0.1] )
                        {
                            cube( [cornerDiameter, cornerDiameter, topPieceHeight + wallHeight] );
                        }

                        translate( [-1 * (cornerDiameter * 2) + 2, cornerDiameter/2, -1 * (topPieceHeight + wallHeight) + 0.1] )
                        {
                            cylinder( d= cornerDiameter, h = topPieceHeight + wallHeight );
                        }

                        translate( [-1 * (cornerDiameter * 2) + 6, railWidth - (cornerDiameter) + hullOffset, -1 * (topPieceHeight + wallHeight) + 0.1] )
                        {
                            cylinder( d= cornerDiameter, h = topPieceHeight + wallHeight );
                        }
                    }
                }
            }
        }
        {
            union()
            {
                translate( [(railWidth/2), railWidth - 0.1, -1 * topThroughHoleOffset] )
                {
                    rotate( [90, 0, 0] )
                    {
                        m5TroughHole( h = railWidth );
                        translate( [0, 0, -3.1] )
                        {
                            m5HeadCutout();
                        }
                    }
                }

                translate( [(railWidth/2), railWidth - 0.1, -1 * (topPieceHeight + wallHeight - topThroughHoleOffset)] )
                {
                    rotate( [90, 0, 0] )
                    {
                        m5TroughHole( h = railWidth );
                        translate( [0, 0, -3.1] )
                        {
                            m5HeadCutout();
                        }
                    }
                }
            }
        }
    }
}


module bottomRightBase(  includeEndHoles = 1  )
{
    mirror( [0, 1, 0] )
    {
        bottomLeftBase( includeEndHoles );
    }
}

module bearingUnit()
{
    bearing( model= "SkateBearing" );
    bearingFlange();

    translate( [0, 0, (bearingHeight + bearingSpacerBufferHeight + bearingSpacerPlatformHeight)] )
    {
        bearing( model= "SkateBearing" );
    }

}

module rails()
{
    railCutout( height = bottomRailLength );

    translate( [bottomRailLength - railWidth - 0.2, 0, vertRailLength + railWidth] )
    {
        rotate( [0, 90, 0] )
        {
            railCutout( height = vertRailLength );
        }
    }

    translate( [bottomRailLength - railWidth - 0.2, 0.1, vertRailLength - 0.2] )
    {
        rotate( [0, 0, -90] )
        {
            railCutout( height = horizRailLength );
        }
    }

    translate( [bottomRailLength - railWidth - 0.2, -1 * (horizRailLength + railWidth), vertRailLength + railWidth] )
    {
        rotate( [0, 90, 0] )
        {
            railCutout( height = vertRailLength );
        }
    }

    translate( [0, -1 * (horizRailLength + railWidth), 0] )
    {
        railCutout( height = bottomRailLength );
    }
}


module bottomLeftBase( includeEndHoles = 1 )
{
    difference()
    {
        {
            base();
        }
        {
            union()
            {
                translate( [-1 * distanceFromTower, distanceFromInside, pieceHeight - linearRodCutoutDepth - bearingHeight - bearingSpacerBufferHeight - bearingSpacerPlatformHeight] )
                {
                    retainerCutouts();
                }
                translate( [-1 * pieceDepth, -1 * railWidth - 0.1, -0.1] )
                {
                    rails();
                }
                baseThroughHoles( includeEndHoles );

                translate( [-80, -50, -10 + bottomToCut] )
                {
                    cube( [100, 100, 10] );
                }

                if( includeEndHoles == 1 )
                {
                    cutoutHeight = (bearingHeight * 2) + bearingSpacerBufferHeight + bearingSpacerPlatformHeight;
                    cutoutAmount = 0.6; // Cut a few layers out of the circle when printed on edge to force a small bridge on the top and to make the requisite <layer height> flats be outside of the zero-tolerance shapes 

                    translate( [-1 * distanceFromTower - (bearingOuterDiameter/2) - cutoutAmount, -1 * (bearingOuterDiameter/2) - 2.5, pieceHeight - cutoutHeight] )
                    {
                        cube( [5, bearingOuterDiameter/3, cutoutHeight + 0.1] );
                        translate( [bearingOuterDiameter - 4.4 + cutoutAmount, 0, 0] )
                        {
                            cube( [5, bearingOuterDiameter/3, cutoutHeight + 0.1] );
                        }
                    }

                    smallCutoutAmount = 0.4;

                    translate( [-1 * distanceFromTower - (linearRodCutoutDiameter/2) - smallCutoutAmount, -1 * (bearingOuterDiameter/2) + distanceBetweenRetainers - 0.2, pieceHeight - linearRodCutoutAdjustedDepth] )
                    {
                        cube( [2, linearRodCutoutDiameter/3, linearRodCutoutAdjustedDepth + 0.1] );

                        translate( [linearRodCutoutDiameter - 1.6 + smallCutoutAmount, 0, 0] )
                        {
                            cube( [2, linearRodCutoutDiameter/3, linearRodCutoutAdjustedDepth + 0.1] );
                        }
                    }
                }
            }
        }
    }
}


module baseThroughHoles( includeEndHoles = 1 )
{
    translate( [0.1, -1 * railWidth/2, pieceHeight + wallHeight - 6] )
    {
        rotate( [0, -90, 0] )
        {
            m5TroughHole();

            translate( [0, 0, 4] )
            {
                m5HeadCutout();
            }
        }
    }

    translate( [-1 * insideThroughHoleOffset, -1 * (railWidth + insideWallDepth - 1), (railWidth/2)] )
    {

        rotate( [90, 0, 0] )
        {
            m5HeadCutout();
        }
    }
    

    translate( [-1 * insideThroughHoleOffset, -1 * (railWidth - 0.1), (railWidth/2)])
    {
        rotate( [90, 0, 0] )
        {
            m5TroughHole();
        }
    }

    translate( [-1 * (pieceDepth - insideThroughHoleOffset), -1 * (railWidth + insideWallDepth - 1), (railWidth/2)] )
    {

        rotate( [90, 0, 0] )
        {
            m5HeadCutout();
        }
    }

    translate( [-1 * (pieceDepth - insideThroughHoleOffset), -1 * (railWidth - 0.1), (railWidth/2)])
    {
        rotate( [90, 0, 0] )
        {
            m5TroughHole();
        }
    }

    if( includeEndHoles == 1 )
    {
        translate( [-1 * (pieceDepth) + topThroughHoleOffset, -1 * (railWidth/2), railWidth - 0.1])
        {
            rotate( [0, 0, 0] )
            {
                m5TroughHole();
            }

            translate( [0, 0, 4] )
            {
                m5HeadCutout();
            }
        }
    }
}


module base()
{
    hull()
    {
        {
            translate( [-1 * (pieceDepth - (cornerDiameter/2)), -1 * railWidth + (cornerDiameter/2), 0] )
            {
                cube( [pieceDepth - cornerDiameter, pieceWidth - cornerDiameter, pieceHeight] );
                
            }
        }
        {
            translate( [-1 * (cornerDiameter/2), pieceWidth - railWidth - (cornerDiameter/2), 0])
            {
                cylinder( d = cornerDiameter, h = pieceHeight);
            }

            translate( [-1 * (pieceDepth - cornerDiameter/2), pieceWidth - railWidth - (cornerDiameter/2), 0])
            {
                cylinder( d = cornerDiameter, h = pieceHeight);
            }

            // Use the commented hull to stop at the rail
            // translate( [-1 * cornerDiameter, -1 * railWidth, 0] )
            // {
            //     cube( [cornerDiameter, cornerDiameter, pieceHeight] );
            // }

            // translate( [-1 * pieceDepth, -1 * railWidth, 0] )
            // {
            //     cube( [cornerDiameter, cornerDiameter, pieceHeight] );
            // }

            translate( [(-1 * pieceDepth) + (cornerDiameter/2), (-1 * (railWidth + insideWallDepth)) + (cornerDiameter/2), 0] )
            {
                cylinder( d = cornerDiameter, h = pieceHeight ); 
            }

            translate( [ -1 * (cornerDiameter/2), (-1 * (railWidth + insideWallDepth)) + (cornerDiameter/2), 0] )
            {
                cylinder( d = cornerDiameter, h = pieceHeight ); 
            }

        }
    }


    supportWallEssCurves();



    translate( [-1 * wallThickness, -1 * railWidth, pieceHeight] )
    {
        supportWall();
    }
    
}

module supportWallEssCurves()
{
    difference()
    {
        {
            union()
            {
                translate( [-1 * (supportWallDistance + (cornerDiameter * 1.5) + supportCubeDimension), -1 * railWidth, (cornerDiameter/2) + pieceHeight] )
                {
                    rotate( [90, 0, 180] )
                    {
                        essCurve( d = cornerDiameter, h = railWidth );
                    }
                }

                translate( [0, -1 * railWidth - (cornerDiameter/2), (cornerDiameter/2) + pieceHeight] )
                {
                    rotate( [90, 0, 270] )
                    {
                        essCurve( d = cornerDiameter, h = (supportWallDistance + supportCubeDimension + (cornerDiameter * 1.5)) );
                    }
                }

                translate( [-1 * railWidth, (cornerDiameter/2), (cornerDiameter/2) + pieceHeight] )
                {
                    rotate( [90, 0, 90] )
                    {
                        essCurve( d = cornerDiameter, h = (supportWallDistance + supportCubeDimension + (cornerDiameter * 1.5)) );
                    }
                }
            }
        }
        {
            translate( [-1 * (supportWallDistance + (cornerDiameter * 1.5) + supportCubeDimension), 10, pieceHeight + (cornerDiameter/2)] )
            {
                rotate( [90, 0, 0] )
                {
                    cylinder( d = cornerDiameter, h = 50 );
                }
            }
        }
    }
}

module supportWall()
{
    hull()
    {
        {
            cube( [wallThickness, railWidth, wallHeight] );
        }
        {
            union()
            {
                translate( [-1 * supportWallDistance, 0, 0] )
                {
                    cube( [supportCubeDimension, supportCubeDimension, supportCubeDimension] );

                    translate( [0, railWidth - supportCubeDimension, 0] )
                    {
                        cube( [supportCubeDimension, supportCubeDimension, supportCubeDimension] );
                    }
                }
            }
        }
    }

}

module retainerCutouts()
{
    bearingRetainerCutout();
    translate( [0, distanceBetweenRetainers, (bearingHeight + bearingSpacerBufferHeight + bearingSpacerPlatformHeight)] )
    {
        linearRodCutout();
    }
}

module railCutout( height = (pieceDepth + 0.2)  )
{
    cube( [height, railWidth + 0.2, (railWidth + 0.2)] );
}

module linearRodCutout()
{
    // linearRodCutoutAdjustedDepth
    // linearRodCutoutDepth
    zAdjust = -1 * (linearRodCutoutAdjustedDepth - linearRodCutoutDepth);
    translate( [0, 0, zAdjust] )
    {
        cylinder( d=linearRodCutoutDiameter, h=linearRodCutoutAdjustedDepth + 0.1 );
    }
}

module bearingRetainerCutout()
{
    union()
    {
        cylinder( d=bearingOuterDiameter, h=((bearingRetainerHeight * 2) + bearingSpacerBufferHeight + bearingSpacerPlatformHeight + 0.1) );
        translate( [0, 0, -1 * bearingReliefInset] )
        {
            cylinder( d=bearingReliefDiameter, h=(bearingRetainerHeight + bearingReliefInset + 0.1) );
        }
    }
}

module bearingFlange()
{
    flangeEndShapeHeight = 1.6;

    difference()
    {
        {
            union()
            {
                hull()
                {
                    {
                        translate( [0, 0, bearingSpacerPostZOffset + flangeEndShapeHeight] )
                        {
                            cylinder( d = bearingSpacerPostDiameter, h = bearingSpacerPostHeight - flangeEndShapeHeight );
                        }
                    }
                    {
                        translate( [0, 0, bearingSpacerPostZOffset + (bearingSpacerPostDiameter/2) ] )
                        {
                            sphere( d = bearingSpacerPostDiameter );
                        }
                    }
                }


                translate( [0, 0, bearingHeight] )
                {
                    cylinder( d = bearingSpacerBufferDiameter, h = bearingSpacerBufferHeight );
                }

                translate( [0, 0, bearingHeight + bearingSpacerBufferHeight] )
                {
                    cylinder( d = bearingSpacerPlatformDiameter, h = bearingSpacerPlatformHeight );
                }
            }
        }
        {

            translate( [-5, -5, (bearingHeight + bearingSpacerBufferHeight)] )
            {
                cube( [10, 10, 5] );
            }

        }
    }


}

module zAxisIdlerPulleySpacer()
{
    difference()
    {
        {
            cylinder( d = zIdlerSpacerOuterDiameter, h = zIdlerSpacerHeight );
        }
        {
            translate( [0, 0, -0.1] )
            {
                cylinder( d = zIdlerSpacerInnerDiameter, h = zIdlerSpacerHeight + 0.2 );
            }
        }
    }
}


// obsolete
module leadScrewBearingAdapter()
{
    difference()
    {
        {
            union()
            {
                {
                    translate( [0, 0, leadScrewPostZOffset] )
                    {
                        cylinder( d = leadScrewPostDiameter, h = leadScrewPostHeight );
                    }
                }
                {
                    translate( [0, 0, bearingHeight] )
                    {
                        cylinder( d1 = leadScrewCapLowerDiamter, d2 = leadScrewCapUpperDiamter, h = leadScrewCapHeight );
                    }
                }
            }
        }
        {
            union()
            {
                {
                    translate( [0, 0, bearingHeight + leadScrewCapHeight - leadScrewCutoutDepth] )
                    {
                        cylinder( d = leadScrewCutoutDiameter, h = leadScrewCutoutDepth + 0.1 );
                    }
                }
                {
                    translate( [0, 0, bearingHeight + leadScrewCapHeight - leadScrewCutoutDepth - 2] )
                    {
                        cylinder( d1=1, d2=leadScrewCutoutDiameter, h=2 );
                    }
                }
            }
        }
    }
}

module m5TroughHole( h = 10 )
{
    m5ThroughHoleDiameter = 5.6; // no press-fit for a bolt!
    cylinder( d=m5ThroughHoleDiameter, h=h );
}

module m5HeadCutout()
{
    m5HeadDiameter = 9; // lots of extra room
    m5HeadHeight = 20;
    cylinder( d=m5HeadDiameter, h=m5HeadHeight );
}

module cutoutPrintSupport()
{
    printSupportThickness = 0.4;
    printSupportWidth = (leadScrewCutoutDiameter - 0.4);
    prinSupportHeight = (leadScrewCutoutDepth - supportGap);
    printSupportAxisOffset = (leadScrewCutoutDiameter/2) - 0.2;

    translate( [-1 * printSupportAxisOffset, -1 * (printSupportThickness/2), 0] )
    {
        cube( [printSupportWidth, printSupportThickness, prinSupportHeight] );
    }

    rotate( [0, 0, 90] )
    {
        translate( [-1 * printSupportAxisOffset, -1 * (printSupportThickness/2), 0] )
        {
            cube( [printSupportWidth, printSupportThickness, prinSupportHeight] );
        }
    }
}

module linearRodCutoutTest()
{
    difference()
    {
        {
            union()
            {
                translate( [-1 * ((linearRodCutoutDiameter + 3)/2), -1 * ((linearRodCutoutDiameter + 3)/2), 0] )
                {
                    cube( [(linearRodCutoutDiameter + 3), (linearRodCutoutDiameter + 3), linearRodCutoutDepth] );
                    translate( [0, 0, -2] )
                    {
                        cube( [(linearRodCutoutDiameter + 3), (linearRodCutoutDiameter + 3), 2] );
                    }
                }
                
            }
        }
        {
            linearRodCutout();
        }
    }

    
}

module bearingRetainerTest()
{
    difference()
    {
        {
            union()
            {
                translate( [-1 * ((bearingOuterDiameter + 3)/2), -1 * ((bearingOuterDiameter + 3)/2), 0] )
                {
                    cube( [(bearingOuterDiameter + 3), (bearingOuterDiameter + 3), bearingRetainerHeight] );
                }
                translate( [-1 * ((bearingOuterDiameter + 3)/2), -1 * ((bearingOuterDiameter + 3)/2), -2] )
                {
                    cube( [(bearingOuterDiameter + 3), (bearingOuterDiameter + 3), 2] );
                }
            }
        }
        {
            bearingRetainerCutout();
        }
    }
}

module xIdlerTest()
{
    difference()
    {
        {
            x_end_idler();
        }
        {
            // translate( [-40, -40, 8] )
            // {
            //     cube([80, 80, 60]);
            // }
        }
    }

}

module xMotorTest()
{
    difference()
    {
        {
            x_end_motor();
        }
        {
            translate( [-40, -40, 8] )
            {
                cube([80, 100, 60]);
            }
        }
    }

}

// Create an "S" shaped curve for model strength on what would otherwise be a corner
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
