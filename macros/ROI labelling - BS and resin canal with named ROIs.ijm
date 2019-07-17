// Automatically segment microCT leaf cross sections for the use of the
// 3DLeafCT machine learning algorithm (https://github.com/gtrancourt/microCT-leaf-traits)
//
// This macro is to segment over on a binary image of the airspace.
// THIS WOULD WORK ONLY ON LAMINAR LEAVES OR WITH DIFFERENTIATED EPIDERMIS.
//
// Uses named ROIs with the following:
// - bundle sheath
// - epidermis in
// - epidermis out
// - mesophyll
// - resin canal
// - vein
//
// Files should be arranged sequentially in you folder, but this is less
// if you specify the right sequence in the 3DLeafCT programm.
//
// Author: Guillaume Théroux-Rancourt (guillaume.theroux-rancourt@boku.ac.at)
// Created on 16.02.2018
// Last modification on 18.10.2018
//
// TO DO:
// - Have all the ROIs in the same RoiSet and detect the slice value
//   (instead of iterating over multiple zip files)
// - Create a super-macro that let's you chose what file organisation
//   has been used.


// Get information out of the opened image
fullIMG = getTitle();
getPixelSize(unit, pw, ph, pd);

// Get the ROIs
// Create RoiSets with all the zip file names for individual slices
dir = getDirectory("image");
list = getFileList(dir);

Array.print(list);

RoiSets = newArray(1);

for (k=0; k<list.length; k++) {
	if (endsWith(list[k], ".zip"))
		RoiSets = Array.concat(RoiSets, list[k]);
}

RoiSets = Array.slice(RoiSets,1);

Array.show(RoiSets);

// Resdets the ROI manager if it still contained something
roiManager("reset");

for (i=0; i<RoiSets.length; i++) {


	selectWindow(fullIMG);
	roiManager("open", dir+RoiSets[i]);
	roiManager("sort"); // sort the ROI names to put them in the same order
	
	// RoiNames = newArray(roiManager("count"));
	nROIs = roiManager("count");
	RoiNames = newArray(1);

	for (j=0; j<nROIs; j++) {
		roiManager("select", j);
		if (j==0){
			RoiNames = getInfo("roi.name");
		} else {
			tmp = getInfo("roi.name");
			RoiNames = Array.concat(RoiNames, tmp);
		}
	}

	// Find the mesophyll slice
	for (m=0; m<RoiNames.length; m++) {
		if (matches(RoiNames[m], "mesophyll")) {
			run("Colors...", "foreground=green background=yellow selection=yellow");
			roiManager("Select", m); //Select the 4th ROI = Mesophyll
			run("Clear Outside", "slice");
		}
	}

	// Loop through the other tissues
	for (m=0; m<RoiNames.length; m++) {
		if (startsWith(RoiNames[m], "ep")) {
			run("Colors...", "foreground=green background=yellow selection=yellow");
			roiManager("Select", m); //Select the 2nd ROI = Epidermis Inside
			run("Fill", "slice");
		}
		if (startsWith(RoiNames[m], "bundle")) {
			run("Colors...", "foreground=orange background=yellow selection=yellow");
			roiManager("Select", m); ////Select the 1th ROI = Bundle sheath
			run("Fill", "slice");
		}
		if (startsWith(RoiNames[m], "vein")) {
			run("Colors...", "foreground=gray background=yellow selection=yellow");
			roiManager("Select", m); ////Select the 1th ROI = Bundle sheath
			run("Fill", "slice");
		}
		if (startsWith(RoiNames[m], "resin")) {
			setColor(200);
			roiManager("Select", m); //Select the 5th ROI = Resin canal
			fill();
		}
	}

	run("Colors...", "foreground=orange background=yellow selection=yellow");

	// Copy each labelled slice to a new file
	// Create that image stack the first time
	run("Select All");
	run("Copy");

	if (i == 0) {
		run("Internal Clipboard");
	} else {
		selectWindow("Clipboard");
		run("Add Slice");
		run("Paste");
	}

	roiManager("reset")
}

// Set the scale and save the file
selectWindow("Clipboard");
run("Set Scale...", "distance=1 known="+pd+" unit="+unit);
saveAs("Tiff", dir + "labelled-stack");
