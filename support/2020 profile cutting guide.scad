

$fa = 1;
$fs = 0.2;

cutDepth = 1;
cutHeight = 60;
cutWidth = 50;

guideCutoutOffsetX = 5;
guideCutoutOffsetY = -15;
guideCutoutOffsetZ = 14;
extraCutAmount = 5;

guideCutoutExtraDepth = 5;

extraBaseHeight = 8;
baseXDimension = 100;
baseYDimension = 48.3;

cornerDiameter = 6;

difference()
{
	{
		union()
		{
			import( "2020 profile cutting guide.stl" );
			extraBase();
		}
	}
	{
		union()
		{
			cutoutShapes();
		}
	}
}





module extraBase()
{
	hull()
	{
		{
			translate( [-45 + (cornerDiameter/2), -14.3 + (cornerDiameter/2), -4] )
				cube( [baseXDimension - cornerDiameter, baseYDimension - cornerDiameter, extraBaseHeight] );
		}
		{
			translate( [ -45 + (cornerDiameter/2), -14 + (cornerDiameter/2) - 0.3, -4 ] )
			{
				cylinder( d = cornerDiameter, h = extraBaseHeight );
				translate( [0, baseYDimension - cornerDiameter, 0] ) cylinder( d = cornerDiameter, h = extraBaseHeight );
				translate( [baseXDimension - cornerDiameter, baseYDimension - cornerDiameter, 0] ) cylinder( d = cornerDiameter, h = extraBaseHeight );
				translate( [baseXDimension - cornerDiameter, 0, 0] ) cylinder( d = cornerDiameter, h = extraBaseHeight );
			}
		}
	}
}

module cutoutShapes()
{
	translate( [guideCutoutOffsetX, guideCutoutOffsetY, guideCutoutOffsetZ - extraCutAmount] ) 
		cube( [cutDepth, cutWidth, cutHeight] );

	translate( [-7, -23.5, 13.1] )
	{
		cube( [25, 10, cutDepth] );
		translate( [0, baseYDimension + 8.4, 0] )
			cube( [25, 10, cutDepth] );
	}
}



