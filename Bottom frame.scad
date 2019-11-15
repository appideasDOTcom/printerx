/**
* Electronics enclosures and other 3D printed pieces that mount
*   to a printerx bottom frame, minus the anti-vibration feet
*/ 

use <Shared-modules.scad>
include <printerx construction.scad>
use <Frame foot mount.scad>

// Render quality settings
$fa = 5;
$fs = 0.4;

// bf = Bottom Frame
bf_wallThickness = 3;
bf_cornerRoundness = bf_wallThickness * 2;

// bfc = Bottom Frame Controller
bfc_xDistanceBetweenBolts = 101.85;
bfc_yDistanceBetweenBolts = 76.1;
bfc_mountPostDiamter = 8;
bfc_mountPostHeight = 6;

bfc_xOutsideBuffer = 30; // leave room for the fan
bfc_xInsideBuffer = 45; // leave room for wire traps
bfc_yOutsideBuffer = profileSize;
bfc_yInsideBuffer = 22; // leave extra space for wires

bfc_PlatformRearBuffer = 2;

bfc_yWallLength = profileSize + bfc_yDistanceBetweenBolts + (bfc_yOutsideBuffer + bfc_yInsideBuffer) + bfc_PlatformRearBuffer;
bfc_yWallHeight = zAxisProfileLength + (profileSize * 2);

bfc_platformXDimension = bfc_xOutsideBuffer + bfc_xDistanceBetweenBolts + bfc_xInsideBuffer;
bfc_platformYDimension = bfc_yWallLength - profileSize - bfc_PlatformRearBuffer;
bfc_PlatformBottomBuffer = 2;

bfc_fanOpeningDiameter = 36;
bfc_fanDistanceBetweenBolts = 32;
bfc_fanYZDimension = 40;
bfc_fanXDimension = 10;
bfc_fanThroughholeDiameter = 3.7;
bfc_fanThroughholeOffset = ((bfc_fanYZDimension - bfc_fanDistanceBetweenBolts)/2);

bfc_airFlowCutoutDiameter = 8;
bfc_airFlowCutoutLength = 34;

renderFrame = true;

controllerMount();

module controllerMount()
{
    translate( [xAxisProfileLength + (profileSize * 2), yAxisProfileLength - bfc_yWallLength, 0] )
    {
        difference()
        {
            {
                union()
                {
                    controllerMountWalls();
                    controllerMountPosts();
                }
            }
            {
                controllerMountCutouts();
                // TODO: // 1. Lid and mount
                //       // 2. ?40mm exhaust fan out the back?
            }
        }

    }
}

module piMount()
{

}

module psuMount()
{

}

module tftMount()
{

}

module controllerMountCutouts()
{
    union()
    {
        controllerFanMountCutouts();
        controllerMountAirFlowCutouts();
        controllerMountFrameConnectorCutouts();
        controllerMountZAxisMountCutout();
        controllerMountMountingHoles();
    }
    
}

module controllerMountZAxisMountCutout()
{
    translate( [-1, 0, bfc_yWallHeight - profileSize + 0.8] )
    {
        cube( [bf_wallThickness + 2, pieceDepth + 0.2, profileSize - 0.8] );
    }
}

module controllerMountFrameConnectorCutouts()
{
    translate( [-5, (5.6/2) + 10, (profileSize/2)] )
    {
        rotate( [0, 90, 0] )
        {
            m5ThroughHole( 10 );

            translate( [0, bfc_platformYDimension - 1, 0] )
            {
                m5ThroughHole( 10 );

                translate( [-1 * bfc_yWallHeight + 10 + (profileSize/2), 0, 0] )
                {
                    m5ThroughHole( 10 );

                    translate( [0, -50, 0] )
                    {
                        m5ThroughHole( 10 );
                    }
                }
            }
        }
    }
}

module controllerMountAirFlowCutouts()
{
    bfc_airFlowYDistance = 15;

    translate( [-1 * bfc_xInsideBuffer + 6, bfc_yInsideBuffer + bfc_airFlowCutoutDiameter - 20, profileSize + bfc_PlatformBottomBuffer - 1] )
    {
        controllerMountAirFlowCutout();
    }

    translate( [-1 * bfc_xInsideBuffer + 6 - (bfc_airFlowCutoutLength + 12), bfc_yInsideBuffer + bfc_airFlowCutoutDiameter - 20, profileSize + bfc_PlatformBottomBuffer - 1] )
    {
        controllerMountAirFlowCutout();
    }

    for( i = [0:1:4] )
    {
        translate( [-1 * bfc_xInsideBuffer + 6, bfc_yInsideBuffer + bfc_airFlowCutoutDiameter + (i * bfc_airFlowYDistance), profileSize + bfc_PlatformBottomBuffer - 1] )
        {
            controllerMountAirFlowCutout();
        }

        translate( [-1 * bfc_xInsideBuffer + 6 - (bfc_airFlowCutoutLength + 12), bfc_yInsideBuffer + bfc_airFlowCutoutDiameter + (i * bfc_airFlowYDistance), profileSize + bfc_PlatformBottomBuffer - 1] )
        {
            controllerMountAirFlowCutout();
        }
    }

    for( i = [0:1:3] )
    {
        translate( [-1 * bfc_xInsideBuffer - ((bfc_airFlowCutoutLength * 2) + 20), 7.5 + bfc_yInsideBuffer + bfc_airFlowCutoutDiameter + (i * bfc_airFlowYDistance), profileSize + bfc_PlatformBottomBuffer - 1] )
        {
            controllerMountAirFlowCutout();
        }
    }

