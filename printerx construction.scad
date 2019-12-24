/**
* Constructed printer models
*/ 

include <Shared-modules.scad>
include <Z axis retainer block.scad>
// include <thirdparty/prusa/Original-Prusa-i3/Printed-Parts/scad/x-end-idler.scad>
// include <thirdparty/prusa/Original-Prusa-i3/Printed-Parts/scad/x-end-motor.scad>
include <2020 SK8 Bracket.scad>
include <Y belt tensioner.scad>
include <Filament guide.scad>
use <Frame foot mount.scad>

yAxisProfileLength = 406;
xAxisProfileLength = 300;
zAxisProfileLength = 50;
profileSize = 20;

zAxisTowerHeight = 374;
zAxisTowerDistanceFromEnd = 50;

zAxisLeadScrewDiameter = 8;
zAxisLeadScrewLength = 350;

zAxisLinearRodDiameter = 8;
zAxisLinearRodLength = 362;

xAxisLinearRodDiameter = 8;
xAxisLinearRodLength = 362;

yAxisLinearRodDiameter = 8;
yAxisLinearRodLength = 406;

xPieceTopOffset = 50;

distanceBetweenSk8Brackets = 170;
sk8SideLength = 14;

sk8SideOffset = (profileSize - sk8SideLength)/2;

// fulConstruction();

module fulConstruction()
{
    union()
    {
        color( "black" ) bottomFrame();
        color( "black" ) topFrame();

        color( "blue" ) zAxisMountPieces();
        color( "silver" ) zAxisRods();
        color( "lightgray" ) zAxisBearings();
        color( "blue" ) zAxisMotorMount();
        color( "blue" ) zAxisFrameBraces();
        color( "blue" ) constructedFilamentGuide();
        color( "blue" ) handle();

        color( "blue" ) mountsInContext();

        color( "blue" ) xAxisCarriagePieces();
        color( "blue" ) constructedXAxisCarriage();
        color( "silver" ) xAxisRods();

        color( "blue" ) yAxisMountPieces();
        color( "silver" ) yAxisRods();
    }
}

module zAxisFrameBraces()
{
    union()
    {
        translate( [0, 25.3 + yAxisProfileLength - zAxisTowerDistanceFromEnd, 75 + zAxisProfileLength + (profileSize * 2)] )
        {
            rotate( [-90, 0, -90] )
            {
                import( "output/z axis frame brace.stl" );
            }
        }

        translate( [xAxisProfileLength + profileSize, 25.3 + yAxisProfileLength - zAxisTowerDistanceFromEnd, 75 + zAxisProfileLength + (profileSize * 2)] )
        {
            rotate( [-90, 0, -90] )
            {
                import( "output/z axis frame brace.stl" );
            }
        }
    }
}


module zAxisMotorMount()
{
    // Using hard-coded numbers from the Z axis motor mount.stl file since importing that file
    //    causes conflicting variable names
    translate( [60 + (xAxisProfileLength/2) - (31/2), yAxisProfileLength + profileSize - zAxisTowerDistanceFromEnd + 2, 10 + zAxisProfileLength + profileSize + zAxisTowerHeight] )
    {
        rotate( [90, 0, -90] )
        {
            import( "output/Z axis motor mount.stl" );
        }
        
    }
}

module handle()
{
    translate( [-7.5 + (xAxisProfileLength/2) - (31/2), yAxisProfileLength + profileSize - zAxisTowerDistanceFromEnd -30, zAxisProfileLength + (profileSize * 2) + zAxisTowerHeight] )
    {
        rotate( [-90, 0, 0] )
        {
            import( "output/V-Slot_Handle.stl" );
        }
    }
}

module constructedFilamentGuide()
{
    translate( [57 + (xAxisProfileLength/2) - (31/2), yAxisProfileLength + profileSize - zAxisTowerDistanceFromEnd + 2, zAxisProfileLength + profileSize + zAxisTowerHeight - 4] )
    {

        translate( [0, 0, 0] )
        {
            rotate( [0, 0, 90] )
            {
                filamentGuide();
            }
        }
    }
}



