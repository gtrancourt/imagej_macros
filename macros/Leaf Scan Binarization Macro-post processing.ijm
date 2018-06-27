// Analyze all the previously identified images,
// apply a new threshold, and analyze the particle.
//
// This new macro was needed because the previous one did not
// crop the leaves properly, so I am not sure it is the proper leaf shape
// that was analyzed.
//
// REQUIREMENTS:
// Have all the images in one directory with nothing else in it.
//
// Created by Guillaume Théroux-Rancourt
// guillaume.theroux-rancourt@boku.ac.at
// Last modified on 2018-06-27


dir = getDirectory("Choose a Directory ");
res = getNumber("What is the resolution in dpi? Scale will be set in cm.", 600)
// outputdir = getDirectory("Choose a Directory ");
list = getFileList(dir);

if (File.isDirectory(dir + "binary") == 0) {
    File.makeDirectory(dir + "binary");
    }

// Set the measurements and colors
run("Set Measurements...", "area centroid perimeter bounding fit shape feret's display redirect=None decimal=3");
run("Colors...", "foreground=white background=black selection=yellow");

// run the first image outside of the batch mode to get a results window opened
open(list[0]);
// run("8-bit");
// Get filename and working directory
name = getTitle();
originalImg = getImageID();
index = lastIndexOf(name, ".");
if (index!=-1) name = substring(name, 0, index);
selectImage(originalImg);
setThreshold(1, 210);
setOption("BlackBackground", true);
run("Convert to Mask");
run("Set Scale...", "distance="+res+" known=2.54 unit=cm");
getDisplayedArea(xd, yd, wd, hd);
run("Canvas Size...", "width="+wd+10+" height="+hd+10+" position=Center");
saveAs("Png", dir + "binary/" + name);
run("Analyze Particles...", "size=1-Infinity display");
close();


setBatchMode(true);
// Start the loop over the image wiles in the direcxtory
for (j=1; j<list.length; j++) {
  showProgress(j+1, list.length);
	open(list[j]);
  // run("8-bit");
  // Get filename and working directory
  name = getTitle();
  originalImg = getImageID();
	index = lastIndexOf(name, ".");
	if (index!=-1) name = substring(name, 0, index);

  // Binarize the scan
	selectImage(originalImg);
  setThreshold(1, 210);
  setOption("BlackBackground", true);
  run("Convert to Mask");
  run("Set Scale...", "distance="+res+" known=2.54 unit=cm");
  getDisplayedArea(xd, yd, wd, hd);
  run("Canvas Size...", "width="+wd+10+" height="+hd+10+" position=Center");
  saveAs("Png", dir + "binary/" + name);
  run("Analyze Particles...", "size=1-Infinity display");
  close();
}

setBatchMode(false);

selectWindow("Results");
saveAs("Results",  dir + "Results-individual-leaves.csv");
run("Close");
