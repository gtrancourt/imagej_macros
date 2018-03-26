// Compute the tortuosity factor and lateral diffusivity from 3D microCT sack 
// using the method of Earles et al. (to be submitted)
//
//
// Author: Guillaume Théroux-Rancourt (guillaume.theroux-rancourt@boku.ac.at)
// Created on 22.03.2018
// Last modification on 22.03.2018
//
// TO DO:
// - Have all the ROIs in the same RoiSet and detect the slice value
//   (instead of iterating over multiple zip files)

  setBatchMode("hide"); //newly opened windows are not displayed -- up to 20x faster


  // Extract the info of the opened/selected image
  dir = getDirectory("image");
  outputDir = dir + "Tortuosity/";
  name = getTitle();
  index = lastIndexOf(name, ".");
  if (index!=-1) name = substring(name, 0, index);

  getVoxelSize(wd, ht, dp, un);

  // Create ouput dir if absent
  if (File.isDirectory(outputDir) == 0) {
    File.makeDirectory(outputDir);
  }

compositeID = getImageID();

print(name);

// Select thresholded color
// setTool("dropper");
// waitForUser("Select the background color.");
// back = getValue("color.foreground");

// setTool("dropper");
// waitForUser("Select the color of the cells.");
// cells = getValue("color.foreground");

// setTool("dropper");
// waitForUser("Select the color of the airspace.");
// air = getValue("color.foreground");

// setTool("dropper");
// waitForUser("Select the color of the veins.");
// veins = getValue("color.foreground");


// Create airspace stack
run("Duplicate...", "title=airspace duplicate");
setAutoThreshold("Default dark");
setThreshold(254, 255);
setOption("BlackBackground", true);
run("Convert to Mask", "method=Default background=Dark black");
// saveAs("tiff", outputDir + name + "-airspace");
airspaceID = getImageID();
airspaceTitle = getTitle();

// Create stomata stack
selectImage(compositeID);
run("Duplicate...", "title=stomata duplicate");
setAutoThreshold("Default dark");
setThreshold(80, 90);
run("Convert to Mask", "method=Default background=Dark black");
// saveAs("tiff", outputDir + name + "-stomata");
stomataID = getImageID();
stomataTitle = getTitle();

// Create mesophyll stack
selectImage(compositeID);
run("Duplicate...", "title=mesophyll duplicate");
setAutoThreshold("Default dark");
setThreshold(151,171);
run("Convert to Mask", "method=Default background=Dark black");
run("Invert", "stack");
// saveAs("tiff", outputDir + name + "-mesophyll");
mesophylTitle = getTitle();
mesophylID = getImageID();

// Create the epidermis slice.
selectImage(compositeID);
run("Duplicate...", "title=epidermis duplicate");
setAutoThreshold("Default dark");
setThreshold(151,153);
run("Convert to Mask", "method=Default background=Dark black");
setBatchMode("show");
run("Outline", "stack");
run("Close-", "stack");
setBackgroundColor(0, 0, 0);
setTool("rectangle");
waitForUser("Select the area with the epidermis to clear, then click OK.\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\nNOTES\nMake sure the epidermis is within the selection along the whole stack.\nFor amphistomatous leaves, click OK within selecting an epidermis to remove.");
run("Clear", "stack");
// saveAs("tiff", outputDir + name + "-epidermis");
epidermisID = getImageID();
epidermisTitle = getTitle();

 setBatchMode("hide");



// Create the Euclidian distance map
// i.e. shortest distance to a stomata through unhindered space (free of cells)
// run("Geodesic Distance Map 3D", "marker="+stomataTitle+" mask="+mesophylTitle+ " distances=[Svensson <3,4,5,7>] normalize");
run("Geodesic Distance Map 3D", "marker=stomata mask=mesophyll distances=[Svensson <3,4,5,7>] normalize");
saveAs("tiff", outputDir + name + "-L_euc");
Leuc = getTitle();
LeucID = getImageID();
print(name+": Euclidian distance map done! (1 of 3 maps done)");

// Create the Geodesic distance map
run("Geodesic Distance Map 3D", "marker=stomata mask=airspace distances=[Svensson <3,4,5,7>] normalize");
saveAs("tiff", outputDir + name + "-L_geo");
Lgeo = getTitle();
LgeoID = getImageID();
print(name+": Geodesic distance map done!  (2 of 3 maps done)");

// Create the Epidermis distance map
run("Geodesic Distance Map 3D", "marker=epidermis mask=mesophyll distances=[Svensson <3,4,5,7>] normalize");
saveAs("tiff", outputDir + name + "-L_epi");
Lepi = getTitle();
LepiID = getImageID();
print(name+": Epidermal distance map done!  (3 of 3 maps done)");
print(name+": Moving to tortuosity and lateral diffusivity computation.");

// Compute the tortuosity factor: (Lgeo/Leuc)^2
imageCalculator("Divide create stack", Lgeo, Leuc);
run("Square", "stack");
saveAs("tiff", outputDir + name + "-tortuosity-factor");
Tortuosity = getTitle();
TortuosityID = getImageID();
print(name+": Tortuosity factor computed.");


// Compute the lateral diffusivity factor: Leuc/Lepi
imageCalculator("Divide create stack", Leuc, Lepi);
saveAs("tiff", outputDir + name + "-lateral-diffusivity");
LateralDiffusivity = getTitle();
LateralDiffusivityID = getImageID();
print(name+": Lateral diffusivity computed.");



selectImage(compositeID);
run("Duplicate...", "title=airspaceMask duplicate");
setAutoThreshold("Default dark");
setThreshold(254, 255);
setOption("BlackBackground", true);
run("Convert to Mask", "method=Default background=Dark black");
run("Outline", "stack");
run("32-bit");
setAutoThreshold("Default dark");
run("NaN Background", "stack");
run("Divide...", "value=255.000 stack");
// saveAs("tiff", outputDir + name + "-airspace-mask");
airspaceMask = getTitle();
airspaceMaskID = getImageID();



// Get the values at the edge of the airspace
imageCalculator("Multiply create stack", TortuosityID, airspaceMaskID);
saveAs("tiff", outputDir + name + "-tortuosity-factor-EDGE");


imageCalculator("Multiply create stack", LateralDiffusivityID, airspaceMaskID);
saveAs("tiff", outputDir + name + "-lateral-diffusivity-EDGE");


waitForUser("Click OK to close all image windows.");
      while (nImages>0) { 
          selectImage(nImages); 
          close(); 
      } 

