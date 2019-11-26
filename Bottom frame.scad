/**
* Electronics enclosures and other 3D printed pieces that mount
*   to a printerx bottom frame, minus the anti-vibration feet
*/ 

use <Shared-modules.scad>
include <printerx construction.scad>
use <Frame foot mount.scad>

// Render quality settings
$fa = 1;
$fs = 0.1;

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
// END bfc piece variables

// bfps = Bottom Frame Power Supply (PSU mount)
bfps_actualXDimension = 115;
bfps_actualYDimension = 215;
bfps_actualZDimension = 50;

bfps_topBuffer = 0;
bfps_xInsideBuffer = 2;
bfps_yOutsideBuffer = 20;
bfps_yInsideBuffer = 5;

bfps_yDistanceBetweenBolts = 150;
bfps_zDistanceBetweenBolts = 25;

bfps_yBoltDistanceFromEnd = 32.5;
bfps_yBoltDistanceFromBottom = 12.5;

bfps_mountBlockHeightOffset = 2;
bfps_mountBlockHeight = zAxisProfileLength - (bfps_mountBlockHeightOffset * 2);
bfps_mountBlockWidth = 25;
bfps_mountBlockDepth = profileSize + bfps_xInsideBuffer - 4;

renderFrame = false;

// rightPanel();
// leftPanel();
// frontPanel();
backPanel();
// psuMountBlock();
// powerSwitchCutout();
// psuMount(); // obsolete
// controllerMount();
// piMount();
// tftMount();
// coverPlate();
// TODO: 1. Wire entry hole
//       2. Y axis motor cutout, cutoutut for Y axis belt
//       3. M5 through holes w/ heads
//       4. Pi fan mount
//       5. Remake side panels in wood
//       6. Source wood for panels

// bfcp = Bottom Frame Cover Plate
bfcp_totalXDimension = xAxisProfileLength + (profileSize * 2);
bfcp_totalYDimension = yAxisProfileLength - (profileSize * 2);

bfcp_plateZDimension = 12.8; // 0.5" = 12.7mm
bfcp_plateZOffset = bfcp_plateZDimension - 3;

bfcp_plateWingWidth = 60;

// bffp = Bottom Frame Face Plates (faceplates and coverplates are the same thing - named at different times)
bffp_thickness = 12.9;
bffp_mountThickness = 3;

// bfpw = Bottom Frame Power Switch
bfpw_faceHeight = 58.7;
bfpw_faceWidth = 30;
bfpw_faceCenterWidth = 49.7;
bfpw_faceDepth = 2.6;
bfpw_cornerDiameter = 2;
bfpw_distanceBetweenBolts = 40;

bfpw_insertWidth = 30.4;
bfpw_insertHeight = 49;

// powerSwitchTest();

module powerSwitchTest()
{
    difference()
    {
        {
            translate( [-13, 0, -3] )
            {
                cube( [bfpw_faceCenterWidth + 6, 6, bfpw_faceHeight + 6] );
            }
        }
        {
            powerSwitchCutout();
        }
    }

}

module powerSwitchCutout()
{
    union()
    {
        powerSwitchCutoutFace();
        powerSwitchCutoutBack();
        powerSwitchThroughHoles();
    }
}

module powerSwitchThroughHoles()
{
    rotate( [90, 0, 0] )
    {
        translate( [-1 * ((bfpw_faceCenterWidth - bfpw_faceWidth)/4), (bfpw_faceHeight/2), -45] )
        {
            m4ThroughHole_duplicate( height = 50 );

            translate( [bfpw_distanceBetweenBolts, 0, 0] )
            {
                m4ThroughHole_duplicate( height = 50 );
            }
        }
    }
}

module powerSwitchCutoutBack()
{
    translate( [-0.2, bfpw_faceDepth, ((bfpw_faceHeight - bfpw_insertHeight)/2)] )
    {
        cube( [bfpw_insertWidth, 50, bfpw_insertHeight] );
    }
}

module powerSwitchCutoutFace()
{
    hull()
    {
        {
            translate( [(bfpw_cornerDiameter/2), 0, (bfpw_cornerDiameter/2)] )
            {
                cube( [bfpw_faceWidth - bfpw_cornerDiameter, bfpw_faceDepth, bfpw_faceHeight - bfpw_cornerDiameter] );
            }
        }
        {
            union()
            {
                rotate( [90, 0, 0] )
                {
                    translate( [-1 * (bfpw_faceCenterWidth/2) + (bfpw_faceWidth/2) +  (bfpw_cornerDiameter/2), (bfpw_faceHeight/2), -1 * bfpw_faceDepth] )
                    {
                        cylinder( d = bfpw_cornerDiameter, h = bfpw_faceDepth );
                    }

                    translate( [bfpw_faceWidth + (bfpw_faceCenterWidth/2) - (bfpw_faceWidth/2) - (bfpw_cornerDiameter/2), (bfpw_faceHeight/2), -1 * bfpw_faceDepth] )
                    {
                        cylinder( d = bfpw_cornerDiameter, h = bfpw_faceDepth );
                    }
                }

                rotate( [90, 0, 0] )
                {
                    translate( [(bfpw_cornerDiameter/2), (bfpw_cornerDiameter/2), -1 * bfpw_faceDepth] )
                    {
                        cylinder( d = bfpw_cornerDiameter, h = bfpw_faceDepth );

                        translate( [0, bfpw_faceHeight - bfpw_cornerDiameter, 0] )
                        {
                            cylinder( d = bfpw_cornerDiameter, h = bfpw_faceDepth );
                        }

                        translate( [bfpw_faceWidth - bfpw_cornerDiameter, bfpw_faceHeight - bfpw_cornerDiameter, 0] )
                        {
                            cylinder( d = bfpw_cornerDiameter, h = bfpw_faceDepth );
                        }

                        translate( [bfpw_faceWidth - bfpw_cornerDiameter, 0, 0] )
                        {
                            cylinder( d = bfpw_cornerDiameter, h = bfpw_faceDepth );
                        }
                    }
                }
            }
        }
    }

}

