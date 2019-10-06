/* 
Minor modification to this otherwise good carriage mount so that I can mount a Nema motor directly
      to the carriage plate without an adapter
*/

/* Render quality variables */
$fa = 1;
$fs = 0.1;

distanceBetweenThroughHoles = 31;
yOffest = 10;

difference()
{
    {
        import( "thirdParty/X-Carriage-mod.stl" );
    }
    {
        translate( [-1 * (distanceBetweenThroughHoles/2), yOffest, -1] )
        {
            m3ThroughHole();

            translate( [0, 0, 5.7] )
            {
                m3HeadCutout();
            }
        }
        translate( [(distanceBetweenThroughHoles/2), yOffest, -1] )
        {
            m3ThroughHole();
            translate( [0, 0, 5.7] )
            {
                m3HeadCutout();
            }
        }
    }
}

module m3ThroughHole()
{
    cylinder( d=3.5, h=20, center=false );
}

module m3HeadCutout()
{
    cylinder( h = 20, d = 6.5 );
}