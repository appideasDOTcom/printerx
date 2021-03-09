/**
* Provides the casing for printerX's ESP8266 and associated electronics, which 
*    is used as a Wireless Access Point that can get WiFi connection info from 
*    users for configuring the OctoPi server's Internet connection without using
*    a monitor.
*/
// Minimum render angle
$fa = 1;
// Minimum render size
$fs = 0.1;

// Distance between bolts on the X axis
xBoltDelta = 45.72;
// Distance between bolts on the Y axis
yBoltDelta = 49.53;

floorHeight = 1.2;

m3NutDiameter = 6.4;
m3ThroughHoleDiameter = 3.4;

supportSphereDiameter = (m3NutDiameter + 3);
supportCylinderHeight = 7;
supportCylinderDiameter = m3ThroughHoleDiameter + 4;

wallThickness = 4;
extraWallWidth = 30;
wallHeight = 20;
wallXOffset = 2;

floorPieceWidth = supportSphereDiameter - 0.35;

construct();

// Full unit construction
module construct()
{
	difference()
	{
		{
			union()
			{
				supports();
				crossFloor();
				wall();
			}
		}
		{
			cutouts();
		}
	}
}

// The outer wall that attaches to the printer
module wall()
{
	translate( [xBoltDelta + (supportSphereDiameter/2) + wallXOffset, (-1 * (extraWallWidth/2)), 0] ) cube( [wallThickness, yBoltDelta + extraWallWidth, wallHeight] );
	translate( [xBoltDelta, 0, 0] )
	{
		translate( [0, (-1 * (supportCylinderDiameter/2)), 0] )
		{
			cube( [wallThickness + wallXOffset + (floorPieceWidth/2), supportCylinderDiameter, supportCylinderHeight] );
			translate( [0, yBoltDelta, 0] ) cube( [wallThickness + wallXOffset + (floorPieceWidth/2), supportCylinderDiameter, supportCylinderHeight] );
		}
	}
}

// The floor pattern
module crossFloor() {

	hull()
	{
		{

		}
		{
			cylinder( d = floorPieceWidth, h = floorHeight );
			translate( [xBoltDelta, yBoltDelta, 0] ) cylinder( d = floorPieceWidth, h = floorHeight );
		}
	}
	hull()
	{
		{

		}
		{
			translate( [xBoltDelta, 0, 0] ) cylinder( d = floorPieceWidth, h = floorHeight );
			translate( [0, yBoltDelta, 0] ) cylinder( d = floorPieceWidth, h = floorHeight );
		}
	}
}

// Combine the standoffs for the ESP board mount
module supports() {
	support();
	translate( [xBoltDelta, 0, 0] ) support();
	translate( [0, yBoltDelta, 0] ) support();
	translate( [xBoltDelta, yBoltDelta, 0] ) support();
}

// A single standoff
module support() {

	union()
	{
		sphere( d = supportSphereDiameter );
		cylinder( d = supportCylinderDiameter, h = supportCylinderHeight );
	}
}

// Combine all cutouts for final application
module cutouts() {
	supportCutout();
	translate( [xBoltDelta, 0, 0] ) supportCutout();
	translate( [0, yBoltDelta, 0] ) supportCutout();
	translate( [xBoltDelta, yBoltDelta, 0] ) supportCutout();

	translate( [xBoltDelta + (supportCylinderDiameter/2), (-1 * (extraWallWidth/4)), (wallHeight/2)] ) rotate( [0, 90, 0] ) m3ThroughHole( height = 10 );
	translate( [xBoltDelta + (supportCylinderDiameter/2), (yBoltDelta + (extraWallWidth/4)), (wallHeight/2)] ) rotate( [0, 90, 0] ) m3ThroughHole( height = 10 );

}

// A single cutout of a standoff/support
module supportCutout() {

	union()
	{
		translate( [0, 0, -6] ) m3ThroughHole( height = 20 );
		translate( [(-1 * (supportSphereDiameter/2)), (-1 * (supportSphereDiameter/2)), (-1 * supportSphereDiameter)] )
		{
			cube( [supportSphereDiameter, supportSphereDiameter, supportSphereDiameter] );
		}
		translate( [0, 0, -0.1] ) m3Nut();
	}
	
}

// A through-hole for an M3 bolt
module m3ThroughHole( height )
{
	cylinder( d = m3ThroughHoleDiameter, h = height );
}

// A nut trap for an M3 bolt
module m3Nut()
{
	m3NutDepth = 2.6;
    cylinder( d = m3NutDiameter, h = (m3NutDepth + 0.2), $fn = 6 );
}
