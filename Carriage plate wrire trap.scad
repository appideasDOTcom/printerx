

// Render quality
$fa = 1;
$fs = 0.1;


buildPlateXY = 219;
buildPlateZ = 3.3; // A little bigger than reality to add a little tolerance

throughHoleDiameter = 3.4;
throughHoleEndOffset = 5;

nutDepth = 2.5;
nutDiameter = 6.6;
boltHeadDiameter = 6;

topThickness = 2;
elbowThickness = 3;
bottomThickness = nutDepth + 2;

pieceDepth = 12;
pieceWidth = 27;

baseX = pieceWidth;
baseY = pieceDepth + elbowThickness;
baseZ = bottomThickness + buildPlateZ + topThickness;

pieceOffsetX = (pieceWidth/2);

shelfNeckThickness = 7;
shelfNeckWidth = 12;
shelfNeckLength = 7;

shelfCutouEdgeDiameter = 7;

tiedownWidth = 14;


shelfLength = 45;
shelfWidth = 15;

cornerDiameter = 4;





// simulatedCarriagePlate();
base();
shelf();


module shelf()
{
    translate( [(pieceWidth/2) - shelfNeckWidth, elbowThickness, -1 * bottomThickness] )
    {
        cube( [shelfNeckWidth, shelfNeckLength, shelfNeckThickness] );
        
        translate( [(-1 * shelfLength) + shelfNeckWidth, shelfNeckLength, (shelfCutouEdgeDiameter/2)] )
        {
            cutoutSupport();
            difference()
            {
                {
                    hull()
                    {
                        {

                        }
                        {
                            rotate( [0, 90, 0] )
                            {
                                cylinder( d = shelfCutouEdgeDiameter, h = shelfLength );
                            }

                            translate( [0, shelfWidth, 0] )
                            {
                                rotate( [0, 90, 0] )
                                {
                                    cylinder( d = shelfCutouEdgeDiameter, h = shelfLength );
                                }
                            }
                        }
                    }
                    

                }
                {
                    translate( [-0.1, shelfWidth/2 + 0.5, 4.5 ] )
                    {
                        scale( [1, 1.4, 1.05] )
                        {
                            rotate( [0, 90, 0] )
                            {
                                cylinder( d = shelfWidth/1.3,  h = shelfLength + 0.2 );
                            }
                        }
                    }
                    translate( [3, -1 * (shelfCutouEdgeDiameter/2) - 0.1, (-1 * bottomThickness) + 4] )
                    {
                        cube( [tiedownWidth, shelfWidth + (shelfCutouEdgeDiameter) +  0.2, shelfCutouEdgeDiameter - 2] );
                    }
                }
            }
            
        }
    }
}

module cutoutSupport()
{
    supportWidth = 0.2;
    translate( [3, -0.17, 0] )
    {
        cube( [tiedownWidth, supportWidth, 3.49] );
    }

    translate( [3, -0.17, 0] )
    {
        rotate( [60, 0, 0] )
        {
            cube( [tiedownWidth, supportWidth, 3.35] );
        }
    }

    translate( [3, shelfWidth + 0.95, -0.18] )
    {
        cube( [tiedownWidth, supportWidth, 3.49] );
    }

    translate( [3, shelfWidth + 0.95, -0.18] )
    {
        rotate( [-60, 0, 0] )
        {
            cube( [tiedownWidth, supportWidth, 2.66] );
        }
    }
}

module base()
{
    difference()
    {
        {
            translate( [-1 * pieceOffsetX, -1 * pieceDepth, -1 * bottomThickness] )
            {
                cube( [baseX, baseY, baseZ] );
            }
        }
        {
            union()
            {
                    translate( [0, -1 * throughHoleEndOffset, (-1 * nutDepth) - 2.1] )
                    {
                        m3Nut();
                    }

                    translate( [0, -1 * throughHoleEndOffset, -10] )
                    {
                        m3ThroughHole( height = 20 );
                    }

                    translate( [0, -1 * throughHoleEndOffset, (buildPlateZ + topThickness - 1)] )
                    {
                        m3Head( height = 3 );
                    }
                    simulatedCarriagePlate();
            }
        }
    }
}


// I'm not bothering with cutouts or most of the through-holes - just what I need for this piece
module simulatedCarriagePlate()
{
    difference()
    {
        {
            translate( [-1 * (buildPlateXY/2), -1 * buildPlateXY, 0] )
            {
                cube( [buildPlateXY, buildPlateXY, buildPlateZ] );
            }
        }
        {
            translate( [0, -1 * throughHoleEndOffset, -0.1] )
            {
                m3ThroughHole( height = (buildPlateZ + 0.2) );
            }
        }
    }
}

module m3ThroughHole( height )
{
    cylinder( d = throughHoleDiameter, h = height );
}

module m3Nut()
{
     cylinder( d = nutDiameter, h = (nutDepth + 0.2), $fn = 6 );
}

module m3Head( height )
{
     cylinder( d = boltHeadDiameter, h = height, $fn = 128 );
}