// Extract individual leaves from a scan of multiple leaves
// an analyze them each individually.
// Will alss save a binary image, an outline, and XY coordinates.
// Will save the results in a .csv file.
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

// Create ouput dir if absent
if (File.isDirectory(dir + "binary") == 0) {
    File.makeDirectory(dir + "individual_8_bit_images");
    File.makeDirectory(dir + "binary");
    File.makeDirectory(dir + "outline");
    File.makeDirectory(dir + "XY_coordinates");
    }

// Set the measurements and colors
run("Set Measurements...", "area centroid perimeter bounding fit shape feret's display redirect=None decimal=3");
run("Colors...", "foreground=white background=black selection=yellow");

// Start the loop over the image wiles in the direcxtory
for (j=0; j<list.length; j++) {
	open(list[j]);
  // run("8-bit");
  // Get filename and working directory
  name = getTitle();
  originalImg = getImageID();
  	index = lastIndexOf(name, ".");
  	if (index!=-1) name = substring(name, 0, index);

  run("Duplicate...", " ");
  duplicateID = getImageID();

	// Binarize the scan
	selectImage(originalImg);
	setAutoThreshold("Default");
  //setThreshold(0, 200);
  setOption("BlackBackground", true);
  run("Convert to Mask");
  run("Set Scale...", "distance="+res+" known=2.54 unit=cm");
  run("Analyze Particles...", "size=1-Infinity show=Masks display add");
	run("Invert");
	binaryImg = getImageID();

	// Here, make loop to selePngct one ROI, copy it to a new file,
	// remove some discretization error at the edge (run("Close-")),
	// roate the image if needed to orient it as portrait with petiole
	// at the bottom of the image.

	n = roiManager("count");
	for (i=0; i<n; i++) {
    selectImage(duplicateID);
		roiManager("Select", i);
		run("Copy");
		run("Internal Clipboard");
    saveAs("Png", dir + "individual_8_bit_images/" + name +"_"+  i+1);

		selectImage(binaryImg);
		roiManager("Select", i);
		run("Copy");
		run("Internal Clipboard");
    run("Set Scale...", "distance="+res+" known=2.54 unit=cm");
		getDisplayedArea(x, y, width, height);
		// Rotate the image if it is in landscape format
		if (width > height) {
			run("Rotate 90 Degrees Right");
		}
    getDisplayedArea(xd, yd, wd, hd);
    // Analyse only leaves and not shapes that mgiht have been created by shadows
    if (hd/wd < 5) {
      //increase the size of the canvas by 5-px each side
      run("Canvas Size...", "width="+wd+10+" height="+hd+10+" position=Center");
      //  Save the full leaf image
      saveAs("Png", dir + "binary/" + name +"_"+  i+1);

      //  create the outline image and save it
      run("Fill Holes");
      run("Outline");
      saveAs("Png", dir + "outline/" + name +"_"+  i+1);
    }
  }
	roiManager("reset")
	run("Close All");
}

selectWindow("Results");
saveAs("Results",  dir + "Results.csv");
run("Close");

// Analyze all the full leaves
pathToBinaries = dir + "binary/";
run("Measure...", "choose=" + pathToBinaries);
// Table.renameColumn(oldName, newName);
saveAs("Results",  dir + "Results-binaries.csv");
run("Close");

// Save the XY coordinates
listOutlines = getFileList(dir + "outline/");
for (k=0; k<listOutlines.length; k++) {
	open(dir + "outline/" + listOutlines[k]);
  name = getTitle();
  run("Analyze Particles...", "size=0-Infinity show=Nothing add");
  roiManager("Select", 0);
  saveAs("XY Coordinates", dir + "XY_coordinates/" + name);
	roiManager("reset")
  run("Close All");
}