module frontPanel()
{
    difference()
    {
        {
            translate( [-3, -3, 0] )
            {
                cube( [xAxisProfileLength + (profileSize * 2) + 6, bffp_thickness, zAxisProfileLength + (profileSize * 2)] );
            }
        }
        {
            union()
            {
                translate( [xAxisProfileLength + profileSize - bftm_mountWidth - 5 - 0.5, -1 * bftm_mountThickness - 1, 16 + 0.1] )
                {
                    cube( [bftm_mountWidth + 1, 20, 74] );
                }
                translate( [0, 0, zAxisProfileLength + (profileSize)] )
                {
                    coverPlateFrameCutout( cutSides = 1 );
                }
                frontPanelThroughHoles();
                
                
            }
        }
    }

}

module frontPanelThroughHoles()
{
    rotate( [90, 0, 0] )
    {
        translate( [(profileSize/2), ((profileSize * 2) + zAxisProfileLength)/2, -25] )
        {
            m5ThroughHole_duplicate( height = 30 );

            translate( [xAxisProfileLength + profileSize, 0, 0] )
            {
                m5ThroughHole_duplicate( height = 30 );
            }
        }

        translate( [(profileSize/2) + profileSize, zAxisProfileLength + profileSize + (profileSize/2), -25] )
        {
                m5ThroughHole_duplicate( height = 30 );

                translate( [140, 0, 0] )
                {
                    m5ThroughHole_duplicate( height = 30 );
                }
        }
    }
}

module rightPanel()
{
    translate( [xAxisProfileLength + (profileSize * 2) - (bffp_thickness - bffp_mountThickness), 0, 0] )
    {
        cube( [bffp_thickness, yAxisProfileLength, zAxisProfileLength + (profileSize * 2)] );
    }
}

module leftPanel()
{
    difference()
    {
        {
            union()
            {
                translate( [-1 * bffp_thickness + (bffp_thickness - bffp_mountThickness), 0, 0] )
                {
                    cube( [bffp_thickness, yAxisProfileLength, zAxisProfileLength + (profileSize * 2)] );
                }

                // psuMountBlocks();
            }
        }
        {
            union()
            {
                translate( [0, 0, zAxisProfileLength + (profileSize)] )
                {
                    coverPlateFrameCutout();
                }

                psuMountBlockCutouts();

                translate( [-12, 0, 0] )
                {
                    psuInternalMountHoles();
                }

                psuZAxisMountCutout();
                leftPanelframeMountThroughHoles();
                
            }
        }
    }

}

module backPanel()
{
    difference()
    {
        {
            translate( [-3, yAxisProfileLength - bffp_thickness + 3, 0] )
            {
                cube( [xAxisProfileLength + (profileSize * 2) + 6, bffp_thickness, zAxisProfileLength + (profileSize * 2)] );
            }
        }
        {
            union()
            {
                translate( [0, 0, zAxisProfileLength + (profileSize)] )
                {
                    coverPlateFrameCutout( cutSides = 1 );

                    translate( [xAxisProfileLength/2 + 10, yAxisProfileLength + 3.1, -60] )
                    {
                        rotate( [0, 0, 180] )
                        {
                            powerSwitchCutout();
                        }
                    }
                }

                translate( [(profileSize/2), yAxisProfileLength + 7, 10] )
                {
                    backPanelThroughHoles();
                }
            }


            
        }
    }

}

module backPanelThroughHoles()
{
    rotate( [90, 0, 0] )
    {
        translate( [0, (zAxisProfileLength/2) + (profileSize/2), 0] )
        {
            m5ThroughHole_duplicate( height = 30 );
        }

        translate( [xAxisProfileLength + profileSize, (zAxisProfileLength/2) + (profileSize/2), 0] )
        {
            m5ThroughHole_duplicate( height = 30 );
        }

        translate( [profileSize, zAxisProfileLength + profileSize, 0] )
        {
            m5ThroughHole_duplicate( height = 30 );
        }

        translate( [xAxisProfileLength, zAxisProfileLength + profileSize, 0] )
        {
            m5ThroughHole_duplicate( height = 30 );
        }

        translate( [xAxisProfileLength - (xAxisProfileLength/3.5), zAxisProfileLength + profileSize, 0] )
        {
            m5ThroughHole_duplicate( height = 30 );
        }

        translate( [profileSize + (xAxisProfileLength/3.5), zAxisProfileLength + profileSize, 0] )
        {
            m5ThroughHole_duplicate( height = 30 );
        }


    }
}



