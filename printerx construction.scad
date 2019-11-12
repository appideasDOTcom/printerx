/**
* Constructed printer models
*/ 

include <Shared-modules.scad>
include <Z axis retainer block.scad>
include <thirdparty/prusa/Original-Prusa-i3/Printed-Parts/scad/x-end-idler.scad>
include <thirdparty/prusa/Original-Prusa-i3/Printed-Parts/scad/x-end-motor.scad>

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

color( "black" ) bottomFrame();
color( "black" ) topFrame();
color( "blue" ) zAxisMountPieces();
color( "silver" ) zAxisRods();
color( "lightgray" ) zAxisBearings();

color( "blue" ) xAxisCarriagePieces();




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
