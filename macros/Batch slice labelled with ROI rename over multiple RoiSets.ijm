// QUICKLY LABEL INDIVIDUAL SLICES
// 
// Macro written by Guillaume Théroux-Rancourt
// guillaume.theroux-rancourt@boku.ac.at
// Last modified on 2020-09-11

roiManager("reset")

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

for (i=0; i<RoiSets.length; i++) {	
	selectWindow(fullIMG);
	roiManager("open", dir+RoiSets[i]);

	// RENAME ROIS
	nROIs = roiManager("count");
	for (j=0; j<nROIs; j++) {
		roiManager("Select", j);
		Dialog.create("Title");
		Dialog.addString("ROI name:", "");
		Dialog.show();
		name = Dialog.getString();	
		roiManager("Rename", name);
	}
	
//	run("Select None");
//	run("Select All");
//	run("Copy");
//	run("Internal Clipboard");
//
//	run("Threshold...");
//	waitForUser("Click Apply then OK.");

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
	setBackgroundColor(202, 202, 202);

	// Find the mesophyll slice
	for (m=0; m<RoiNames.length; m++) {
		if (matches(RoiNames[m], "m")) {
			setBackgroundColor(202, 202, 202);
			roiManager("Select", m); //Select  Mesophyll
			run("Clear Outside", "slice");
		}
	}

	// Loop through the other tissues
	for (m=0; m<RoiNames.length; m++) {
		if (startsWith(RoiNames[m], "e")) {
			setForegroundColor(152, 152, 152); //Epidermis color
			roiManager("Select", m); //Select the 2nd ROI = Epidermis Inside
			run("Fill", "slice");
		}
//		if (startsWith(RoiNames[m], "bundle")) {
//			run("Colors...", "foreground=orange background=yellow selection=yellow");
//			roiManager("Select", m); ////Select the 1th ROI = Bundle sheath
//			run("Fill", "slice");
//		}
		if (startsWith(RoiNames[m], "v")) {
			setForegroundColor(100, 100, 100); // Vein color
			roiManager("Select", m); ////Select the 1th ROI = Bundle sheath
			run("Fill", "slice");
		}
		if (startsWith(RoiNames[m], "s")) {
			setForegroundColor(170, 170, 170);
			roiManager("Select", m); //Select the 5th ROI = Resin canal
			run("Fill", "slice");
		}
	}

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
//run("Set Scale...", "distance=1 known="+pd+" unit="+unit);
saveAs("Tiff", dir + "labelled-stack")
