// Build the model pieces in context
// This file is for educational purposes only

include <Z axis retainer block.scad>
include <thirdparty/prusa/Original-Prusa-i3/Printed-Parts/scad/x-end-idler.scad>
include <thirdparty/prusa/Original-Prusa-i3/Printed-Parts/scad/x-end-motor.scad>

leadScrewHeight = 306;
linearMotionRodHeight = 306;

xRodLength = 362;

constructedUnit();

// #bearing( model= "SkateBearing" );
// pieceHeight - linearRodCutoutDepth - bearingHeight - bearingSpacerBufferHeight - bearingSpacerPlatformHeight
color( "silver" )
translate( [-1 * distanceFromTower, -1 * (bearingOuterDiameter/2) + 1.1, pieceHeight - ((bearingHeight*2) + bearingSpacerBufferHeight)] )
{
    // Left side
    zBearingsAndRods();

    // Right side
    translate( [0, -1 * (horizRailLength + railWidth), 0] )
    {
        rotate( [0, 0, 180] )
        {
            zBearingsAndRods();
        }
    }
}

color( "green" )
translate( [-1 * distanceFromTower, 7, 250] )
{
    rotate( [0, 180, 0] )
    {
        x_end_motor();
    }

    translate( [0, -1 * (horizRailLength + railWidth * 2) - 14, 0] )
    {
        rotate( [0, 180, 0] )
        {
            x_end_idler();
        }
    }
}

color( "silver" )
translate( [-20, 4.6, 244] )
{
    rotate( [90, 0, 0] )
    {
        cylinder( d = 8, h = xRodLength );

        translate( [0, -45, 0] )
        {
            cylinder( d = 8, h = xRodLength );
        }
    }
}

module zBearingsAndRods()
{
    bearingUnit();

    translate( [0, 0, bearingHeight + bearingSpacerBufferHeight + bearingSpacerPlatformHeight] )
    {
        cylinder( d = 8, h = leadScrewHeight );
    }

    translate( [0, 0, horizRailLength + 8 + ((bearingHeight*2) + bearingSpacerBufferHeight)] )
    {
        rotate( [0, 180, 0] )
        {
            bearingUnit();
        }
    }

    translate( [0, distanceBetweenRetainers, ((bearingHeight*2) + bearingSpacerBufferHeight) - linearRodCutoutDepth] )
    {
        cylinder( d = 8, h = linearMotionRodHeight );
    }
}