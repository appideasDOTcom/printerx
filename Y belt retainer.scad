/**
 * Modified a part from this: https://www.thingiverse.com/thing:2140441 (NOTE: This URL lists a "CC share-alike license")
 *
 * I needed to add clearance to the Y carriage to clear the printer's custom towers.
 * 
 **/ 

$fa = 1;
$fs = 0.1;

extraHeight = 6;

pieceWidth = 55;
pieceHeight = 16;
pieceBottomXOffset = 15.5;

throughHoleDiameter = 3.3;
throughHoleYOffset = ((pieceWidth/2) - 7.3);
throughHoleZOffset = (pieceHeight/2);
boltlength = 20;

difference()
{
    {
        union()
        {
            import( "thirdparty/Prusa_Y_Belt_Holder.stl" );
            extraBase();
        }
    }
    {
        throughHoles();
    }
}

module extraBase()
{
    translate( [(-1 * (pieceBottomXOffset + extraHeight)), (-1 * (pieceWidth/2)), 0] )
    {
        cube( [extraHeight, pieceWidth, pieceHeight] );
    }
}

module throughHoles()
{
    translate( [(-1 * (pieceBottomXOffset + extraHeight)) -1, throughHoleYOffset, throughHoleZOffset] )
    {
        rotate( [0, 90, 0] )
        {
            cylinder( d = throughHoleDiameter, h= boltlength );
        }
    }

    translate( [(-1 * (pieceBottomXOffset + extraHeight)) - 1, (-1 * throughHoleYOffset), throughHoleZOffset] )
    {
        rotate( [0, 90, 0] )
        {
            cylinder( d = throughHoleDiameter, h= boltlength );
        }
    }


}