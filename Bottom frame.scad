/**
* Electronics enclosures and other 3D printed pieces that mount
*   to a printerx bottom frame
*/ 

use <Shared-modules.scad>
use <printerx construction.scad>
use <Frame foot mount.scad>

// Render quality settings
$fa = 5;
$fs = 0.4;




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



if( renderFrame )
{
    // color( "black" )
    {
        %topFrame();
        %bottomFrame();
        %zAxisMountPieces();
        %mountsInContext();
        %zAxisFrameBraces();
        // %yAxisMountPieces();
    }
}
