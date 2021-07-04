/**
* Modifications to a third party party hotend fan duct to make it more stable and
*   work better for printerX
*/

// Minimum render angle
$fa = 1;
// Minimum render size
$fs = 0.1;
// The angle of the front fan
fanAngle = 22.3;

// Marry the (fixed) original piece with our changes
union()
{
	{
		// Model fixed to make solid
		import( "thirdParty/fan-solid.stl" );
	}
	{
		shapeInsert();
		bottomsupport();
	}
}

/**
* Add some reinforcement to the part of the piece that holds the 5015 fan
*/
module bottomsupport()
{
	translate( [29.4, -13.3, 0] )
	{
		hull()
		{
			{
				cube( [2, 29, 10.5] );
			}
			{
				union()
				{
					translate( [2.5, -15, 0.5] )
					{
						sphere( d=1 );
						translate( [0, 0, 7] ) sphere( d=1 );
					}
				}
			}
		}

	}

	translate( [29.4, 15.7, 0] )
	{
		hull()
		{
			{
				translate( [0, 0, 0] ) cube( [2, 1, 10.5] );
			}
			{
				union()
				{
					translate( [8.25, -1, 0] ) cube( [1, 1, 1] );
					translate( [8.75, -0.5, 10] ) sphere( d = 1 );
				}
			}
		}
	}

	translate( [49.6, -13.3, 0] )
	{
		hull()
		{
			{
				cube( [2, 29, 10.5] );
			}
			{
				union()
				{
					translate( [-0.3, -15, 0.5] )
					{
						sphere( d=1 );
						translate( [0, 0, 7] ) sphere( d=1 );
					}
				}
			}
		}
	}

	translate( [49.6, 15.7, 0] )
	{
		hull()
		{
			{
				translate( [0, 0, 0] ) cube( [2, 1, 10.5] );
			}
			{
				union()
				{
					translate( [-7.2, -1, 0] ) cube( [1, 1, 1] );
					translate( [-6.7, -0.5, 10] ) sphere( d = 1 );
				}
			}
		}
	}
}

/**
* Make a shape around the front fan opening that prints a little nicer
*/
module shapeInsert()
{
	difference()
	{
		{
			union()
			{
				translate( [  25, 0.153, 40] ) rotate( [fanAngle, 0, 0] ) cube( [6.5 , 2, 14] );
				translate( [49.8, 0.153, 40] ) rotate( [fanAngle, 0, 0] ) cube( [6.5 , 2, 14] );
			}
		}
		{
			union()
			{
				translate( [  33.3, -3.153, 46.3] ) rotate( [fanAngle, 0, 0] ) rotate( [-90, 0, 0] ) scale( [0.6, 1.2, 1] ) cylinder( r = 6.5, h = 4 );
				translate( [    48, -3.153, 46.3] ) rotate( [fanAngle, 0, 0] ) rotate( [-90, 0, 0] ) scale( [0.6, 1.2, 1] ) cylinder( r = 6.5, h = 4 );
			}
		}
	}
}