module leftPanelframeMountThroughHoles()
{
    translate( [-10, 10, (profileSize/2)] )
    {
        rotate( [0, 90, 0] )
        {
            m5ThroughHole_duplicate( height = 35 );

            translate( [-1 * zAxisProfileLength - profileSize, 0, 0] )
            {
                m5ThroughHole_duplicate( height = 35 );
            }

            translate( [-1 * zAxisProfileLength - profileSize, yAxisProfileLength - profileSize, 0] )
            {
                m5ThroughHole_duplicate( height = 35 );
            }

            translate( [0, yAxisProfileLength - profileSize, 0] )
            {
                m5ThroughHole_duplicate( height = 35 );
            }

            // Anchors at 1/3 and 2/3
            // translate( [0, (yAxisProfileLength - profileSize) * (1/3), 0] )
            // {
            //     m5ThroughHole_duplicate( height = 35 );
            // }

            // translate( [0, (yAxisProfileLength - profileSize) * (2/3) - 10, 0] )
            // {
            //     m5ThroughHole_duplicate( height = 35 );
            // }


            // translate( [-1 * zAxisProfileLength - profileSize, (yAxisProfileLength - profileSize) * (1/3), 0] )
            // {
            //     m5ThroughHole_duplicate( height = 35 );
            // }

            // translate( [-1 * zAxisProfileLength - profileSize, (yAxisProfileLength - profileSize) * (2/3) - 10, 0] )
            // {
            //     m5ThroughHole_duplicate( height = 35 );
            // }

            // Anchors at 1/2
            translate( [0, (yAxisProfileLength - profileSize) * (1/2), 0] )
            {
                m5ThroughHole_duplicate( height = 35 );
            }

            translate( [-1 * zAxisProfileLength - profileSize, (yAxisProfileLength - profileSize) * (1/2), 0] )
            {
                m5ThroughHole_duplicate( height = 35 );
            }

        }
    }
}

module psuMountBlocks()
{
    translate( [4, yAxisProfileLength - (bfps_mountBlockWidth/2) - profileSize - bfps_yOutsideBuffer - bfps_yBoltDistanceFromEnd, profileSize + bfps_mountBlockHeightOffset] )
    {
        cube( [bfps_mountBlockDepth, bfps_mountBlockWidth, bfps_mountBlockHeight] );

        translate( [0, -1 * bfps_actualYDimension + 52.6 + (bfps_mountBlockWidth/2), 0] )
        {
            cube( [bfps_mountBlockDepth, bfps_mountBlockWidth, bfps_mountBlockHeight] );
        }
    }
}

// single block for easier prep for printing
module psuMountBlock()
{
    difference()
    {
        {
            translate( [4, yAxisProfileLength - (bfps_mountBlockWidth/2) - profileSize - bfps_yOutsideBuffer - bfps_yBoltDistanceFromEnd, profileSize + bfps_mountBlockHeightOffset] )
            {
                cube( [bfps_mountBlockDepth, bfps_mountBlockWidth, bfps_mountBlockHeight] );
            }
        }
        {
            translate( [-12, 0, 0] )
            {
                psuInternalMountHoles();
            }
        }
    }

}

module psuMountBlockCutouts()
{
    translate( [4, yAxisProfileLength - (bfps_mountBlockWidth/2) - profileSize - bfps_yOutsideBuffer - bfps_yBoltDistanceFromEnd - 0.2, profileSize + bfps_mountBlockHeightOffset - 0.2] )
    {
        cube( [bfps_mountBlockDepth, bfps_mountBlockWidth + 0.4, bfps_mountBlockHeight + 0.4] );

        translate( [0, -1 * bfps_actualYDimension + 52.6 + (bfps_mountBlockWidth/2), 0] )
        {
            cube( [bfps_mountBlockDepth, bfps_mountBlockWidth + 0.4, bfps_mountBlockHeight + 0.4] );
        }
    }
}

// individual 3D printed pieces for the bottom frame cover.
module coverPlate()
{
    difference()
    {
        {
            translate( [0, profileSize, zAxisProfileLength + (profileSize * 2) - bfcp_plateZOffset] )
            {
                // main piece
                cube( [bfcp_totalXDimension, bfcp_totalYDimension, bfcp_plateZDimension] );

                // wings to connect to the X axis profile pieces
                translate( [0, -1 * profileSize, 0] )
                {
                    cube( [bfcp_plateWingWidth, profileSize, bfcp_plateZDimension] );
                }

                translate( [xAxisProfileLength - profileSize, -1 * profileSize, 0] )
                {
                    cube( [bfcp_plateWingWidth, profileSize, bfcp_plateZDimension] );
                }

                translate( [0, yAxisProfileLength - (profileSize * 2), 0] )
                {
                    cube( [bfcp_plateWingWidth, profileSize, bfcp_plateZDimension] );
                }

                translate( [xAxisProfileLength - profileSize, yAxisProfileLength - (profileSize * 2), 0] )
                {
                    cube( [bfcp_plateWingWidth, profileSize, bfcp_plateZDimension] );
                }
            }
        }
        {
            translate( [0, 0, zAxisProfileLength + (profileSize)] )
            {
                coverPlateFrameCutout();
                coverPlateMidProfileCutout();
                coverPlateEndProfileCutout();
            }
        }
    }

}

