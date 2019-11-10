/**
* Stabilize printerx's Z axis frame to eliminate vibration and allow faster printing without losing quality
*/ 

use <Shared-modules.scad>

// Render quality settings
$fa = 1;
$fs = 0.1;

pieceXDistance = 20; // match the printer frame's rail width
pieceYDistance = 50;
pieceZDistance = 150;

edgeHeight = 15;
cornerDiameter = 4;
outsideBoltShelfDistance = 8;
insideBoltDistance = edgeHeight + 7;

insideEdgeHeight = 7.5;
insideCornerDiameter = 7;


// boundaryPiece();

// TODO: Change inside through-holes to M4

difference()
{
    {
        union()
        {
            mainBody();
            edgePieces();
        }
    }
    {
        union()
        {
            mainCutout();
            throughHoles();
        }
    }
}



module throughHoles()
{
    m4HoleDiameter = 5.6;
    m4HoleEndOffset = 8;
    m4HeadDepth = 7;

    translate( [(pieceXDistance/2), pieceYDistance - m4HoleEndOffset, -1] )
    {
        m4ThroughHole( height = 30 );

        translate( [0, 0, edgeHeight + 1 - m4HeadDepth] )
        {
            m4Head( height = 35 );
        }
    }

    translate( [(pieceXDistance/2), 29, pieceZDistance - m4HoleEndOffset] )
    {
        rotate( [90, 0, 0] )
        {
            m4ThroughHole( height = 30 );
            
            translate( [0, 0, -1 * (edgeHeight + 1) + m4HoleEndOffset] )
            {
                m4Head( height = 30 );
            }
        }
    }

    translate( [(pieceXDistance/2), insideEdgeHeight + 10, -1] )
    {
        m4ThroughHole( height = 30 );

        translate( [0, 0, edgeHeight - 6.2] )
        {
            m4Head( height = 35 );
        }
    }

    translate( [(pieceXDistance/2), 15, insideEdgeHeight + 12] )
    {
        rotate( [90, 0, 0] )
        {
            m4ThroughHole( height = 30 );
        }
    }
    
}

module mainCutout()
{


    hull()
    {
        {

        }
        {
            // bottom part
            union()
            {
                translate( [-0.1, (insideCornerDiameter/2) + insideEdgeHeight, insideEdgeHeight + 30] )
                {
                    rotate( [0, 90, 0] )
                    {
                        cylinder( d = insideCornerDiameter, h = pieceXDistance + 0.2 );
                    }
                }

                translate( [-0.1, (insideCornerDiameter/2) + insideEdgeHeight + 13, insideEdgeHeight + 39] )
                {
                    rotate( [0, 90, 0] )
                    {
                        cylinder( d = insideCornerDiameter, h = pieceXDistance + 0.2 );
                    }
                }

                translate( [-0.1, (insideCornerDiameter/2) + insideEdgeHeight, (insideCornerDiameter/2) + insideEdgeHeight] )
                {
                    rotate( [0, 90, 0] )
                    {
                        cylinder( d = insideCornerDiameter, h = pieceXDistance + 0.2 );
                    }
                }

                translate( [-0.1, (insideCornerDiameter/2) + insideEdgeHeight + 19, (insideCornerDiameter/2) + insideEdgeHeight * 1.6] )
                {
                    rotate( [0, 90, 0] )
                    {
                        cylinder( d = insideCornerDiameter, h = pieceXDistance + 0.2 );
                    }
                }
            }
        }
    }


    // middle
    hull()
    {
        {

        }
        {
            union()
            {

                translate( [-0.1, (insideCornerDiameter/2) + insideEdgeHeight, insideEdgeHeight + 49] )
                {
                    rotate( [0, 90, 0] )
                    {
                        cylinder( d = insideCornerDiameter, h = pieceXDistance + 0.2 );
                    }
                }

                translate( [-0.1, (insideCornerDiameter/2) + insideEdgeHeight + 11, insideEdgeHeight + 56.5] )
                {
                    rotate( [0, 90, 0] )
                    {
                        cylinder( d = insideCornerDiameter, h = pieceXDistance + 0.2 );
                    }
                }


                translate( [-0.1, (insideCornerDiameter/2) + insideEdgeHeight, insideEdgeHeight + 63] )
                {
                    rotate( [0, 90, 0] )
                    {
                        cylinder( d = insideCornerDiameter, h = pieceXDistance + 0.2 );
                    }
                }




            }
        }
    }

