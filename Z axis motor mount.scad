
$fa = 1;
$fs = 0.1;


pieceWidth = 42;
distanceBetweenBolts = 31;
pieceThickness = 4;
throughHoleDiameter = 3.4;
cornerDiameter = 4;
extraLength = 22;

extrusionHeight = 20;
neckWidth = 12;

m5ThroughHoleDiameter = 5.6;
m5HeadDiameter = 10;

motorShaftCutoutDiameter = 25;


baseplate();
extension();


module extension()
{
    difference()
    {
        {
            union()
            {
                translate( [(-1 * extraLength), 0, 0] )
                {
                    cube( [extraLength, pieceWidth, pieceThickness] );
                }
                translate( [(-1 * extraLength), 0, pieceThickness] )
                {
                    cube( [neckWidth, pieceWidth, extrusionHeight] );
                }
                translate( [0, 0, pieceThickness] )
                {
                    hull()
                    {
                        {
                            translate( [(-1 * extraLength) - extrusionHeight, 0, extrusionHeight] )
                            {
                                cube( [extrusionHeight + neckWidth - (pieceThickness/2), pieceWidth, pieceThickness] );
                            }

                        }
                        {
                            union()
                            {
                                rotate( [90, 0, 0] )
                                {
                                    translate( [(-1 * extraLength) + neckWidth - (pieceThickness/2), extrusionHeight + (pieceThickness/2) , -1 * pieceWidth] )
                                    {
                                        cylinder( d = pieceThickness, h = pieceWidth  );
                                    }
                                }
                                rotate( [90, 0, 0] )
                                {
                                    translate( [(-1 * extraLength) + neckWidth - (pieceThickness/2), extrusionHeight, -1 * pieceWidth] )
                                    {
                                    cube( [pieceThickness/2, pieceThickness/2 , pieceWidth] );
                                    }
                                }
                            }
                        }
                    }
                }

                translate( [-1 * (extraLength) + neckWidth + (pieceThickness/2), 0, pieceThickness + (pieceThickness/2)] )
                {
                    rotate( [-90, 270, 0] )
                    {
                        essCurve( d = pieceThickness, h = pieceWidth );
                    }
                }
            }
        }
        {
            m5ThroughHoles();
        }
    }
    
}

module m5ThroughHoles()
{
    union()
    {
        translate( [-1 * (extraLength) - 0.1, 10, (extrusionHeight/2) + pieceThickness] )
        {
            rotate( [0, 90, 0] )
            {
                cylinder( d= m5ThroughHoleDiameter, h = 15);
            }
        }
        translate( [-1 * (extraLength) - 0.1, pieceWidth - 10, (extrusionHeight/2) + pieceThickness] )
        {
            rotate( [0, 90, 0] )
            {
                cylinder( d= m5ThroughHoleDiameter, h = 15);
            }
        }

        translate( [-1 * (extraLength) + 2, 10, (extrusionHeight/2) + pieceThickness] )
        {
            rotate( [0, 90, 0] )
            {
                cylinder( d= m5HeadDiameter, h = 10.1);
            }
        }
        translate( [-1 * (extraLength) + 2, pieceWidth - 10, (extrusionHeight/2) + pieceThickness] )
        {
            rotate( [0, 90, 0] )
            {
                cylinder( d= m5HeadDiameter, h = 10.1);
            }
        }


        translate( [-1 * (extraLength) - (extrusionHeight/2), 10, extrusionHeight] )
        {
            cylinder( d= m5ThroughHoleDiameter, h = 15);
        }

        translate( [-1 * (extraLength) - (extrusionHeight/2), pieceWidth - 10, extrusionHeight] )
        {
            cylinder( d= m5ThroughHoleDiameter, h = 15);
        }

        translate( [-1 * (extraLength) - (extrusionHeight/2), 10, extrusionHeight + (pieceThickness * 2) - 2 ] )
        {
            cylinder( d= m5HeadDiameter, h = 10);
        }
        translate( [-1 * (extraLength) - (extrusionHeight/2), pieceWidth - 10, extrusionHeight + (pieceThickness*2) - 2] )
        {
            cylinder( d= m5HeadDiameter, h = 10);
        }
    }
}

module baseplate()
{
    difference()
    {
        {
            hull()
            {
                {
                    cube( [pieceWidth - (cornerDiameter/2), pieceWidth, pieceThickness] );
                }
                {
                    union()
                    {
                        translate( [pieceWidth - (cornerDiameter/2), (cornerDiameter/2), 0] )
                        {
                            cylinder( d = cornerDiameter, h = pieceThickness );
                        }
                        translate( [pieceWidth - (cornerDiameter/2), pieceWidth - (cornerDiameter/2), 0] )
                        {
                            cylinder( d = cornerDiameter, h = pieceThickness );
                        }
                    }
                }
            }
        }
        {
            m3ThroughHoles();
            translate( [(pieceWidth/2), (pieceWidth/2), -0.1] )
            {
                cylinder( d = motorShaftCutoutDiameter, h = pieceThickness + 0.2 );
            }
        }
    }
    
}

module m3ThroughHoles()
{
    translate( [(pieceWidth/2) - (distanceBetweenBolts/2), (pieceWidth/2) - (distanceBetweenBolts/2), -0.1] )
    {
        cylinder( d = throughHoleDiameter, h = 10 );
        translate( [0, distanceBetweenBolts, 0] )
        {
            cylinder( d = throughHoleDiameter, h = 10 );
        }
        translate( [distanceBetweenBolts, 0, 0] )
        {
            cylinder( d = throughHoleDiameter, h = 10 );
        }
        translate( [distanceBetweenBolts, distanceBetweenBolts, 0] )
        {
            cylinder( d = throughHoleDiameter, h = 10 );
        }
    }
}

// Create an "S" shaped curve for model strength on what would otherwise be a corner
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