module topFrame()
{
    translate( [0, yAxisProfileLength - profileSize - zAxisTowerDistanceFromEnd, zAxisProfileLength + (profileSize*2)] )
    {
        frameProfile( "z", zAxisTowerHeight );
    }

    translate( [xAxisProfileLength + profileSize, yAxisProfileLength - profileSize - zAxisTowerDistanceFromEnd, zAxisProfileLength + (profileSize*2)] )
    {
        frameProfile( "z", zAxisTowerHeight );
    }

    translate( [profileSize, yAxisProfileLength - profileSize - zAxisTowerDistanceFromEnd, profileSize + zAxisProfileLength + zAxisTowerHeight] )
    {
        frameProfile( "x", xAxisProfileLength );
    }
}


module bottomFrame()
{
    union()
    {
        // Bottom of the frame
        frameProfile( "y", yAxisProfileLength );

        translate( [xAxisProfileLength + profileSize, 0, 0] )
        {
            frameProfile( "y", yAxisProfileLength );
        }

        // Support legs
        translate( [0, 0, profileSize] )
        {
            frameProfile( "z", zAxisProfileLength );
        }

        translate( [xAxisProfileLength + profileSize, 0, profileSize] )
        {
            frameProfile( "z", zAxisProfileLength );
        }

        translate( [0, yAxisProfileLength - profileSize, profileSize] )
        {
            frameProfile( "z", zAxisProfileLength );
        }

        translate( [xAxisProfileLength + profileSize, yAxisProfileLength - profileSize, profileSize] )
        {
            frameProfile( "z", zAxisProfileLength );
        }

        // Frame base
        translate( [profileSize, 0, profileSize + zAxisProfileLength] )
        {
            frameProfile( "x", xAxisProfileLength );
        }

        translate( [profileSize, (yAxisProfileLength - profileSize), profileSize + zAxisProfileLength] )
        {
            frameProfile( "x", xAxisProfileLength );
        }

        translate( [0, 0, profileSize + zAxisProfileLength] )
        {
            frameProfile( "y", yAxisProfileLength );
        }

        translate( [xAxisProfileLength + profileSize, 0, profileSize + zAxisProfileLength] )
        {
            frameProfile( "y", yAxisProfileLength );
        }
    }
}

module zAxisMountPieces()
{
    union()
    {
        translate( [0, yAxisProfileLength - zAxisTowerDistanceFromEnd - profileSize, zAxisProfileLength + profileSize] )
        {
            rotate( [0, 0, 90] )
            {
                bottomLeftBase();
            }
        }

        translate( [0, yAxisProfileLength - zAxisTowerDistanceFromEnd - profileSize, zAxisProfileLength + (profileSize * 2) + zAxisTowerHeight] )
        {
            rotate( [0, 0, 90] )
            {
                topLeftBase();
            }
        }

        translate( [xAxisProfileLength + (profileSize * 2), yAxisProfileLength - zAxisTowerDistanceFromEnd - profileSize, zAxisProfileLength + profileSize] )
        {
            rotate( [0, 0, 90] )
            {
                bottomRightBase();
            }
        }

        translate( [xAxisProfileLength + (profileSize * 2), yAxisProfileLength - zAxisTowerDistanceFromEnd - profileSize, zAxisProfileLength + (profileSize * 2)  + zAxisTowerHeight] )
        {
            rotate( [0, 0, 90] )
            {
                topRightBase();
            }
        }
    }
}

module zAxisRods()
{
    union()
    {
        translate( [(profileSize/2), yAxisProfileLength - zAxisTowerDistanceFromEnd - profileSize - distanceFromTower, zAxisProfileLength + profileSize + pieceHeight - bearingHeight] )
        {
            cylinder( d = zAxisLeadScrewDiameter, h = zAxisLeadScrewLength );
        }

