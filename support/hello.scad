/**
* Just making this model shorter so it gets done printing sooner
*/

$fs = 1;
$fa = 0.1;

cutToHeight = 5;
originalHeight = 15;
zDimension = (originalHeight - cutToHeight) + 1;

difference()
{
    {
        import( "thirdparty/hello-original.stl" );
    }
    {
        translate( [-50, -30, cutToHeight] ) cube( [100, 60, zDimension] );
    }
}