    // top
    hull()
    {
        {

        }
        {
            union()
            {

                translate( [-0.1, (insideCornerDiameter/2) + insideEdgeHeight, pieceZDistance - 36] )
                {
                    rotate( [0, 90, 0] )
                    {
                        cylinder( d = insideCornerDiameter, h = pieceXDistance + 0.2 );
                    }
                }

                translate( [-0.1, (insideCornerDiameter/2) + insideEdgeHeight, pieceZDistance - 62] )
                {
                    rotate( [0, 90, 0] )
                    {
                        cylinder( d = insideCornerDiameter, h = pieceXDistance + 0.2 );
                    }
                }

                translate( [-0.1, (insideCornerDiameter/2) + insideEdgeHeight + 8, pieceZDistance - 68] )
                {
                    rotate( [0, 90, 0] )
                    {
                        cylinder( d = insideCornerDiameter, h = pieceXDistance + 0.2 );
                    }
                }
            }
        }
    }
}




module mainBody()
{
    hull()
    {
        {

        }
        {
            union()
            {
                cube( [pieceXDistance, 5, edgeHeight] );

                translate( [0, pieceYDistance - edgeHeight + (cornerDiameter/2), 0] )
                {
                    cube( [pieceXDistance, 5, edgeHeight] );
                }

                translate( [0, 0, pieceZDistance - edgeHeight + (cornerDiameter/2)] )
                {
                    cube( [pieceXDistance, edgeHeight, 5] );
                }
            }
        }
    }
}


// A transparent cube that won't rendeer for printing that can be used to displat the boundaries of the piece
module boundaryPiece()
{
    %cube( [pieceXDistance, pieceYDistance, pieceZDistance] );
}

module edgePieces()
{
    union()
    {
        {
            hull()
            {
                {
                        translate( [0, pieceYDistance - outsideBoltShelfDistance, 0] )
                        {
                            cube( [pieceXDistance, outsideBoltShelfDistance, edgeHeight - (cornerDiameter/2)] );
                        }
                }
                {
                    union()
                    {
                        translate( [0, pieceYDistance - (cornerDiameter/2), edgeHeight - (cornerDiameter/2)] )
                        {
                            rotate( [0, 90, 0] )
                            {
                                cylinder( d = cornerDiameter, h = pieceXDistance );
                            }
                        }

                        translate( [0, pieceYDistance - outsideBoltShelfDistance, edgeHeight - (cornerDiameter/2)] )
                        {
                            rotate( [0, 90, 0] )
                            {
                                cylinder( d = cornerDiameter, h = pieceXDistance );
                            }
                        }
                        translate( [0, pieceYDistance - outsideBoltShelfDistance, (cornerDiameter/2)] )
                        {
                            rotate( [0, 90, 0] )
                            {
                                cylinder( d = cornerDiameter, h = pieceXDistance );
                            }
                        }
                    }
                }
            }
        }
        {
            hull()
            {
                {
                    translate( [0, 0, pieceZDistance - outsideBoltShelfDistance] )
                    {
                        cube( [pieceXDistance, edgeHeight - (cornerDiameter/2), outsideBoltShelfDistance] );
                    }
                }
                {
                    union()
                    {
                        translate( [0, edgeHeight - (cornerDiameter/2), pieceZDistance - outsideBoltShelfDistance] )
                        {
                            rotate( [0, 90, 0] )
                            {
                                cylinder( d = cornerDiameter, h = pieceXDistance );
                            }
                        }

                        translate( [0, (cornerDiameter/2), pieceZDistance - outsideBoltShelfDistance] )
                        {
                            rotate( [0, 90, 0] )
                            {
                                cylinder( d = cornerDiameter, h = pieceXDistance );
                            }
                        }


                        translate( [0, edgeHeight - (cornerDiameter/2), pieceZDistance - (cornerDiameter/2)] )
                        {
                            rotate( [0, 90, 0] )
                            {
                                cylinder( d = cornerDiameter, h = pieceXDistance );
                            }
                        }
                    }
                }
            }
        }
    }

}