    for( i = [0:1:2] )
    {
        // translate( [-1 * bfc_xInsideBuffer + 6 - (i * (bfc_airFlowCutoutLength + 12)), bfc_platformYDimension + 1, profileSize + bfc_PlatformBottomBuffer + (bfc_airFlowCutoutDiameter/2) + bf_wallThickness + bfc_mountPostHeight + 2] )
        // {
        //     rotate( [90, 0, 0] )
        //     {
        //         controllerMountAirFlowCutout();
        //     }
        // }

        translate( [-1 * bfc_xInsideBuffer + 6 - (i * (bfc_airFlowCutoutLength + 12)), bfc_platformYDimension + 1, profileSize + bfc_PlatformBottomBuffer + (bfc_airFlowCutoutDiameter/2) + bf_wallThickness + bfc_mountPostHeight + 14] )
        {
            rotate( [90, 0, 0] )
            {
                controllerMountAirFlowCutout();
            }
        }
    }
}

module controllerMountAirFlowCutout()
{
    hull()
    {
        {
            
        }
        {
            union()
            {
                cylinder( d = bfc_airFlowCutoutDiameter, h = bf_wallThickness + 2 );

                translate( [-1 * bfc_airFlowCutoutLength, 0, 0] )
                {
                    cylinder( d = bfc_airFlowCutoutDiameter, h = bf_wallThickness + 2 );
                }
            }
        }
    }
}

module controllerFanMountCutouts()
{
    translate( [-1 * bfc_fanXDimension, bfc_platformYDimension - bfc_fanYZDimension - bfc_yOutsideBuffer - 7, profileSize +  ((zAxisProfileLength - bfc_fanYZDimension)/2) + bfc_PlatformBottomBuffer ] )
    {
        // %cube( [bfc_fanXDimension, bfc_fanYZDimension, bfc_fanYZDimension] );

        translate( [-2, (bfc_fanYZDimension/2), (bfc_fanYZDimension/2)] )
        {
            rotate( [0, 90, 0] )
            {
                cylinder( d = bfc_fanOpeningDiameter, h = 20 );
            }
        }

        translate( [-2, bfc_fanThroughholeOffset, bfc_fanThroughholeOffset ] )
        {
            rotate( [0, 90, 0] )
            {
                cylinder( d = bfc_fanThroughholeDiameter, h = 20 );
            }

            translate( [0, bfc_fanDistanceBetweenBolts, 0 ] )
            {
                rotate( [0, 90, 0] )
                {
                    cylinder( d = bfc_fanThroughholeDiameter, h = 20 );
                }
            }

            translate( [0, 0, bfc_fanDistanceBetweenBolts ] )
            {
                rotate( [0, 90, 0] )
                {
                    cylinder( d = bfc_fanThroughholeDiameter, h = 20 );
                }
            }

            translate( [0, bfc_fanDistanceBetweenBolts, bfc_fanDistanceBetweenBolts ] )
            {
                rotate( [0, 90, 0] )
                {
                    cylinder( d = bfc_fanThroughholeDiameter, h = 20 );
                }
            }
        }
    }
}

module controllerMountPost()
{
    hull()
    {
        {
            cylinder( d = bfc_mountPostDiamter, h = bfc_mountPostHeight );
        }
        {
            translate( [2.6, 0, -1] )
            {
                scale( [1.65, 1, 1] )
                {
                    cylinder( d = bfc_mountPostDiamter, h = 1 );
                }
            }
        }
    }
}

module controllerMountMountingHoles()
{
    translate( [-1 * bfc_xOutsideBuffer, bfc_yInsideBuffer, profileSize + bf_wallThickness - 1.4] )
    {
        m3ThroughHole();
        m3Nut();
        
        translate( [-1 * bfc_xDistanceBetweenBolts, 0, 0] )
        {
            m3ThroughHole();
            m3Nut();
        }
        translate( [-1 * bfc_xDistanceBetweenBolts, bfc_yDistanceBetweenBolts, 0] )
        {
            m3ThroughHole();
            m3Nut();
        }
        translate( [0, bfc_yDistanceBetweenBolts, 0] )
        {
            m3ThroughHole();
            m3Nut();
        }
    }
}

module controllerMountPosts()
{
    translate( [-1 * bfc_xOutsideBuffer, bfc_yInsideBuffer, profileSize + bf_wallThickness] )
    {
        controllerMountPost();

        translate( [-1 * bfc_xDistanceBetweenBolts, 0, 0] )
        {
            controllerMountPost();
        }

        translate( [-1 * bfc_xDistanceBetweenBolts, bfc_yDistanceBetweenBolts, 0] )
        {
            controllerMountPost();
        }
        translate( [0, bfc_yDistanceBetweenBolts, 0] )
        {
            controllerMountPost();
        }
    }
}

module controllerMountWalls()
{
    union()
    {
        // Y axis outside wall
        cube( [bf_wallThickness, bfc_yWallLength, bfc_yWallHeight] );
        
        translate( [-1 * bfc_platformXDimension, 0, profileSize + bfc_PlatformBottomBuffer] )
        {
            // floor
            cube( [bfc_platformXDimension, bfc_platformYDimension, bf_wallThickness] );
            // X axis outside wall
            translate( [0, bfc_platformYDimension - bf_wallThickness, 0] )
            {
                cube( [bfc_platformXDimension, bf_wallThickness, bfc_yWallHeight - (profileSize * 2) - (bf_wallThickness + 0.4) - bfc_PlatformBottomBuffer] );
            }
        }
    }

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
        %yAxisMountPieces();
    }
}
