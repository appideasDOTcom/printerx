/**
* A place to put SCAD modules that are shared by multiple components.
*
* This came about after a couple had already been repeated, and I haven't refactored everything, so there's probably still a little duplication of modules.
**/

// Create an "S" shaped curve for model strength on what would otherwise be a corner
module essCurve( d, h )
{
  xDimension = d;
  yDimension = d;
  zDimension = h;

  difference()
    {
      {
        translate( [(-1 * (xDimension / 2)), (-1 * (yDimension / 2)), 0] )
        {
          cube( [xDimension, yDimension, zDimension] );
        }
      }
      {
        translate( [ 0, 0, -1 ] )
        {
          translate( [0, (-1 * yDimension), 0] )
          {
            cube( [xDimension, yDimension * 2, (zDimension + 2)] );
          }
          translate( [(-1 * xDimension), 0, 0] )
          {
            cube( [xDimension, yDimension, (zDimension + 2)] );
          }

          linear_extrude( height=(zDimension + 2), twist=0, scale=[1, 1], center=false)
          {
            $fn=64;    //set sides to 64
            circle(r=(xDimension / 2));
          }
          
        }

      }
    
  }
}

module m5Head( height = 20 )
{
    cylinder( d = 9, h = height );
}

module m5Nut(  height = 3.9  )
{
    
}

module m5TroughHole( height = 10 )
{
    cylinder( d = 5.6, h = height );
}

module m4Head( height = 3.9 )
{
    cylinder( h = height, d = 7.2 );
}

module m4Nut( height = 3.0 )
{
    cylinder( h = height, d = 8.2, $fn=6 );
}

module m4ThroughHole( height = 20 )
{
    cylinder( d = 4.6, h=height, center=false );
}
