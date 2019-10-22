
// start parametric section
$hide_bigtreelogo=false; //set true for no bigtree_logo
$hide_3dplogo=false; //set true for no 3dp_logo
$render_front=true;
$render_back=true;
// end parametric section


module upperpart()
    {
        rotate ([-90,0,0]) import("front.stl"); //copy orginal front- and backpart stl into same folder as tft24.scad and rename to front.stl and back.stl
        translate([-43.5,14,-1.5]) cylinder (d=5,h=3,center=true,$fn=100);
        if ($hide_3dplogo) translate([41,14,-1.5]) cube([25,12,3],center=true);
        if ($hide_bigtreelogo)translate([41,-11,-1.5]) cube([25,18,3],center=true);
        translate([-2,0,-1.5]) cube([60,45,3],center=true);   
    };

module lowerpart()
    {
        rotate ([-90,0,0]) import("back.stl");
  
    };

module window()
    {
     CubePoints = [
     [  -26,  -19.5,  -1.5 ],  //0
     [ 26,  -19.5,  -1.5  ],  //1
     [ 26,  19.5,  -1.5 ],  //2
     [ -26,  19.5,  -1.5 ],  //3
     [  -28,  -21.5,  1.5  ],  //4
     [ 28,  -21.5,  1.5  ],  //5
     [ 28,  21.5,  1.5  ],  //6
     [  -28,  21.5,  1.5   ]]; //7
   
     CubeFaces = [
     [0,1,2,3],  // bottom
     [4,5,1,0],  // front
     [7,6,5,4],  // top
     [5,6,2,1],  // right
     [6,7,3,2],  // back
     [7,4,0,3]]; // left
  
     polyhedron( CubePoints, CubeFaces );
    };

module front_complete()
    {
     difference()
        {
         upperpart();
         translate([-39.5,19.75,-1.5]) cylinder (d=5,h=3,center=true,$fn=100);
         translate ([2.5,0,-1.5]) window();
         translate ([-50,-12.5,-12.75]) cube([15,13,7],center=true);
        };
    };

module back_complete()
    {
     difference()
        {lowerpart();
         translate([12.75,23.5,-22])cube([28.5,1,7],center=true);
         translate([-37.75,20.5,-22])cube([17,7,7],center=true);
         translate([50,17.5,-13.5])cube([9,4,10],center=true);
        };
    };


//main
if ($render_front) front_complete();
if ($render_back) translate ([0,100,0]) back_complete();
//end main
