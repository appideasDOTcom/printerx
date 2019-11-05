/**
* Nobody's made a properly sized Y axis carriage bearing mount for an RJ4JP bearing on a Prusa i3/MK2 style Y carriage
*
* Several people claimed to have made such a thing, but none of them that I have found got it right.

Despite the marketing claims, RJ4JP bearings are NOT a direct drop-in replacement for LM8UU or other bearings with a
  15mm outer diameter and 8mm inner diameter. They require a small amount of clamping force to properly squeeze into
  position. Igus needs to stop marketing them as direct replacements, and people need to stop treating them as such!
*/ 

use <Shared-modules.scad>

// Render quality settings
$fa = 1;
$fs = 0.1;

bearingOuterDiameter = 15.0;
retainerShell = 2.5;
shellDiameter = bearingOuterDiameter + (retainerShell * 2);

// bearingLength = 23.9; // The manufacturer's documentation lies about this measurement. It's actually 23.7, not 24.0. Adding a little for tolerance.

xDistanceBetweenBolts = 24;
yDistanceBetweenBolts = 18;

//how much base to add around the bolt throughholes
pieceMargin = 5.5;

baseXDimension = xDistanceBetweenBolts + (pieceMargin * 2);
baseYDimension = yDistanceBetweenBolts + (pieceMargin * 2);

// For printerx, these need a little more height to lift them over our SK8 toweks
baseZDimension = 13; // The height of the base

// This is the thing that's always wrong in other models. You gotta clamp these things the proper amount
distanceBetweenTrapRings = 15.3;
// This is the thing that's always wrong in other models. You gotta clamp these bearings a little.
trapRingDepth = 0.4; // 0.325 is the documented measurement, We want to clamp a little
trapRingWidth = 1; // 1.1mm is the documented measurement

cutoutDistanceToEnd = (((baseYDimension - distanceBetweenTrapRings)/2) + 1) - trapRingWidth;

retainerReliefAmount = 3.5;// cut a slot into the top of the retainer

cornerDiameter = 4;
nutDepth = 3;

difference()
{
    {
        union()
        {
            base();
            // This originally sat above the base, but that's not necessary
            translate( [0, 0, -1 * retainerShell] )
            {
                bearingRetainer();
            }

        }
    }
    {
        cutouts();
    }
}

// bearingCutout();

module bearingRetainer()
{
    difference()
    {
        {
            bearingBody();
        }
        {
            bearingCutout();
        }
    }
}


module bearingBody()
{
    translate( [xDistanceBetweenBolts/2, baseYDimension - pieceMargin, baseZDimension + (bearingOuterDiameter/2) + (retainerShell)] )
    {
        hull()
        {
            {
                rotate( [90, 0, 0] )
                {
                    cylinder( d = shellDiameter, h = baseYDimension );
                }
            }
            {
                union()
                {
                    translate( [ (bearingOuterDiameter/2), -1 * (cornerDiameter/2), -1 * (bearingOuterDiameter/2) - 3 ] )
                    {
                        cylinder( d = cornerDiameter, h = 5 );
                    }

                    translate( [ -1 * (bearingOuterDiameter/2), -1 * (cornerDiameter/2), -1 * (bearingOuterDiameter/2) - 3 ] )
                    {
                        cylinder( d = cornerDiameter, h = 5 );
                    }

                    translate( [ (bearingOuterDiameter/2), -1 * baseYDimension + (cornerDiameter/2), -1 * (bearingOuterDiameter/2) - 3 ] )
                    {
                        cylinder( d = cornerDiameter, h = 5 );
                    }

                    translate( [ -1 * (bearingOuterDiameter/2), -1 * baseYDimension + (cornerDiameter/2), -1 * (bearingOuterDiameter/2) - 3 ] )
                    {
                        cylinder( d = cornerDiameter, h = 5 );
                    }
                }
            }
        }
    }
}