        translate( [(profileSize/2) - distanceBetweenRetainers, yAxisProfileLength - zAxisTowerDistanceFromEnd - profileSize - distanceFromTower, zAxisProfileLength + profileSize + pieceHeight - linearRodCutoutAdjustedDepth ] )
        {
            cylinder( d = zAxisLinearRodDiameter, h = zAxisLinearRodLength );
        }

        translate( [xAxisProfileLength + profileSize + (profileSize/2), yAxisProfileLength - zAxisTowerDistanceFromEnd - profileSize - distanceFromTower, zAxisProfileLength + profileSize + pieceHeight - bearingHeight ] )
        {
            cylinder( d = zAxisLeadScrewDiameter, h = zAxisLeadScrewLength );
        }

        translate( [xAxisProfileLength + profileSize + (profileSize/2) + distanceBetweenRetainers, yAxisProfileLength - zAxisTowerDistanceFromEnd - profileSize - distanceFromTower, zAxisProfileLength + profileSize + pieceHeight - linearRodCutoutAdjustedDepth ] )
        {
            cylinder( d = zAxisLinearRodDiameter, h = zAxisLinearRodLength );
        }
    }
}

module zAxisBearings()
{
    bearingUnitHeight = (bearingHeight * 2) + bearingSpacerBufferHeight + bearingSpacerPlatformHeight;
    union()
    {
        translate( [(profileSize/2), yAxisProfileLength - zAxisTowerDistanceFromEnd - profileSize - distanceFromTower, zAxisProfileLength + profileSize + pieceHeight - bearingUnitHeight] )
        {
            bearingUnit();
        }
        translate( [xAxisProfileLength + profileSize + (profileSize/2), yAxisProfileLength - zAxisTowerDistanceFromEnd - profileSize - distanceFromTower, zAxisProfileLength + profileSize + pieceHeight - bearingUnitHeight] )
        {
            bearingUnit();
        }

        translate( [(profileSize/2), yAxisProfileLength - zAxisTowerDistanceFromEnd - profileSize - distanceFromTower, zAxisProfileLength + profileSize + zAxisTowerHeight + bearingReliefInset + 0.1] )
        {
            bearingUnit();
        }

        translate( [xAxisProfileLength + profileSize + (profileSize/2), yAxisProfileLength - zAxisTowerDistanceFromEnd - profileSize - distanceFromTower, zAxisProfileLength + profileSize + zAxisTowerHeight + bearingReliefInset + 0.1] )
        {
            bearingUnit();
        }
    }
}

module constructedXAxisCarriage()
{
    xAxisRodXOffset = 3.5;
    xAxisRodYOffset = 15;
    xAxisRodZOffset = 6;
    xAxisDistanceBetweenRods = 45;

    translate( [(profileSize/2) - distanceBetweenRetainers - xAxisRodXOffset + 200, yAxisProfileLength - zAxisTowerDistanceFromEnd - profileSize - distanceFromTower - xAxisRodYOffset - 14, zAxisTowerHeight - xPieceTopOffset - xAxisRodZOffset - 22] )
    {
        rotate( [-90, 180, 0] )
        {
            import( "output/X axis carriage.stl" );
        }
    }
}

module xAxisRods()
{
    xAxisRodXOffset = 3.5;
    xAxisRodYOffset = 15;
    xAxisRodZOffset = 6;
    xAxisDistanceBetweenRods = 45;

    union()
    {
        translate( [(profileSize/2) - distanceBetweenRetainers - xAxisRodXOffset, yAxisProfileLength - zAxisTowerDistanceFromEnd - profileSize - distanceFromTower - xAxisRodYOffset, zAxisTowerHeight - xPieceTopOffset - xAxisRodZOffset] )
        {
            rotate( [0, 90, 0] )
            {
                cylinder( d = xAxisLinearRodDiameter, h = xAxisLinearRodLength );
            }

            // translate( [200, -14, -22] )
            // rotate( [-90, 180, 0] )
            // {
            //     #import( "output/X axis carriage.stl" );
            // }
        }