module coverPlateEndProfileCutout()
{
    translate( [0, yAxisProfileLength - profileSize - 50, profileSize - 12] )
    {
        cube( [profileSize + 1.5, 50 + profileSize + 1, 20] );

        translate( [xAxisProfileLength + profileSize - 1.5, 0, 0] )
        {
            cube( [profileSize + 1.5, 50 + profileSize + 1, 20] );
        }
    }
}

module coverPlateMidProfileCutout()
{
    translate( [-15.5, yAxisProfileLength - profileSize - 50 - (pieceDepth + 5), profileSize - 12] )
    {
        cube( [pieceWidth, pieceDepth + 10, profileSize - 0.8] );

        translate( [xAxisProfileLength + profileSize + 9, 0, 0] )
        {
            cube( [pieceWidth, pieceDepth + 10, profileSize - 0.8] );
        }
    }
}

module coverPlateFrameCutout( cutSides = 0 )
{
    translate( [0, 0, -0.2] )
    {
        cutoutFrameProfile( axis = "x", length = xAxisProfileLength + (profileSize * 2) );
    }

    translate( [0, yAxisProfileLength - profileSize - 0.2, -0.2] )
    {
        cutoutFrameProfile( axis = "x", length = xAxisProfileLength + (profileSize * 2) );
    }

    // translate( [xAxisProfileLength - profileSize - 0.2, 0, 0] )
    // {
    //     cutoutFrameProfile( axis = "x", length = bfcp_plateWingWidth + 0.2 );
    // }

    // translate( [0, yAxisProfileLength - profileSize - 0.2, 0] )
    // {
    //     cutoutFrameProfile( axis = "x", length = bfcp_plateWingWidth + 0.2 );
    // }

    // translate( [xAxisProfileLength - profileSize - 0.2, yAxisProfileLength - profileSize - 0.2, 0] )
    // {
    //     cutoutFrameProfile( axis = "x", length = bfcp_plateWingWidth + 0.2 );
    // }

    translate( [0, 0, -0.2] )
    {
        cutoutFrameProfile( axis = "y", length = yAxisProfileLength );
    }

    translate( [xAxisProfileLength + profileSize - 0.2, 0, -0.2] )
    {
        cutoutFrameProfile( axis = "y", length = yAxisProfileLength );
    }

    translate( [0, 0, -1 * (zAxisProfileLength + profileSize)] )
    {
        cutoutFrameProfile( axis = "y", length = yAxisProfileLength );
    }
    translate( [xAxisProfileLength + profileSize - 0.2, 0, -1 * (zAxisProfileLength + profileSize)] )
    {
        cutoutFrameProfile( axis = "y", length = yAxisProfileLength );
    }

    translate( [0, 0, -1 * (zAxisProfileLength + profileSize)] )
    {
        cutoutFrameProfile( axis = "z", length = zAxisProfileLength + (profileSize * 2) );
    }

    translate( [0, yAxisProfileLength - profileSize - 0.2, -1 * (zAxisProfileLength + profileSize)] )
    {
        cutoutFrameProfile( axis = "z", length = zAxisProfileLength + (profileSize * 2) );
    }

    translate( [xAxisProfileLength + profileSize - 0.2, 0, -1 * (zAxisProfileLength + profileSize)] )
    {
        cutoutFrameProfile( axis = "z", length = zAxisProfileLength + (profileSize * 2) );
    }

    translate( [xAxisProfileLength + profileSize - 0.2, yAxisProfileLength - profileSize - 0.2, -1 * (zAxisProfileLength + profileSize)] )
    {
        cutoutFrameProfile( axis = "z", length = zAxisProfileLength + (profileSize * 2) );
    }

    if( cutSides == 1 )
    {
        translate( [-1 * profileSize, 0, -1 * (zAxisProfileLength + profileSize)] )
        {
            cutoutFrameProfile( axis = "z", length = zAxisProfileLength + (profileSize * 2) );
        }

        translate( [-1 * profileSize, yAxisProfileLength - profileSize - 0.2, -1 * (zAxisProfileLength + profileSize)] )
        {
            cutoutFrameProfile( axis = "z", length = zAxisProfileLength + (profileSize * 2) );
        }

        translate( [xAxisProfileLength + profileSize - 0.2 + profileSize, 0, -1 * (zAxisProfileLength + profileSize)] )
        {
            cutoutFrameProfile( axis = "z", length = zAxisProfileLength + (profileSize * 2) );
        }

        translate( [xAxisProfileLength + profileSize - 0.2 + profileSize, yAxisProfileLength - profileSize - 0.2, -1 * (zAxisProfileLength + profileSize)] )
        {
            cutoutFrameProfile( axis = "z", length = zAxisProfileLength + (profileSize * 2) );
        }
    }
}

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
                //       // 2. ? 40mm exhaust fan out the back ?
            }
        }

    }
}



module psuMount()
{
    // Mock PSU
    translate( [profileSize + bfps_xInsideBuffer, yAxisProfileLength - (bfps_actualYDimension + profileSize + bfps_yOutsideBuffer), profileSize - (bf_wallThickness + 0.4) - bfps_topBuffer] )
    {
        %cube( [bfps_actualXDimension, bfps_actualYDimension, bfps_actualZDimension] );
    }

    difference()
    {
        {
            psuMountBase();
        }
        {
            psuInternalMountHoles();
            psuZAxisMountCutout();
            psuFrameMountHoles();

            // TODO: 1. Lid and mount
            //       2. ? air flow cutouts ?
        }
    }

