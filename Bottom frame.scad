/**
* Electronics enclosures and other 3D printed pieces that mount
*   to a printerx bottom frame
*/ 

use <Shared-modules.scad>

// Render quality settings
$fa = 1;
$fs = 0.1;

yAxisProfileLength = 406;
xAxisProfileLength = 300;
zAxisProfileLength = 50;
profileSize = 20;

zAxisTowerHeight = 374;
zAxisTowerDistanceFromEnd = 50;


renderFrame = true;

module piMount()
{

}

module controllerMount()
{

}

module psuMount()
{

}

module tftMount()
{

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

if( renderFrame )
{
    // color( "black" )
    {
        bottomFrame();
        topFrame();
    }
}
