
union()
{
	{
		// import( "thirdParty/Radial_Fan_Fang_5015.stl" );
		import( "thirdParty/fan-solid.stl" );
	}
	{
		translate( [  25, 0.153, 40] ) rotate( [22.3, 0, 0] ) cube( [6.5 , 2, 14] );
		translate( [49.8, 0.153, 40] ) rotate( [22.3, 0, 0] ) cube( [6.5 , 2, 14] );
	}
}

