$fa = 1;
$fs = 0.1;

extraHeight = 3;
extraWidth = 2;

difference()
{
    {
        union()
        {
            import( "thirdparty/rod_holder_sk8.STL" );
            extraTop();
            extraSide();
        }
    }
    {
        translate( [10.9, 29.65, 7] )
        {
            union()
            {
                rotate( [0, 90, 0] )
                {
                    m4Nut();
                }
                translate( [14.3, 0, 0] )
                {
                    rotate( [0, 90, 0] )
                    {
                        m4Head();
                    }
                }
            }
        }
    }
}

module extraSide()
{
    sideHeight = 6;
    sideLength = 14;
    unitWidth = 40;

    translate( [(-1 * extraWidth), 0, 0] )
    {
        cube( [extraWidth, sideHeight, sideLength] );
    }
    translate( [unitWidth, 0, 0] )
    {
        cube( [extraWidth, sideHeight, sideLength] );
    }
}

module extraTop()
{
    topWidth = 8.48556;
    topHeight = 14;

    totalTopWidth = 18;
    topGapWidth = ((totalTopWidth/2) - topWidth) * 2;


    translate( [11, 33, 0] )
    {
       cube( [topWidth, extraHeight, topHeight] );
    }
    translate( [11 + topWidth + topGapWidth, 33, 0] )
    {
        cube( [topWidth, extraHeight, topHeight] );
    }
}

module m4Head()
{
    cylinder( h = 3.9, r = 3.6 );
}

module m4Nut()
{
    cylinder( h = 3.0, r = 4.1, $fn=6 );
}

module m4ThroughHole()
{
    cylinder( r=2.5, h=20, center=false );
}