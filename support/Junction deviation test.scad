/**
 * A simple test for ringing effects of junction deviation changes
 *
 * Open the STL file in your slicer, generate a gcode file, then modify it like this:
 * - Identify the height of each level change. For example, "5.2"
 * - Search the gcode for a line that begins with G1 Z5.2 (change "5.2" to match your value)
 * - Add this line immediately before the line you just found:
 * - M205 J0.018 ; Change "0.018" to the new/next value
 * 
 * Alternatively, watch the print and manually change the junction deviation while the separator
 *   rings are printing between levels. You can do that by sending this gcode to your printer:
 * M205 J0.028 ; Change 0.028 to the new/next value
 * If your printer's LCD screen supports it, you may be able to use that as well. The option will
 *   be under Configuration > Advanced Settings > Jerk
**/
use <OpenSans-Regular.ttf>

// Test parameters
firstLevel = 0.01;
lastLevel = 0.03;
incrementAmount = 0.005;

// Render quality settings
$fs = 1;
$fa = 0.1;

levelXYDimension = 20; // If this is too small, your accelleration may invalidate the test
levelZDimension = 5; // Needs to be tall enough to allow some text

separatorRingHeight = 1;
separatorRingDepth = 0.5;

textImpressionDepth = 1;

// Probably don't manually change the values of the calculated variables
numLevels = ceil((lastLevel - firstLevel)/incrementAmount);
separatorCubeXYDimension = levelXYDimension - (separatorRingDepth * 2);
fontSize = levelZDimension - 2;

// do it
makeModel();

module makeModel()
{
	for( levelNum = [0 : 1 : numLevels] ) 
	let( levelValue = (levelNum * incrementAmount) + firstLevel )
	{
		// echo( levelNum );
		// echo( levelValue );

		difference()
		{
			{
				union()
				{
					translate( [0, 0, (levelNum * (levelZDimension + separatorRingHeight))] ) cube( [levelXYDimension, levelXYDimension, levelZDimension] );
					if( levelValue < lastLevel ) // otherwise, there'll be a superfluous cap
					{
						translate( [separatorRingDepth, separatorRingDepth, (levelNum * (levelZDimension + separatorRingHeight)) + levelZDimension] ) cube( [separatorCubeXYDimension, separatorCubeXYDimension, separatorRingHeight] );
					}
				}
			}
			{
				union()
				{
					translate( [2, textImpressionDepth, (levelNum * (levelZDimension + separatorRingHeight)) + 1] ) rotate( [90, 0, 0] ) makeText( str( levelValue ), fontSize );
					translate( [levelXYDimension - textImpressionDepth, (levelXYDimension/2) - 1, (levelNum * (levelZDimension + separatorRingHeight)) + 1] ) rotate( [90, 0, 90] ) makeText( "O", fontSize );
				}
			}
		}
	}
}

module makeText( input, fontSize )
{
	font = "Open Sans";
	fontHeight = 3;

	linear_extrude( height = fontHeight, twist = 0, center = false )
	{
		text( input, font = font, size = (fontSize * 1) );
	}
}