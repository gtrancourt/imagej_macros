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
	print(matches(RoiNames[m], "WM"));
	if (endsWith(RoiNames[m], "WM")) {
		run("Colors...", "foreground=green background=yellow selection=yellow");
		roiManager("Select", m); 
		run("Clear Outside", "slice");
	}
}

// Loop through the other tissues
for (m=0; m<RoiNames.length; m++) {
	if (endsWith(RoiNames[m], "AD")) {
		run("Colors...", "foreground=green background=yellow selection=yellow");
		roiManager("Select", m); //Select the 2nd ROI = Epidermis Inside
		run("Fill", "slice");
	}
	if (endsWith(RoiNames[m], "AB")) {
		run("Colors...", "foreground=green background=yellow selection=yellow");
		roiManager("Select", m); //Select the 2nd ROI = Epidermis Inside
		run("Fill", "slice");
	}
	if (matches(RoiNames[m], ".*BS.*")) {
		run("Colors...", "foreground=orange background=yellow selection=yellow");
		roiManager("Select", m); ////Select the 1th ROI = Bundle sheath
		run("Fill", "slice");
	}
	if (matches(RoiNames[m], ".*V.*")) {
		run("Colors...", "foreground=gray background=yellow selection=yellow");
		roiManager("Select", m); ////Select the 1th ROI = Bundle sheath
		run("Fill", "slice");
	}
}

run("Colors...", "foreground=orange background=yellow selection=yellow");

// Copy each labelled slice to a new file
// Create that image stack the first time
run("Select All");
run("Copy");

if (isOpen("Clipboard")) {
	selectWindow("Clipboard");
	run("Add Slice");
	run("Paste");
} else {
	run("Internal Clipboard");
}

roiManager("reset")


// Set the scale and save the file
// selectWindow("Clipboard");
// run("Set Scale...", "distance=1 known="+pd+" unit="+unit);
// saveAs("Tiff", dir + "labelled-stack");
