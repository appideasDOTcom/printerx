/* 
Minor modification to this otherwise good carriage mount so that I can mount a Nema motor directly
      to the carriage plate without an adapter

      -- OK, well. There is an adapter now, but it's just because I thought this was better than 
             cutting a bolt to the cirrect length
*/

/* Render quality variables */
$fa = 1;
$fs = 0.1;

distanceBetweenThroughHoles = 31;
yOffset = 10;

supportDepth = 5.4;
supportWidth = 42;
supportHeight = 42;
cornerDiameter = 4;

integratedSupportHeight = 10;

nemaHoleOffset = 5.5;

translate( [0, -0.5, yOffset + 0.1] )
{
    integratedSpacerPlate();
}
xCarriage();
//spacerPlate();

module xCarriage()
{
    difference()
    {
        {
            import( "thirdParty/X-Carriage-mod.stl" );
        }
        {
            union()
            {
                translate( [-1 * (distanceBetweenThroughHoles/2), yOffset, -1] )
                {
                    m3ThroughHole();

                    translate( [0, 0, 5.7] )
                    {
                        m3HeadCutout();
                    }
                }
                translate( [(distanceBetweenThroughHoles/2), yOffset, -1] )
                {
                    m3ThroughHole();
                    translate( [0, 0, 5.7] )
                    {
                        m3HeadCutout();
                    }
                }
            }
        }
    }
}

module integratedSpacerPlate()
{
    difference()
    {
        {
            translate( [-1 * (supportWidth/2), 5.25, -1 * supportDepth] )
            {
                hull()
                {
                    {
                        translate( [(cornerDiameter/2), (cornerDiameter/2), 0] )
                        {
                            cube( [supportWidth - cornerDiameter, integratedSupportHeight - cornerDiameter, supportDepth] );
                        }
                    }
                    {
                        union()
                        {
                            translate( [(cornerDiameter/2), (cornerDiameter/2), 0] )
                            {
                                cylinder( d = cornerDiameter, h = supportDepth);
                            }

                            translate( [(cornerDiameter/2), integratedSupportHeight - (cornerDiameter/2), 0] )
                            {
                                cylinder( d = cornerDiameter, h = supportDepth);
                            }

                            translate( [supportWidth - (cornerDiameter/2), (cornerDiameter/2), 0] )
                            {
                                cylinder( d = cornerDiameter, h = supportDepth);
                            }

                            translate( [supportWidth - (cornerDiameter/2), integratedSupportHeight - (cornerDiameter/2), 0] )
                            {
                                cylinder( d = cornerDiameter, h = supportDepth);
                            }
                        }
                    }
                }
            }
        }
        {
            translate( [-1 * (distanceBetweenThroughHoles/2), 5 + nemaHoleOffset, -10] )
            {
                m3ThroughHole();
            }
            translate( [(distanceBetweenThroughHoles/2), 5 + nemaHoleOffset, -10] )
            {
                m3ThroughHole();
            }
        }
    }
}


module spacerPlate()
{
    difference()
    {
        {
            translate( [-1 * (supportWidth/2), 5, -1 * supportDepth] )
            {
                hull()
                {
                    {
                        translate( [(cornerDiameter/2), (cornerDiameter/2), 0] )
                        {
                            cube( [supportWidth - cornerDiameter, supportHeight - cornerDiameter, supportDepth] );
                        }
                    }
                    {
                        union()
                        {
                            translate( [(cornerDiameter/2), (cornerDiameter/2), 0] )
                            {
                                cylinder( d = cornerDiameter, h = supportDepth);
                            }

                            translate( [(cornerDiameter/2), supportHeight - (cornerDiameter/2), 0] )
                            {
                                cylinder( d = cornerDiameter, h = supportDepth);
                            }

                            translate( [supportWidth - (cornerDiameter/2), (cornerDiameter/2), 0] )
                            {
                                cylinder( d = cornerDiameter, h = supportDepth);
                            }

                            translate( [supportWidth - (cornerDiameter/2), supportHeight - (cornerDiameter/2), 0] )
                            {
                                cylinder( d = cornerDiameter, h = supportDepth);
                            }
                        }
                    }
                }
            }
        }
        {
            translate( [-1 * (distanceBetweenThroughHoles/2), 5 + nemaHoleOffset, -10] )
            {
                m3ThroughHole();
            }
            translate( [(distanceBetweenThroughHoles/2), 5 + nemaHoleOffset, -10] )
            {
                m3ThroughHole();
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