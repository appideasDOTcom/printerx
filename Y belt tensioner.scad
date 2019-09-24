
/**
 * A custom Y axis idler tensioner for my 3D printer build. 
 * This is based on an excellent design (as far as Y axis belt tensioners go). It fits on any 20x<whatever> (2020, 2040, 2060...) V-Slot or T-Slot profile.
 *
 * Based on this design: https://www.thingiverse.com/thing:2140441
 * But completely constructed from scratch in OpenSCAD for my purposes.
 * This was made to use the Y Belt Idler from the URL above.
 * I Made the tensioner independent from the Y axis linear motion rod holders so that it's not specific to a Prusa printer - or a clone 
 *   with exactly 140mm between its Y axis linear motion rails. This also makes the idler position adjustable, unlike the origingal piece. This 
 *   will work for those specific printers too, but also for every other printer that has a 2020/2040/2060... rail hanging out at the end of the 
 *   printer.
 *
 */

// Render quality: Minimum angle
$fa = 1;
// Render quality: Minimu size
$fs = 0.1;

// Uncomment this to view/print the idler arm. My intention was that the idler arm should be gotten from the original files at Thingiverse (link above)
// import( "thirdparty/Prusa_Y_Belt_Idler.stl" );

bodyWidth = 58;
bodyDepth = 20;
bodyHeight = 17;

cutoutPerimeter = 10.5;
cutoutDepth = 16;

throughHoleDiameter = 3.45;
retainerBoltXOffset = 18;

cornerHeight = 10;
cornerLength = 5;

// Construct the unit
difference()
{
    {
        body();
    }
    {
        union()
        {
            cutout();
            translate( [retainerBoltXOffset, (bodyDepth/2), 0] )
            {
                m5Cutout();
            }
            translate( [(-1 * retainerBoltXOffset), (bodyDepth/2), 0] )
            {
                m5Cutout();
            }
        }
    }
}




module cutout()
{
    union()
    {
        {
            translate( [(-1 * (cutoutPerimeter/2)), -0.1, 1] )
            {
                cube( [cutoutPerimeter, cutoutDepth + 0.1, cutoutPerimeter] );
            }
        }
        {
            translate( [0, cutoutDepth + 10 - 0.1, 1 + (cutoutPerimeter/2)] )
            {
                rotate( [90, 0, 0] )
                {
                    cylinder( d=throughHoleDiameter, h=10 );
                }
            }
        }
    }
}

module body()
{
    hull()
    {
        {
            translate( [(-1 * ((bodyWidth/2) - (cornerLength))), 0, 0] )
            {
                cube( [(bodyWidth - (cornerLength*2)), bodyDepth, bodyHeight] );
            }
        }
        {
            union()
            {
                translate( [((bodyWidth/2) - cornerLength), 0, 0] )
                {
                    cube( [cornerLength, bodyDepth, cornerHeight] );
                }
                translate( [(-1 * (bodyWidth/2)), 0, 0] )
                {
                    cube( [cornerLength, bodyDepth, cornerHeight] );
                }
            }
        }
    }



}

module m5Cutout()
{
    m5ThroughHoleDiameter = 5.5;
    m5ThroughHoleHeight = 4.5;
    m5HeadDiameter = 9;

    translate( [0, 0, -0.1] )
    {
        cylinder( d=m5ThroughHoleDiameter, h=(m5ThroughHoleHeight + 0.2) );
    }
    translate( [0, 0, m5ThroughHoleHeight] )
    {
        cylinder( d=m5HeadDiameter, h=(bodyHeight - m5ThroughHoleHeight + 0.1));
    }
}