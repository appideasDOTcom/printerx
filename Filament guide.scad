
include <Z axis motor mount.scad>

extraCutout = 0.4;

wingWidth = 10;
filamentHolderWidth = (pieceWidth + wallthickness) + (wingWidth * 2);

filamentNeckWidth = 18;
filamentNeckLength = 60;

extraNeck = 4;

filamentBodyDiameter = 12;
filamentBodyWidth = 40;
filamentRimWidth = 4;
filamentRimDiameter = (filamentBodyDiameter - (filamentRimWidth * 2));

difference()
{
    {
        union()
        {
            filamentBase();
            filamentNeck();
            filamentBody();
        }
    }
    {
        filamentBaseCutout();
        filamentThroughHoles();
        // TODO: M5 through-holes

    }
}


module filamentBody()
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
                        translate( [-1 * (extraLength + extrusionHeight + filamentNeckLength + (filamentBodyDiameter/2)) - (cornerDiameter/2), wallthickness + (extrusionHeight/2) + (filamentNeckWidth/2) - (wallthickness/2) + (filamentBodyWidth/2), extrusionHeight + pieceThickness] )
                        {
                            cylinder( d = filamentBodyDiameter, h = pieceThickness );
                        }

                        translate( [-1 * (extraLength + extrusionHeight + filamentNeckLength + (filamentBodyDiameter/2)) - (cornerDiameter/2), wallthickness + (extrusionHeight/2) + (filamentNeckWidth/2) - (wallthickness/2) - (filamentBodyWidth/2), extrusionHeight + pieceThickness] )
                        {
                            cylinder( d = filamentBodyDiameter, h = pieceThickness );
                        }
                    }
                }
            }
        }
        {
            hull()
            {
                {

                }
                {
                    translate( [-1 * filamentRimWidth, 0, -0.1] )
                    {
                        union()
                        {
                            translate( [-1 * (extraLength + extrusionHeight + filamentNeckLength + (filamentRimDiameter/2)) - (cornerDiameter/2), wallthickness + (extrusionHeight/2) + (filamentNeckWidth/2) - (wallthickness/2) + (filamentBodyWidth/2), extrusionHeight + pieceThickness] )
                            {
                                cylinder( d = filamentRimDiameter, h = pieceThickness + 0.2 );
                            }

                            translate( [-1 * (extraLength + extrusionHeight + filamentNeckLength + (filamentRimDiameter/2)) - (cornerDiameter/2), wallthickness + (extrusionHeight/2) + (filamentNeckWidth/2) - (wallthickness/2) - (filamentBodyWidth/2), extrusionHeight + pieceThickness] )
                            {
                                cylinder( d = filamentRimDiameter, h = pieceThickness + 0.2 );
                            }
                        }
                    }
                }
            }

        }

    }



}

module filamentThroughHoles()
{
    translate( [-1 * (extraLength) - (extrusionHeight/2), -8, extrusionHeight] )
    {
        cylinder( d= m5ThroughHoleDiameter, h = 15);
    }

    // translate( [-1 * (extraLength) - (extrusionHeight/2), -8, extrusionHeight + (pieceThickness * 2) - 2 ] )
    // {
    //     cylinder( d= m5HeadDiameter, h = 10);
    // }

    translate( [-1 * (extraLength) - (extrusionHeight/2), 47, extrusionHeight] )
    {
        cylinder( d= m5ThroughHoleDiameter, h = 15);
    }

    // translate( [-1 * (extraLength) - (extrusionHeight/2), 47, extrusionHeight + (pieceThickness * 2) - 2 ] )
    // {
    //     cylinder( d= m5HeadDiameter, h = 10);
    // }
}


module filamentNeck()
{
    translate( [-1 * (extraLength + extrusionHeight) - (filamentNeckLength + (cornerDiameter/2)) - extraNeck, (extrusionHeight/2) + (wallthickness/2), extrusionHeight + pieceThickness] )
    {
        union()
        {
            cube( [filamentNeckLength, filamentNeckWidth, pieceThickness] );

            translate( [filamentNeckLength - (pieceThickness/2), -1 * (pieceThickness/2), 0] )
            {
                rotate( [0, 0, 180] )
                {
                    essCurve( d = pieceThickness, h = pieceThickness );
                }
            }

            translate( [(pieceThickness/2) + cornerDiameter, -1 * (pieceThickness/2), 0] )
            {
                rotate( [0, 0, -90] )
                {
                    essCurve( d = pieceThickness, h = pieceThickness );
                }
            }

            translate( [filamentNeckLength - (pieceThickness/2), filamentNeckWidth + (pieceThickness/2), 0] )
            {
                rotate( [0, 0, 90] )
                {
                    essCurve( d = pieceThickness, h = pieceThickness );
                }
            }

            translate( [(pieceThickness/2) + cornerDiameter, filamentNeckWidth + (pieceThickness/2), 0] )
            {
                essCurve( d = pieceThickness, h = pieceThickness );
            }
        }
    }
}


module filamentBaseCutout()
{
    translate( [-1 * (extraLength + extrusionHeight) - (extraCutout/2), -1 * wallthickness - (extraCutout/2), extrusionHeight + pieceThickness  - (extraCutout/2)] )
    {
        cube( [(extrusionHeight + neckWidth) + extraCutout, (pieceWidth + wallthickness) + extraCutout, pieceThickness + extraCutout] );
    }
}

module filamentBase()
{
    translate( [-1 * (extraLength + extrusionHeight) , -1 * wallthickness - wingWidth, extrusionHeight + pieceThickness] )
    {
        hull()
        {
            {
                cube( [extrusionHeight - (cornerDiameter/2), filamentHolderWidth, pieceThickness] );
            }
            {
                union()
                {
                    translate( [-1 * extraNeck, (cornerDiameter/2), 0] )
                    {
                        cylinder( d = cornerDiameter, h = pieceThickness );
                    }

                    translate( [-1 * extraNeck, filamentHolderWidth - (cornerDiameter/2), 0] )
                    {
                        cylinder( d = cornerDiameter, h = pieceThickness );
                    }

                    translate( [extrusionHeight - (cornerDiameter/2), (cornerDiameter/2), 0] )
                    {
                        cylinder( d = cornerDiameter, h = pieceThickness );
                    }

                    translate( [extrusionHeight - (cornerDiameter/2), filamentHolderWidth - (cornerDiameter/2), 0] )
                    {
                        cylinder( d = cornerDiameter, h = pieceThickness );
                    }
                }
            }
        }



    }

    
}