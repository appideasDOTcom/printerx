include <Shared-modules.scad>

/* Render quality variables */
$fa = 1;
$fs = 0.1;

knobDiameter = 23;
knobHeight = 7;
knobScale = [1, 0.65, 1];
nutHeight = 2.6;

constructedKnob();

module constructedKnob()
{
	difference()
	{
		{
			flowerKnob();
		}
		{
			cutouts();
		}
	}
}

module petal()
{
	scale( knobScale ) cylinder( h = knobHeight, d = knobDiameter );
}

module flowerKnob()
{
	union()
	{
		for( zAngle = [0 : 60 : 120] )
		{
			rotate( [0, 0, zAngle] ) petal();
		}
		translate( [0, 0, knobHeight] ) scale( [1, 1, 0.1] ) sphere( d = 16.4 );
	}

}

module cutouts()
{
	union()
	{
		translate( [0, 0, (knobHeight/2) - (nutHeight/2)] ) buriedM3Nut( diameter = 6.9, height = nutHeight );
		translate( [0, 0, -5] ) m3ThroughHole();
	}
}

