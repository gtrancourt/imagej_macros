// Automatically segment microCT leaf cross sections for the use of the
// 3DLeafCT machine learning algorithm (https://github.com/gtrancourt/microCT-leaf-traits)
//
// This macro is to segment over on a binary image of the airspace.
// IT IS FOR NEEDLES OR NON-LAMINAR LEAVES THAT ARE FULLY IN THE IMAGE ONLY.
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
	print(call("ij.plugin.frame.RoiManager.getName"));


	run("Colors...", "foreground=green background=yellow selection=yellow");
	roiManager("Select", 3); //Select the 4th ROI = Mesophyll
	run("Clear Outside", "slice");

	run("Colors...", "foreground=yellow background=green selection=yellow");
	roiManager("Select", 1); //Select the 2nd ROI = Epidermis Inside
	run("Clear Outside", "slice");

	run("Colors...", "foreground=green background=yellow selection=yellow");
	roiManager("Select", 2); //Select the 3th ROI = Epidermis outside
	run("Clear Outside", "slice");

	run("Colors...", "foreground=orange background=yellow selection=yellow");
	roiManager("Select", 0); ////Select the 1th ROI = Bundle sheath
	run("Fill", "slice");

	run("Colors...", "foreground=gray background=yellow selection=yellow");
	roiManager("Select", 5); //Select the 6th ROI = Vein
	run("Fill", "slice");

	setColor(200);
	roiManager("Select", 4); //Select the 5th ROI = Resin canal
	fill();
	//run("Fill", "slice");

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
saveAs("Tiff", dir + "labelled-stack")
