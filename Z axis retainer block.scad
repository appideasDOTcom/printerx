include <thirdparty/MCAD/bearing.scad>

// Modifications to Prusa's parts require the modifications I've made to the original models, which are in a public 
//    github fork here: https://github.com/appideasDOTcom/Original-Prusa-i3
// include <thirdparty/prusa/Original-Prusa-i3/Printed-Parts/scad/x-end-idler.scad>
include <thirdparty/prusa/Original-Prusa-i3/Printed-Parts/scad/x-end-motor.scad>

/* Render quality variables */
$fa = 1;
$fs = 0.1;
/* END Render quality variables */

/* Global variables */
bearingHeight = 7;
/* END Global variables */

/* Lead screw retainer variables */
leadScrewPostDiameter = 8;
leadScrewPostZOffset = 1;
leadScrewPostHeight = (bearingHeight - leadScrewPostZOffset);

leadScrewCapLowerDiamter = 10.5;
leadScrewCapUpperDiamter = 13.5;
leadScrewCapHeight = 10;

leadScrewCutoutDepth = 8;
leadScrewCutoutDiameter = 8.4;

supportGap = 0.1;
/* END Lead screw retainer variables */

/* Bearing retainer variables */
bearingOuterDiameter = 22.2;
bearingRetainerHeight = bearingHeight;
bearingReliefDiameter = 15;
bearingReliefInset = 1;
/* END Bearing retainer variables */

/* Linear rod retainer variables */
linearRodCutoutDiameter = 8.2;
linearRodCutoutDepth = 7;
/* END Linear rod retainer variables */


// Build it

// Model of a 608 bearing for fit
// bearing( model= "SkateBearing" );

/* Individual components and tests */

// leadScrewBearingAdapter();
// bearingRetainerTest();
// linearRodCutoutTest();

// xIdlerTest();
// xMotorTest();

// x_end_idler();
x_end_motor();

/* Fully-constructed pieces */



module linearRodCutout()
{
    cylinder( d=linearRodCutoutDiameter, h=linearRodCutoutDepth + 0.1 );
}

module bearingRetainerCutout()
{
    union()
    {
        cylinder( d=bearingOuterDiameter, h=(bearingRetainerHeight + 0.1) );
        translate( [0, 0, -1 * bearingReliefInset] )
        {
            cylinder( d=bearingReliefDiameter, h=(bearingRetainerHeight + bearingReliefInset + 0.1) );
        }
    }
}

module leadScrewBearingAdapter()
{
    difference()
    {
        {
            union()
            {
                {
                    translate( [0, 0, leadScrewPostZOffset] )
                    {
                        cylinder( d = leadScrewPostDiameter, h = leadScrewPostHeight );
                    }
                }
                {
                    translate( [0, 0, bearingHeight] )
                    {
                        cylinder( d1 = leadScrewCapLowerDiamter, d2 = leadScrewCapUpperDiamter, h = leadScrewCapHeight );
                    }
                }
            }
        }
        {
            union()
            {
                {
                    translate( [0, 0, bearingHeight + leadScrewCapHeight - leadScrewCutoutDepth] )
                    {
                        cylinder( d = leadScrewCutoutDiameter, h = leadScrewCutoutDepth + 0.1 );
                    }
                }
                {
                    translate( [0, 0, bearingHeight + leadScrewCapHeight - leadScrewCutoutDepth - 2] )
                    {
                        cylinder( d1=1, d2=leadScrewCutoutDiameter, h=2 );
                    }
                }
            }
        }
    }
}

module cutoutPrintSupport()
{
    printSupportThickness = 0.4;
    printSupportWidth = (leadScrewCutoutDiameter - 0.4);
    prinSupportHeight = (leadScrewCutoutDepth - supportGap);
    printSupportAxisOffset = (leadScrewCutoutDiameter/2) - 0.2;

    translate( [-1 * printSupportAxisOffset, -1 * (printSupportThickness/2), 0] )
    {
        cube( [printSupportWidth, printSupportThickness, prinSupportHeight] );
    }

    rotate( [0, 0, 90] )
    {
        translate( [-1 * printSupportAxisOffset, -1 * (printSupportThickness/2), 0] )
        {
            cube( [printSupportWidth, printSupportThickness, prinSupportHeight] );
        }
    }
}

module linearRodCutoutTest()
{
    difference()
    {
        {
            union()
            {
                translate( [-1 * ((linearRodCutoutDiameter + 3)/2), -1 * ((linearRodCutoutDiameter + 3)/2), 0] )
                {
                    cube( [(linearRodCutoutDiameter + 3), (linearRodCutoutDiameter + 3), linearRodCutoutDepth] );
                    translate( [0, 0, -2] )
                    {
                        cube( [(linearRodCutoutDiameter + 3), (linearRodCutoutDiameter + 3), 2] );
                    }
                }
                
            }
        }
        {
            linearRodCutout();
        }
    }

    
}

module bearingRetainerTest()
{
    difference()
    {
        {
            union()
            {
                translate( [-1 * ((bearingOuterDiameter + 3)/2), -1 * ((bearingOuterDiameter + 3)/2), 0] )
                {
                    cube( [(bearingOuterDiameter + 3), (bearingOuterDiameter + 3), bearingRetainerHeight] );
                }
                translate( [-1 * ((bearingOuterDiameter + 3)/2), -1 * ((bearingOuterDiameter + 3)/2), -2] )
                {
                    cube( [(bearingOuterDiameter + 3), (bearingOuterDiameter + 3), 2] );
                }
            }
        }
        {
            bearingRetainerCutout();
        }
    }
}

module xIdlerTest()
{
    difference()
    {
        {
            x_end_idler();
        }
        {
            // translate( [-40, -40, 8] )
            // {
            //     cube([80, 80, 60]);
            // }
        }
    }

}

module xMotorTest()
{
    difference()
    {
        {
            x_end_motor();
        }
        {
            translate( [-40, -40, 8] )
            {
                cube([80, 100, 60]);
            }
        }
    }

}