    // Mock full wall
    // translate( [-1 * bf_wallThickness, yAxisProfileLength - (profileSize + bfps_actualYDimension + bfps_yOutsideBuffer + bfps_yInsideBuffer), 0] )
    // {
    //     cube( [bf_wallThickness, profileSize + bfps_actualYDimension + bfps_yOutsideBuffer + bfps_yInsideBuffer, (profileSize * 2) + zAxisProfileLength] );
    // }
}

// bftm = Bottom Fram TFT Mount
bftm_xDistanceBetweenBolts = 100.08;
bftm_zDistanceBetweenBolts = 41.15;

bftm_facePlateXDimension = 115.4;
bftm_facePlateZDimension = 58.4;  // add 3mm to the top for mounting

bftm_facePlateActualXDimension = 105;
bftm_facePlateActualZDimension = 46;

bftm_boltOffset = (bftm_facePlateActualXDimension - bftm_xDistanceBetweenBolts)/2;

bftm_faceOpeningXDimension = 58.4;
bftm_faceOpeningZDimension = 45.5;

bftm_faceOpeningXOffset = 29.68;

// 2.425 - bolt offset from outside

bftm_wallThickness = bf_wallThickness;
bftm_mountThickness = 7;
bftm_mountWidth = bftm_facePlateXDimension;
bftm_mountHeight = profileSize + 2;

bftm_bevelDiameter = bf_wallThickness;

bftm_mountPostDiameter = 8;
bftm_mountPostHeight = 4.5;

bftm_resetCutoutDiameter = 7;
bftm_resetCutoutXOffset = 13.46;
bftm_resetCutoutZOffset = 3.69;

bftm_speakerCutoutDiameter = 10;
bftm_speakerCutoutXOffset = 6.81;
bftm_speakerCutoutZOffset = 6.09;

bftm_knobCutoutXZDimension = 12;
bftm_knobCutoutXOffset = 2.5;
bftm_knobCutoutZOffset = 20.85;

btfm_tiltAngle = 22;

bftm_sdCutoutLength = 30;
bftm_sdCutoutWidth = 5;
bftm_sdCutoutYOffset = 9.2;
bftm_sdCutoutZOffset = 44;

module tftMount()
{
    translate( [xAxisProfileLength + profileSize - bftm_mountWidth - 5, -1 * bftm_mountThickness, zAxisProfileLength + profileSize] )
    {
        tftFrameMount();

        translate( [0, -21.25, -1 * bftm_facePlateZDimension + 2 + 4] )
        {
            // tilt the screen for more comfortable viewing
            rotate( [-1 * btfm_tiltAngle, 0, 0] )
            {
                tftFaceplate();
                tftBevel();

                // shape of the actual device for fit
                // translate( [(bftm_facePlateXDimension - bftm_facePlateActualXDimension)/2 + 1, 0, (bftm_facePlateZDimension - bftm_facePlateActualZDimension)/2 - 1] )
                // {
                //     %cube( [bftm_facePlateActualXDimension, 7.5, bftm_facePlateActualZDimension] );
                // }
            }
        }
        tftMountSideSupport();

        // Superimpose a third party model that has nearly the correct dimensions
        // translate( [59, -21.5 + 10.5, -29 + 2.5] )
        // {
        //     rotate( [112, 180, 0] )
        //     {
        //         import( "thirdparty/tft24_upperpart_no_logo.stl" );
        //     }
        // }
    }
}

module tftMountSideSupport()
{
    difference()
    {
        {
            hull()
            {
                {

                }
                {
                    union()
                    {
                        translate( [0, 0, -3] )
                        {
                            cube( [bftm_wallThickness, profileSize + bftm_mountThickness, 1] );
                        }

                        translate( [0, -18.5, -53.52] )
                        {
                            cube( [bftm_wallThickness, 5, 1] );
                        }

                        translate( [0, profileSize + bftm_mountThickness - 5, -53.52] )
                        {
                            cube( [bftm_wallThickness, 5, 1] );
                        }
                    }
                }
            }
        }
        {
            translate( [-1, -1 * bftm_sdCutoutYOffset, -1 * bftm_sdCutoutZOffset] )
            {
                rotate( [-1 * btfm_tiltAngle, 0, 0] )
                {
                    cube( [10, bftm_sdCutoutWidth, bftm_sdCutoutLength] );
                }
            }
        }
    }




}

module tftMountPosts()
{
    translate([bftm_boltOffset, 0, bftm_boltOffset]) 
    {
        rotate( [90, 0, 0] )
        {
            cylinder( d = bftm_mountPostDiameter, h = bftm_mountPostHeight );

            translate( [0, bftm_zDistanceBetweenBolts, 0] )
            {
                cylinder( d = bftm_mountPostDiameter, h = bftm_mountPostHeight );
            }

            translate( [bftm_xDistanceBetweenBolts, 0, 0] )
            {
                cylinder( d = bftm_mountPostDiameter, h = bftm_mountPostHeight );
            }

            translate( [bftm_xDistanceBetweenBolts, bftm_zDistanceBetweenBolts, 0] )
            {
                cylinder( d = bftm_mountPostDiameter, h = bftm_mountPostHeight );
            }
        }
    }
}

