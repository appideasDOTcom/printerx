// THIS PART IS NOW OBSOLETE
/**
 * Modified a part from this: https://www.thingiverse.com/thing:2791727 (NOTE: This URL improperly lists a "CC non-commercial license," but that piece 
 *   is derived from Prusa's GPL'd code and model. Derivative works of GPL'd material cannot add a "non-commercial" restriction.)
 *
 * I needed to add 6mm of additional clearance to the Y carriage to clear the printer's custom towers.
 * I added 8mm so that I could use common M3x20mm bolts.
 * I had some of these (and those of the original design) develop a single crack when printed in ABS, so I recommend PETG. They
 *    seem to function without problems with the crack, but it was a concern, so I switched to PETG.
 * 
 **/ 

$fa = 1;
$fs = 0.1;

extraHeight = 8;
cornerDiameter = 4;

pieceWidth = 35;
pieceHeight = 29;

throughHoleDiameter = 4.6;
throughHoleOffset = 5.5;
boltlength = 20;

difference()
{
    {
        union()
        {
            import( "thirdparty/Igus_holder_15mm.stl" );
            extraBase();
        }
    }
    {
        throughHoles();
    }
}

module extraBase()
{
    hull()
    {
        {

        }
        {
            union()
            {
                translate( [(cornerDiameter/2), 0, (cornerDiameter/2)] )
                {
                    rotate( [90, 0, 0] )
                    {
                        cylinder( d = cornerDiameter, h = extraHeight );
                    }
                }

                translate( [pieceWidth - (cornerDiameter/2), 0, (cornerDiameter/2)] )
                {
                    rotate( [90, 0, 0] )
                    {
                        cylinder( d = cornerDiameter, h = extraHeight );
                    }
                }

                translate( [(cornerDiameter/2), 0, pieceHeight - (cornerDiameter/2)] )
                {
                    rotate( [90, 0, 0] )
                    {
                        cylinder( d = cornerDiameter, h = extraHeight );
                    }
                }

                translate( [pieceWidth - (cornerDiameter/2), 0, pieceHeight - (cornerDiameter/2)] )
                {
                    rotate( [90, 0, 0] )
                    {
                        cylinder( d = cornerDiameter, h = extraHeight );
                    }
                }
            }
        }
    }
}

module throughHoles()
{
    translate( [throughHoleOffset, 8, throughHoleOffset] )
    {
        rotate( [90, 0, 0] )
        {
            cylinder( d = throughHoleDiameter, h= boltlength );
        }
    }

    translate( [pieceWidth - throughHoleOffset, 8, throughHoleOffset] )
    {
        rotate( [90, 0, 0] )
        {
            cylinder( d = throughHoleDiameter, h= boltlength );
        }
    }

    translate( [throughHoleOffset, 8, pieceHeight - throughHoleOffset] )
    {
        rotate( [90, 0, 0] )
        {
            cylinder( d = throughHoleDiameter, h= boltlength );
        }
    }

    translate( [pieceWidth - throughHoleOffset, 8, pieceHeight - throughHoleOffset] )
    {
        rotate( [90, 0, 0] )
        {
            cylinder( d = throughHoleDiameter, h= boltlength );
        }
    }
}