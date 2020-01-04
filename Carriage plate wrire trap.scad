

// Render quality
$fa = 1;
$fs = 0.1;

buildPlateXY = 219;
buildPlateZ = 3.3; // A little bigger than reality to add a little tolerance

throughHoleDiameter = 3.4;
throughHoleEndOffset = 5.1;

nutDepth = 2.5;
nutDiameter = 6.6;
boltHeadDiameter = 6;

topThickness = 3.8;
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
union()
{
    {
        base();
        baseEndcaps();
    }
    {
        difference()
        {
            {
                shelf();
            }
            {
                tieCutout();
            }
        }
    }

}




module shelf()
{
    translate( [-1 * (pieceWidth/2), elbowThickness, -1 * bottomThickness] )
    {
        translate( [pieceWidth - shelfNeckWidth, 0, 0] )
        {
            cube( [shelfNeckWidth, shelfNeckLength, shelfNeckThickness] );

            translate( [0, (cornerDiameter/2), shelfNeckThickness + (cornerDiameter/2)] )
            {
                rotate( [90, 0, 90] )
                {
                    essCurve( d = cornerDiameter, h = shelfNeckWidth );
                }
            }
        }

        
        rotate( [0, 0, 180] )
        {
            translate( [(-1 * shelfLength), -1 * (shelfNeckWidth + shelfNeckLength + (cornerDiameter/2) + 1), (shelfCutouEdgeDiameter/2)] )
            {
                // cutoutSupport();
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
                        
                    }
                }

                // This should print without supports
                shelfEndcaps();

                

                
            }
        }
    }
}

module tieCutout()
{
    // "+7" on the Z brings it to the top of the shelf.
    translate( [1 * (shelfLength - (2 * tiedownWidth) - 3), shelfWidth/2 - 1, (-1 * bottomThickness) + 7 - 4.9] )
    {
        cube( [tiedownWidth, shelfWidth + (shelfCutouEdgeDiameter) +  0.2, shelfCutouEdgeDiameter - 2] );
    }

zipTieWidth = 5;
    translate( [1 * (shelfLength - (2 * tiedownWidth) - 3) - 22.5, shelfWidth/2 - 1, (-1 * bottomThickness) + 7 - 4.9] )
    {
        cube( [zipTieWidth, shelfWidth + (shelfCutouEdgeDiameter) +  0.2, shelfCutouEdgeDiameter - 2] );
    }
}

module baseEndcaps()
{
    translate( [-1 * (baseX/2), -1 * shelfNeckWidth, baseZ - bottomThickness - (topThickness/2)] )
    {
        rotate( [0, 90, 0] )
        {
            cylinder( d = topThickness, h = baseX );
        }
    }

    translate( [-1 * (baseX/2), -1 * shelfNeckWidth, -1 * (bottomThickness/2)] )
    {
        rotate( [0, 90, 0] )
        {
            cylinder( d = bottomThickness, h = baseX );
        }
    }
}

module shelfEndcaps()
{
    rotate( [0, 90, 0] )
    {
        cylinder( d = shelfCutouEdgeDiameter, h = shelfLength );
    }

    translate( [0, shelfNeckWidth + (shelfCutouEdgeDiameter/2) - 0.5, 0] )
    {
        rotate( [0, 90, 0] )
        {
            cylinder( d = shelfCutouEdgeDiameter, h = shelfLength );
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
            hull()
            {
                {
                    translate( [-1 * pieceOffsetX, -1 * pieceDepth, -1 * bottomThickness] )
                    {
                        cube( [baseX, baseY - (topThickness/2), baseZ] );
                    }
                }
                {
                    translate( [-1 * (baseX/2),  1.1, baseZ - bottomThickness - (cornerDiameter/2) + 0.1] )
                    {
                        rotate( [0, 90, 0] )
                        {
                            cylinder( d = topThickness, h = baseX);
                        }
                    }

                    translate( [-1 * (baseX/2), -1.5, -1 * (bottomThickness) ] )
                    {
                        cube( [baseX, bottomThickness, bottomThickness] );
                    }
                }
            }

        }
        {
            union()
            {
                m3HeadDepth = 2.8;

                    translate( [0, -1 * throughHoleEndOffset, (shelfNeckThickness + 0.1) - nutDepth] )
                    {
                        m3Nut();
                    }

                    translate( [0, -1 * throughHoleEndOffset, -10] )
                    {
                        m3ThroughHole( height = 20 );
                    }


                    translate( [0, -1 * throughHoleEndOffset, -7.5 + m3HeadDepth ] )
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

module essCurve( d, h )
{
  xDimension = d;
  yDimension = d;
  zDimension = h;

  difference()
    {
      {
        translate( [(-1 * (xDimension / 2)), (-1 * (yDimension / 2)), 0] )
        {
          cube( [xDimension, yDimension, zDimension] );
        }
      }
      {
        translate( [ 0, 0, -1 ] )
        {
          translate( [0, (-1 * yDimension), 0] )
          {
            cube( [xDimension, yDimension * 2, (zDimension + 2)] );
          }
          translate( [(-1 * xDimension), 0, 0] )
          {
            cube( [xDimension, yDimension, (zDimension + 2)] );
          }

          linear_extrude( height=(zDimension + 2), twist=0, scale=[1, 1], center=false)
          {
            $fn=64;    //set sides to 64
            circle(r=(xDimension / 2));
          }
          
        }

      }
    
  }
}