module tftMountThroughHoles()
{
    translate([bftm_boltOffset, 10, bftm_boltOffset]) 
    {
        rotate( [90, 0, 0] )
        {
            m3ThroughHole();

            translate( [0, bftm_zDistanceBetweenBolts, 0] )
            {
                m3ThroughHole();
            }

            translate( [bftm_xDistanceBetweenBolts, 0, 0] )
            {
                m3ThroughHole();
            }

            translate( [bftm_xDistanceBetweenBolts, bftm_zDistanceBetweenBolts, 0] )
            {
                m3ThroughHole();
            }
        }
    }
}

module tftBevel()
{
    translate( [bftm_facePlateXDimension - bftm_faceOpeningXDimension - bftm_faceOpeningXOffset, (bftm_bevelDiameter/1), ((bftm_facePlateZDimension - 3) - bftm_faceOpeningZDimension)/2] )
    {
        difference()
        {
            {
                union()
                {
                    cylinder( d = bftm_bevelDiameter * 2, h = bftm_faceOpeningZDimension );

                    translate( [bftm_faceOpeningXDimension, 0, 0] )
                    {
                        cylinder( d = bftm_bevelDiameter * 2, h = bftm_faceOpeningZDimension );
                    }

                    rotate( [0, 90, 0] )
                    {
                        cylinder( d = bftm_bevelDiameter * 2, h = bftm_faceOpeningXDimension );

                        translate( [-1 * bftm_faceOpeningZDimension, 0, 0] )
                        {
                            cylinder( d = bftm_bevelDiameter * 2, h = bftm_faceOpeningXDimension );
                        }
                    }
                }
            }
            {
                translate( [-20, 0, -5] )
                {
                    cube( [bftm_facePlateXDimension + 10, 4, bftm_facePlateZDimension + 10] );
                }

                translate( [-25, -4, -12.2] )
                {
                    cube( [bftm_facePlateXDimension + 10, 5, 10] );
                }
            }
        }
    }

}

module tftFrameMount()
{
    difference()
    {
        {
            translate( [0, 0, -2] )
            cube( [bftm_mountWidth, bftm_mountThickness, bftm_mountHeight] );
        }
        {
            translate( [10, 8, (profileSize/2)] )
            {
                rotate( [90, 0, 0] )
                {
                    m5ThroughHole();
                    translate( [0, 0, 4] )
                    {
                        m5Head();
                    }

                    translate( [bftm_facePlateXDimension - profileSize, 0, 0] )
                    {
                        m5ThroughHole();
                        translate( [0, 0, 4] )
                        {
                            m5Head();
                        }
                    }
                }
            }
        }
    }
}

module tftFaceplate()
{
    difference()
    {
        {
            union()
            {
                cube( [bftm_facePlateXDimension, bftm_wallThickness, bftm_facePlateZDimension] );

                translate( [(bftm_facePlateXDimension - bftm_facePlateActualXDimension)/2 + 1, bftm_wallThickness + bftm_mountPostHeight, (bftm_facePlateZDimension - bftm_facePlateActualZDimension)/2 - 1] )
                {
                    tftMountPosts();
                }
            }
        }
        {
            union()
            {
                translate( [bftm_facePlateXDimension - bftm_faceOpeningXDimension - bftm_faceOpeningXOffset, -1, ((bftm_facePlateZDimension - 3) - bftm_faceOpeningZDimension)/2] )
                {
                    cube( [bftm_faceOpeningXDimension, 5, bftm_faceOpeningZDimension] );
                }

                translate( [(bftm_facePlateXDimension - bftm_facePlateActualXDimension)/2 + 1, 0, (bftm_facePlateZDimension - bftm_facePlateActualZDimension)/2 - 1] )
                {
                    tftMountThroughHoles();
                    tftMountControlCutouts();
                }
            }
        }
    }
}

module tftMountControlCutouts()
{
    translate( [bftm_facePlateActualXDimension - bftm_resetCutoutXOffset, 9, bftm_resetCutoutZOffset] )
    {
        rotate( [90, 0, 0] )
        {
            cylinder( d = bftm_resetCutoutDiameter, h = 10 );
        }
    }

    translate( [bftm_facePlateActualXDimension - bftm_speakerCutoutXOffset, 9, bftm_facePlateActualZDimension - (bftm_speakerCutoutDiameter/2) - bftm_speakerCutoutZOffset] )
    {
        rotate( [90, 0, 0] )
        {
            cylinder( d = bftm_speakerCutoutDiameter, h = 10 );
        }
    }

    translate( [bftm_facePlateActualXDimension - bftm_knobCutoutXZDimension - bftm_knobCutoutXOffset, -5, bftm_facePlateActualZDimension - bftm_knobCutoutXZDimension - bftm_knobCutoutZOffset] )
    {
        cube( [bftm_knobCutoutXZDimension, 10, bftm_knobCutoutXZDimension] );
    }

    
}

// bfpi = Bottom Frame Raspbnerry Pi mount
bfpi_yDistanceBetweenBolts = 58;
bfpi_xDistanceBetweenBolts = 49;

bfpi_actualXDimension = 56;
bfpi_actualYDimension = 85;

bfpi_platformBottomBuffer = 2;
bfpi_platformFrontOffset = 140.8;

bfpi_platformRearYExtension = 30;
bfpi_platformFrontYExtension = 10;
bfpi_platformInsideXExtension = 5;

