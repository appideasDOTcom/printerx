/**
* A mount for adjustable, vibration-damping feet
*/ 

use <Shared-modules.scad>
include <printerx construction.scad>

// Render quality settings
$fa = 5;
$fs = 0.4;

renderFrame = false;

footMountWidth = profileSize;
footMountLength = 30;
footMountHeight = 15;
footMountCutoutHeight = 6;
footMountCutoutDistance = 4;
footMountCornerDiameter = 4;

footMountWingLength = 12;
footMountWingWidth = footMountWidth;
footMountWingHeight = 6.8;

constructedFootMount();
// mountsInContext();

module mountsInContext()
{
    union()
    {
        translate( [0, footMountWingLength, -1 * (footMountHeight - footMountCutoutHeight)] )
        {
            constructedFootMount();
        }

        translate( [0, yAxisProfileLength - footMountLength - footMountWingLength, -1 * (footMountHeight - footMountCutoutHeight)] )
        {
            constructedFootMount();
        }

        translate( [xAxisProfileLength + profileSize, footMountWingLength, -1 * (footMountHeight - footMountCutoutHeight)] )
        {
            constructedFootMount();
        }

        translate( [xAxisProfileLength + profileSize, yAxisProfileLength - footMountLength - footMountWingLength, -1 * (footMountHeight - footMountCutoutHeight)] )
        {
            constructedFootMount();
        }
    }
}

module constructedFootMount()
{
    difference()
    {
        {
            union()
            {
                footMountBase();
                footMountWings();
            }
        }
        {
            union()
            {
                footMountFrameMountCutouts();
                footMountAdjustmentCutout();
            }
        }
    }
}

module footMountAdjustmentCutout()
{
    translate( [(footMountWidth/2), (footMountLength/2), -9.3 + 3.2] )
    {
        m4ThroughHole_duplicate( height = 20 );
        m4Nut_sink();
    }
}

module footMountFrameMountCutouts()
{
    translate( [(profileSize/2), -1 * (footMountWingLength/2), 0] )
    {
        m5ThroughHole( h = 20 );
        translate( [0, 0, 1.9] )
        {
            m5Head( height = 4.1 );
        }
    }

    translate( [(profileSize/2), footMountLength + (footMountWingLength/2), 0] )
    {
        m5ThroughHole( h = 20 );
        translate( [0, 0, 1.9] )
        {
            m5Head( height = 4.1 );
        }
    }
}

module footMountWings()
{
    translate( [ 0, -1 * footMountWingLength, (footMountHeight - footMountCutoutHeight - footMountWingHeight)] )
    {
        cube( [footMountWingWidth, footMountWingLength, footMountWingHeight] );

        translate( [footMountWingWidth, footMountWingLength - (footMountCornerDiameter/2), -1 * (footMountCornerDiameter/2)] )
        {
            rotate( [180, 90, 0] )
            {
                essCurve( d = footMountCornerDiameter, h = footMountWingWidth );
            }
        }

        translate( [0, footMountWingLength + footMountLength + (footMountCornerDiameter/2), -1 * (footMountCornerDiameter/2)] )
        {
            rotate( [0, 90, 0] )
            {
                essCurve( d = footMountCornerDiameter, h = footMountWingWidth );
            }
        }
    }

    translate( [ 0, footMountLength, (footMountHeight - footMountCutoutHeight - footMountWingHeight)] )
    {
        cube( [footMountWingWidth, footMountWingLength, footMountWingHeight] );
    }
}

module footMountBase()
{
    hull()
    {
        {
            cube( [footMountWidth, footMountLength, (footMountHeight - footMountCutoutHeight)] );
        }
        {
            union()
            {
                translate( [0, footMountCutoutDistance + (footMountCornerDiameter/2), -1 * footMountCutoutHeight + (footMountCornerDiameter/2)] )
                {
                    rotate( [0, 90, 0] )
                    {
                        cylinder( d = footMountCornerDiameter, h = footMountWidth );
                    }
                }

                translate( [0, footMountCutoutDistance + footMountWidth, -1 * footMountCutoutHeight + (footMountCornerDiameter/2)] )
                {
                    rotate( [0, 90, 0] )
                    {
                        cylinder( d = footMountCornerDiameter, h = footMountWidth );
                    }
                }
            }
        }
    }
}


if( renderFrame )
{
    %bottomFrame();
}
