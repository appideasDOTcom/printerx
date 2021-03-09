// Minimum render angle
$fa = 1;
// Minimum render size
$fs = 0.1;


actualWidth = 20.5;
actualLength = 20.5;
pcbTolerance = 0.4;

baseWidth = actualWidth + pcbTolerance;
baseLength = actualLength + pcbTolerance;

cornerRadius = 2;
wallThickness = 2;

backReliefDepth = 3;
floorDepth = 1.2;
pcbThickness = 1.4;

baseThickness = backReliefDepth + floorDepth + pcbThickness;

backReliefWidth = baseWidth - 6;
backReliefLength = baseLength - 12;

cabletrapWidth = 12;

rodDiameter = 8;
neckThickness = 7;
neckOpeningWidth = 6;
neckDepth = 12;
neckDistance = 15;

armWidth = neckThickness - 3;

armDistance = 12;
distanceOffsetX = -1.4;

nutWallThickness = 1.6;
m4BoltDiameter = 4.5;

m3BoltDiameter = 3.6;
m3BoltOffset = 2.5;

componentDepth = 6;
lidThickness = componentDepth + 1.2;
componentWidth = 13;

// piece: main|lid|all
// orientation: print|view
render( piece = "main", orientation = "view" );

module render( piece = "main", orientation = "view" ) {
	if( piece == "lid" ) {

		if( orientation == "print" ) {
			rotate( [180, 0, 0] ) lid();
		} else {
			translate( [0, 0, baseThickness] )  lid();
		}

	} else if( piece == "all" ) {
		construction();
		translate( [0, 0, baseThickness] )  lid();
	} else {

		if( orientation == "print" ) {
			rotate( [90, 0, 0] ) construction();
		} else {
			construction();
		}

	}
}

module printOrientation( piece ) {
	if( piece == "lid" ) {
		lid();
	} else {
		construction();
	}
}

module lid() {
	difference()
	{
		{
			linear_extrude( height = lidThickness ) {
				offset( r = cornerRadius ) {
					offset( delta = (wallThickness - cornerRadius ) ) {
						square( size=[baseWidth, baseLength] );
					}
				}
			}
		}
		{
			translate( [0, 0, baseThickness] ) actuatorCutout();
			translate( [0, 0, baseThickness + 2] ) actuatorCutout();
			pcbBoltCutout();
			translate( [(baseWidth/2) - (componentWidth/2), -1 * wallThickness - 0.1, -0.1] ) cube( [componentWidth, baseLength + wallThickness + 0.2, componentDepth + 0.1] );
			smtCutout();
		}
	}
}

module smtCutout() {
	smtX = 6;
	smtY = 10;
	smtZ = 2;

	translate( [0, (baseLength/2) - (smtY/2), -0.1] ) {
		cube( [smtX, smtY, smtZ + 0.1] );
		translate( [baseWidth - smtX, 0, 0] ) cube( [smtX, smtY, smtZ + 0.1] );
	}
}

module construction() {
	difference() {
		{
			union() {
				base();
				rodConnector();
				neckConnector();
			}
		}
		{
			union()
			{
				m4BoltCutout();
				pcbBoltCutout();
			}
		}
	}
}

module m4BoltCutout() {
	translate( [-1 * (neckDistance + (neckDepth/2) + armWidth + (rodDiameter/2)), (neckThickness/2), neckOpeningWidth + pcbTolerance + nutWallThickness] )
	{
		nutTrap();
		translate( [0, 0, -15]) cylinder( d = m4BoltDiameter, h = 20 );
	}
}



module pcbBoltCutout() {
	translate( [0, 0, -1] ) {
		translate( [m3BoltOffset, m3BoltOffset, 0]) cylinder( d = m3BoltDiameter, h = 20 );
		translate( [baseWidth - m3BoltOffset, m3BoltOffset, 0]) cylinder( d = m3BoltDiameter, h = 20 );
		translate( [baseWidth - m3BoltOffset, baseWidth - m3BoltOffset, 0]) cylinder( d = m3BoltDiameter, h = 20 );
		translate( [m3BoltOffset, baseWidth - m3BoltOffset, 0]) cylinder( d = m3BoltDiameter, h = 20 );
	}
}


module neckConnector() {
	hull()
	{
		{
			translate( [-1 * neckDistance, -1 * wallThickness, 0] ) cube( [neckDistance, neckDepth, baseThickness] );
		}
		{
			translate( [-1 * wallThickness, 0, 0] ) cube( [wallThickness, baseLength, baseThickness] );
		}
	}
}


module rodConnector() {
	translate( [-1 * neckDistance - (rodDiameter/2), neckDepth - (1 * wallThickness), (baseThickness/2)] ) rotate( [0, 180, 0] ) rotate( [90, 0, 0] )
	{
		difference()
		{
			{
				cylinder( d = rodDiameter + neckThickness, h = neckDepth );
			}
			{
				union()
				{
					translate( [0, 0, -1] ) cylinder( d = rodDiameter, h = neckDepth + 2 );
					translate( [0, (-1 * (neckOpeningWidth/2)), -1] ) cube( [10, neckOpeningWidth, neckDepth + 2] );
				}
			}
		}

		translate( [(rodDiameter/2) + distanceOffsetX, -1 * neckThickness, 0] )
		{
			arm();
			translate( [0, neckOpeningWidth + armWidth, 0] )
			{
				arm();
			}
		}

	}
}

module base() {

	difference() {
		{
			union()
			{
				mainBase();
			}
		}
		{
			union()
			{
				translate( [0, 0, baseThickness] ) {
					pcbCutout();
					backReliefCutout();
					cableTrapExit();
					actuatorCutout();
				}

			}
		}
	}

}

module arm()
{
	
	
	hull()
	{
		{
			cube( [armDistance - distanceOffsetX, armWidth, neckDepth] );
		}
		{
			translate( [armDistance + (armWidth/2) + (distanceOffsetX/2), (armWidth/2), 0] ) cylinder( d = armWidth, h = neckDepth );
		}
	}
}


module actuatorCutout() {
	translate( [-1 * wallThickness - 0.1, baseLength, -1 * baseThickness - 0.1] ) {
		linear_extrude( height = baseThickness + 0.2 ) {
			square( size=[baseWidth + (wallThickness * 2) + 0.2, wallThickness + 0.1] );
		}
	}
}

module cableTrapExit() {
	translate( [(baseWidth/2) - (cabletrapWidth/2), -1 * wallThickness - 0.1, -1 * (pcbThickness)] ) {
		linear_extrude( height = pcbThickness + 0.1 ) {
			square( size=[cabletrapWidth, wallThickness + 0.2] );
		}
	}
}

module mainBase() {
	linear_extrude( height = baseThickness ) {
		offset( r = cornerRadius ) {
			offset( delta = (wallThickness - cornerRadius ) ) {
				square( size=[baseWidth, baseLength] );
			}
		}
	}
}

module pcbCutout() {
	translate( [0, 0, (-1 * pcbThickness)] ) {
		linear_extrude( height = (pcbThickness) + 0.1 ) {
			square( size=[baseWidth, baseLength + wallThickness + 0.1] );
		}
	}
}

module backReliefCutout() {
	translate( [(baseWidth/2) - (backReliefWidth/2), (baseLength/2) - (backReliefLength/2), (-1 * (pcbThickness + backReliefDepth))] ) {
		linear_extrude( height = backReliefDepth + 0.1 ) {
			square( size=[backReliefWidth, backReliefLength] );
		}
		
	}
}

module nutTrap()
{
	cylinder( h = 4.5, r = 4.0, $fn=6 );
}
