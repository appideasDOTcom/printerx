/**
* Simple tabs to attach to 8MM rods to serve as endstops on the X and Y axes
*/

$fa = 1;
$fs = 0.1;

rodDiameter = 8;
thickness = 7;
length = 8;
openingWidth = 6;

armDistance = 9;
distanceOffsetX = -1.4;

construction();

module construction ()
{
	difference()
	{
		{
			union()
			{
				body();
				arms();
			}
		}
		{
			cutouts();
		}
	}
}


module body()
{
	difference()
	{
		{
			cylinder( d = rodDiameter + thickness, h = length );
		}
		{
			translate( [0, 0, -1] ) cylinder( d = rodDiameter, h = length + 2 );
			translate( [0, (-1 * (openingWidth/2)), -1] ) cube( [10, openingWidth, length + 2] );
		}
	}
}

module arms()
{

	translate( [(rodDiameter/2) + distanceOffsetX, (openingWidth/2), 0] )
	{
		arm();
		translate( [0, ( -1 * (openingWidth * (5/3)) ), 0] )
		{
			arm();
		}
	}
}

module arm()
{
	armWidth = thickness - 3;
	
	hull()
	{
		{
			cube( [armDistance - distanceOffsetX, armWidth, length] );
		}
		{
			translate( [armDistance + (armWidth/2) + (distanceOffsetX/2), (armWidth/2), 0] ) cylinder( d = armWidth, h = length );
		}
	}
}

// M3-sized cutouts
module cutouts()
{
	nutWallThickness = 1.6;
	boltDiameter = 3.7;

	translate( [(armDistance/2) - (distanceOffsetX * 2), (openingWidth/2) + nutWallThickness, (length/2)] )
	{
		rotate( [-90, 0, 0] ) 
		{
			nutTrap();
			translate( [0, 0, -25] ) cylinder( d = boltDiameter, h = 50 );
		}
	}
	
}

module nutTrap()
{
	cylinder( h = 4.5, r = (6.8/2), $fn=6 );
}