        translate( [(profileSize/2) - distanceBetweenRetainers - xAxisRodXOffset, yAxisProfileLength - zAxisTowerDistanceFromEnd - profileSize - distanceFromTower - xAxisRodYOffset, zAxisTowerHeight - xPieceTopOffset - xAxisRodZOffset - xAxisDistanceBetweenRods] )
        {
            rotate( [0, 90, 0] )
            {
                cylinder( d = xAxisLinearRodDiameter, h = xAxisLinearRodLength );
            }
        }
    }
}

module xAxisCarriagePieces()
{
    union()
    {
        translate( [(profileSize/2) - distanceBetweenRetainers, yAxisProfileLength - zAxisTowerDistanceFromEnd - profileSize - distanceFromTower, zAxisTowerHeight - xPieceTopOffset] )
        {
            rotate( [180, 0, 90] )
            {
                x_end_idler();
            }
        }

        translate( [xAxisProfileLength + profileSize + (profileSize/2) + distanceBetweenRetainers, yAxisProfileLength - zAxisTowerDistanceFromEnd - profileSize - distanceFromTower, zAxisTowerHeight - xPieceTopOffset] )
        {
            rotate( [180, 0, 90] )
            {
                x_end_motor();
            }
        }
    }
}

module yAxisRods()
{
    yAxisRailHeight = 20;
    union()
    {
        translate( [(xAxisProfileLength/2) - (distanceBetweenSk8Brackets/2) + sk8SideLength + (sk8SideOffset * 2), sk8SideLength + (sk8SideOffset * 2) + yAxisProfileLength - profileSize, zAxisProfileLength + (profileSize*2) + yAxisRailHeight] )
        {
            rotate( [90, 0, 0] )
            {
                cylinder( d = yAxisLinearRodDiameter, h = yAxisLinearRodLength );
            }
        }

        translate( [(xAxisProfileLength/2) - (distanceBetweenSk8Brackets/2) + sk8SideLength + (sk8SideOffset * 2) + distanceBetweenSk8Brackets, sk8SideLength + (sk8SideOffset * 2) + yAxisProfileLength - profileSize, zAxisProfileLength + (profileSize*2) + yAxisRailHeight] )
        {
            rotate( [90, 0, 0] )
            {
                cylinder( d = yAxisLinearRodDiameter, h = yAxisLinearRodLength );
            }
        }
    }
}

module yAxisMountPieces()
{
    union()
    {
        translate( [(xAxisProfileLength/2) - (distanceBetweenSk8Brackets/2), sk8SideLength + sk8SideOffset, zAxisProfileLength + (profileSize*2)] )
        {
            rotate( [90, 0, 0] )
            {
                sk8Bracket();
            }
        }

        translate( [(xAxisProfileLength/2) + (distanceBetweenSk8Brackets/2), sk8SideLength + sk8SideOffset, zAxisProfileLength + (profileSize*2)] )
        {
            rotate( [90, 0, 0] )
            {
                sk8Bracket();
            }
        }

        translate( [(xAxisProfileLength/2) - (distanceBetweenSk8Brackets/2), yAxisProfileLength - sk8SideOffset, zAxisProfileLength + (profileSize*2)] )
        {
            rotate( [90, 0, 0] )
            {
                sk8Bracket();
            }
        }

        translate( [(xAxisProfileLength/2) + (distanceBetweenSk8Brackets/2), yAxisProfileLength - sk8SideOffset, zAxisProfileLength + (profileSize*2)] )
        {
            rotate( [90, 0, 0] )
            {
                sk8Bracket();
            }
        }

        translate( [(xAxisProfileLength/2) + profileSize, profileSize, zAxisProfileLength + (profileSize*2)] )
        {
            rotate( [0, 0, 180] )
            {
                mainUnit();
            }
            translate( [(profileSize/2) + 6, 160, -20] )
            {
                idlerPulleyArm();
            }
        }
    }
}