bfpi_platformXDimension = bfpi_actualXDimension + bfpi_platformInsideXExtension;
bfpi_platformYDimension = bfpi_actualYDimension + bfpi_platformRearYExtension + bfpi_platformFrontYExtension;
bfpi_platformZDimension = bf_wallThickness;

bfpi_postDiameter = 5;
bfpi_postHeight = 4;
bfpi_postOffset = 3.5;

bfpi_externalUsbCutoutDiameter = 28.6;

bfpi_airFlowCutoutDiameter = 6;
bfpi_airFlowCutoutLength = 33;

bfpi_cableTieCutoutLength = 33;

bfpi_renderUsbCutout = true;


module piMount()
{
    // TODO: 1. Add pi cooling fan
    //       2. Lid and mount


    translate([xAxisProfileLength + (profileSize * 2) - bfpi_actualXDimension, bfpi_platformFrontOffset, profileSize] )
    {
        difference()
        {
            {
                translate( [0, 0, bfpi_platformBottomBuffer] )
                {
                    translate( [-1 * bfpi_platformInsideXExtension, 0, 0] )
                    {
                        cube( [bfpi_platformXDimension, bfpi_platformYDimension, bfpi_platformZDimension] );
                    }

                    translate( [bfpi_postOffset, bfpi_postOffset + bfpi_platformFrontYExtension, bfpi_platformZDimension] )
                    {
                        piMountPosts();
                    }
                    
                    translate( [bfpi_actualXDimension, 0, -1 * profileSize - bfpi_platformBottomBuffer] )
                    {
                        piMountWalls();
                    }
                }

                // translate( [187.7, 145.5 + bfpi_platformFrontYExtension, 3] )
                // {
                //     #import( "thirdparty/pi4_bottom_noVesa.stl" );
                // }
                // piMountPlatformExtensions();
            }
            {
                // color( "blue" )
                piMountExternalCutouts();

                translate( [bfpi_actualXDimension + bfpi_platformZDimension, 0, -1 * profileSize] )
                {
                    cube( [bfpi_platformZDimension, bfpi_platformYDimension, zAxisProfileLength + (profileSize * 2)] );
                }

                piMountFrameThroughHoles();
                piMountAirFlowCutouts();

            }
        }

    }
}

module piMountAirFlowCutouts()
{
    translate( [13, 19.5, 1] )
    {
        piMountAirFlowCutout();
    }

    translate( [13, 28.5, 1] )
    {
        piMountAirFlowCutout();
    }

    translate( [13, 37.5, 1] )
    {
        piMountAirFlowCutout();
    }

    translate( [13, 46.5, 1] )
    {
        piMountAirFlowCutout();
    }

    translate( [13, 55.5, 1] )
    {
        piMountAirFlowCutout();
    }

    translate( [13, 64.5, 1] )
    {
        piMountAirFlowCutout();
    }

    translate( [13, 83, 1] )
    {
        piMountCableTieFlowCutout();
    }

    translate( [13, 92, 1] )
    {
        piMountCableTieFlowCutout();
    }

    translate( [13, 101, 1] )
    {
        piMountCableTieFlowCutout();
    }

    translate( [13, 110, 1] )
    {
        piMountCableTieFlowCutout();
    }
}

module piMountCableTieFlowCutout()
{
    hull()
    {
        {
            
        }
        {
            union()
            {
                cylinder( d = bfpi_airFlowCutoutDiameter, h = bfpi_platformZDimension + 2 );

                translate( [bfpi_cableTieCutoutLength, 0, 0] )
                {
                    cylinder( d = bfpi_airFlowCutoutDiameter, h = bfpi_platformZDimension + 2 );
                }
            }
        }
    }
}

module piMountAirFlowCutout()
{
    hull()
    {
        {
            
        }
        {
            union()
            {
                cylinder( d = bfpi_airFlowCutoutDiameter, h = bfpi_platformZDimension + 2 );

                translate( [bfpi_airFlowCutoutLength, 1, 0] )
                {
                    cylinder( d = bfpi_airFlowCutoutDiameter, h = bfpi_platformZDimension + 2 );
                }
            }
        }
    }
}

module piMountWalls()
{
    cube( [bfpi_platformZDimension, bfpi_platformYDimension, zAxisProfileLength + (profileSize * 2)] );
}

module piMountExternalCutouts()
{
    translate( [bfpi_actualXDimension - 6, 5.7 + bfpi_platformFrontYExtension, 10] )
    {
        cube( [10, 10, 3.4] );

        translate( [7.6, -1.5, -1.5] )
        {
            cube( [5, 13, 6.4] );
        }

        translate( [0, 15.55, 0] )
        {
            cube( [10, 8.5, 3.2] );

            translate( [7.6, -2.5, -3] )
            {
                cube( [5, 27, 10.5] );
            }
        }

        translate( [0, 29.05, 0] )
        {
            cube( [10, 8.5, 3.2] );
        }

        translate( [0, 47.8, 3.5] )
        {
            rotate( [0, 90, 0] )
            {
                cylinder( d = 7.5, h = 10 );

                translate( [0, 0, 8] )
                {
                    cylinder( d = 10, h = 5 );
                }
            }
        }

        if( bfpi_renderUsbCutout )
        {
            translate( [0, 85, 15] )
            {
                rotate( [0, 90, 0] )
                {
                    cylinder( d = bfpi_externalUsbCutoutDiameter, h = 10 );
                }
            }
        }

    }
}

