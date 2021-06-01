include <thirdparty/prusa/Original-Prusa-i3/Printed-Parts/scad/x-end-idler.scad>
include <thirdparty/prusa/Original-Prusa-i3/Printed-Parts/scad/x-end-motor.scad>
include <Y carriage bearing retainer.scad>
include <Z axis motor mount.scad>

/* Render quality variables */
$fa = 1;
$fs = 0.1;
/* END Render quality variables */

// renderMotorMount();
renderIdlerMount();

module renderMotorMount()
{
    bearingZoffset = (rj4jpLength - baseYDimension) + 5;

    difference()
    {
        {
            x_end_motor();
        }
        {
            // RJ4JP bearing cutouts to replace LM8UU
            union()
            {
                translate( [0, 0, bearingZoffset - 1] ) bearingCutout_xends();
                translate( [0, 0, baseYDimension - 1] ) bearingCutout_xends();
            }
        }
    }
}

module renderIdlerMount()
{
    bearingZoffset = (rj4jpLength - baseYDimension) + 2.5;

    difference()
    {
        {
            union()
            {
                x_end_idler();
                translate( [-9, -10.5, 0] )
                {
                    rotate( [0, 0, 180] )
                    {
                        baseplate();
                        idlerFrontSupport( frontLength = true );
                        translate( [-1 * wallthickness, 0, 0] ) rotate( [0, 0, 90] ) idlerFrontSupport( frontLength = false );
                    } 
                    
                }
            }
        }
        {
            // RJ4JP bearing cutouts to replace LM8UU
           union()
            {
                translate( [0, 0, bearingZoffset + 1.5] ) bearingCutout_xends();
                translate( [0, 0, baseYDimension - 1] ) bearingCutout_xends();
            }
        }
    }
}

// copied from "Y carriage bearing retainer.scad" Copied instead of 'included' to guarantee centering
module bearingCutout_xends()
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