module bearingCutout()
{
    union()
    {
        // The base cutout. Runs the hole distance of the piece and is trapRingDepth less in diameter than the main part that gets cutout
        translate( [(pieceMargin/2) + (bearingOuterDiameter/2) + (retainerShell/2) + 0.75, baseYDimension - pieceMargin + 1, baseZDimension + (bearingOuterDiameter/2) + (retainerShell/1)] )
        {
            rotate( [90, 0, 0] )
            {
                // thinner inner cylinder to create the face of the retainer ring
                cylinder( d = bearingOuterDiameter - (trapRingDepth * 2), h = baseYDimension + 2 );

                // main bearing retainer area
                translate( [0, 0, (baseYDimension/2) - (distanceBetweenTrapRings/2) + 1] )
                {
                    cylinder( d = bearingOuterDiameter, h = distanceBetweenTrapRings );
                }

                cylinder( d = bearingOuterDiameter, h = cutoutDistanceToEnd );

                translate( [0, 0, baseYDimension - cutoutDistanceToEnd + 2] )
                {
                    cylinder( d = bearingOuterDiameter, h = cutoutDistanceToEnd );
                }

            }
        }
    }
}

module cutouts()
{
    union()
    {
        throughHoles();
        nutTraps();
        rotate( [0, 0, 90] )
        {
            retainerRelief();
        }
    }
}


module retainerRelief()
{
    translate( [-1 * pieceMargin - 1, -1 * ((retainerReliefAmount/2) + (xDistanceBetweenBolts/2)), baseZDimension + 8] )
    {
        cube( [baseXDimension + 2, retainerReliefAmount, 20] );
    }
}

module base()
{
    hull()
    {
        {
            translate( [-1 * pieceMargin + (cornerDiameter/2), -1 * pieceMargin + (cornerDiameter/2), 0] )
            {
                cube( [baseXDimension - cornerDiameter, baseYDimension - cornerDiameter, baseZDimension] );
            }

        }
        {
            union()
            {
                translate( [-1 * pieceMargin + (cornerDiameter/2), -1 * pieceMargin + (cornerDiameter/2), 0] )
                {
                    cylinder( d = cornerDiameter, h = baseZDimension );
                }

                translate( [-1 * pieceMargin - (cornerDiameter/2) + baseXDimension, -1 * pieceMargin + (cornerDiameter/2), 0] )
                {
                    cylinder( d = cornerDiameter, h = baseZDimension );
                }

                translate( [-1 * pieceMargin + (cornerDiameter/2), -1 * pieceMargin - (cornerDiameter/2) + baseYDimension, 0] )
                {
                    cylinder( d = cornerDiameter, h = baseZDimension );
                }

                translate( [-1 * pieceMargin - (cornerDiameter/2) + baseXDimension, -1 * pieceMargin - (cornerDiameter/2) + baseYDimension, 0] )
                {
                    cylinder( d = cornerDiameter, h = baseZDimension );
                }
            }
        }
    }
}

module nutTraps()
{
    extraNutTrapHeight = 4;
    union()
    {
            translate( [0, 0, baseZDimension - nutDepth] )
            {
                m4Nut( nutDepth + extraNutTrapHeight );
            }

            translate( [xDistanceBetweenBolts, 0, baseZDimension - nutDepth] )
            {
                m4Nut( nutDepth + extraNutTrapHeight );
            }

            translate( [0, yDistanceBetweenBolts, baseZDimension - nutDepth] )
            {
                m4Nut( nutDepth + extraNutTrapHeight );
            }

            translate( [xDistanceBetweenBolts, yDistanceBetweenBolts, baseZDimension - nutDepth] )
            {
                m4Nut( nutDepth + extraNutTrapHeight );
            }
    }
}


module throughHoles()
{
    union()
    {
        translate( [0, 0, -1] )
        {
            m4ThroughHole( baseZDimension + 2 );
        }

        translate( [xDistanceBetweenBolts, 0, -1] )
        {
            m4ThroughHole( baseZDimension + 2 );
        }

        translate( [0, yDistanceBetweenBolts, -1] )
        {
            m4ThroughHole( baseZDimension + 2 );
        }

        translate( [xDistanceBetweenBolts, yDistanceBetweenBolts, -1] )
        {
            m4ThroughHole( baseZDimension + 2 );
        }
    }
}