module piMountFrameThroughHoles()
{
    translate( [bfpi_actualXDimension - 1, 10, -1 * (profileSize/2)] )
    {
        rotate( [0, 90, 0] )
        {
            m5ThroughHole();

            translate( [-1 * zAxisProfileLength - profileSize, 0, 0] )
            {
                m5ThroughHole();
            }

            translate( [0, bfpi_platformYDimension - 20, 0] )
            {
                m5ThroughHole();
            }

            translate( [-1 * zAxisProfileLength - profileSize, bfpi_platformYDimension - 20, 0] )
            {
                m5ThroughHole();
            }
        }
    }
}

module piMountPosts()
{
    union()
    {
        piMountPost();

        translate( [bfpi_xDistanceBetweenBolts, 0, 0] )
        {
            piMountPost();
        }

        translate( [0, bfpi_yDistanceBetweenBolts, 0] )
        {
            piMountPost();
        }

        translate( [bfpi_xDistanceBetweenBolts, bfpi_yDistanceBetweenBolts, 0] )
        {
            piMountPost();
        }
    }
}

module piMountPost()
{
    difference()
    {
        {
            hull()
            {
                {
                    cylinder( d = bfpi_postDiameter, h = bfpi_postHeight );
                }
                {
                    translate( [2.5, 0, -1] )
                    {
                        scale( [1.8, 1, 1] )
                        {
                            cylinder( d = bfpi_postDiameter, h = 1 );
                        }
                    }
                }
            }
        }
        {
            translate( [0, 0, 01.] )
            {
                cylinder( d1 = 2, d2 = 2.5, h = 4 );
            }
        }
    }

}

module psuMountBase()
{
    translate( [0, yAxisProfileLength - (bfps_mountBlockWidth/2) - profileSize - bfps_yOutsideBuffer - bfps_yBoltDistanceFromEnd, profileSize + bfps_mountBlockHeightOffset] )
    {
        cube( [bfps_mountBlockDepth, bfps_mountBlockWidth, bfps_mountBlockHeight] );

        translate( [0, -1 * bfps_actualYDimension + 52.6 + (bfps_mountBlockWidth/2), 0] )
        {
            cube( [bfps_mountBlockDepth, bfps_mountBlockWidth, bfps_mountBlockHeight] );
        }

        translate( [-1 * bf_wallThickness, -1 * (bfps_yDistanceBetweenBolts), -1 * profileSize - bfps_mountBlockHeightOffset] )
        {
            cube( [bf_wallThickness, bfps_yDistanceBetweenBolts + bfps_mountBlockWidth, zAxisProfileLength + (profileSize * 2)] );
        }
    }
}

module psuZAxisMountCutout()
{
    translate( [-1 * (bf_wallThickness + 1), yAxisProfileLength - zAxisTowerDistanceFromEnd - profileSize - pieceDepth - 0.1, profileSize + bfps_mountBlockHeightOffset - profileSize - 1.9] )
    {
        controllerMountZAxisMountCutout();
    }
}

module psuFrameMountHoles()
{
    translate( [-3.1, yAxisProfileLength - (profileSize + bfps_yOutsideBuffer + bfps_yBoltDistanceFromEnd - 7.5), profileSize/2] )
    {
        rotate( [0, 90, 0] )
        {
            m5ThroughHole( 10 );

            translate( [-1 * (zAxisProfileLength + profileSize), 0, 0] )
            {
                m5ThroughHole( 10);
            }

            translate( [0, -1 * (bfps_yDistanceBetweenBolts + 10), 0] )
            {
                m5ThroughHole( 10);
            }

            translate( [-1 * (zAxisProfileLength + profileSize), -1 * (bfps_yDistanceBetweenBolts + 10), 0] )
            {
                m5ThroughHole( 10);
            }
        }
    }
}

module psuInternalMountHoles()
{
    translate( [-3.1, yAxisProfileLength - (profileSize + bfps_yOutsideBuffer + bfps_yBoltDistanceFromEnd), profileSize - (bf_wallThickness + 0.4) - bfps_topBuffer + bfps_yBoltDistanceFromBottom] )
    {
        rotate( [0, 90, 0] )
        {
            m4ThroughHole_duplicate( height = 40 );
            m4Head_duplicate( height = 9.2 );

            translate( [-1 * bfps_zDistanceBetweenBolts, 0, 0] )
            {
                m4ThroughHole_duplicate( height = 40 );
                m4Head_duplicate( height = 9.2 );
            }

            translate( [0, -1 * bfps_yDistanceBetweenBolts, 0] )
            {
                m4ThroughHole_duplicate( height = 40 );
                m4Head_duplicate( height = 9.2 );
            }

            translate( [-1 * bfps_zDistanceBetweenBolts, -1 * bfps_yDistanceBetweenBolts, 0] )
            {
                m4ThroughHole_duplicate( height = 40 );
                m4Head_duplicate( height = 9.2 );
            }
        }
    }
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
    translate( [-1, -5, bfc_yWallHeight - profileSize + 0.8] )
    {
        // give 5mm of extra space in each direction on the Y axis to allow the towers to move a little
        cube( [bf_wallThickness + 30, pieceDepth + 10.2, profileSize - 0.8] );
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
        // The dimensions of a real fan for fit
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
