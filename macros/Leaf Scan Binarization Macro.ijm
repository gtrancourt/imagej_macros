// Recursively lists the files in a user-specified directory.
// Open a file on the list by double clicking on it.

dir = getDirectory("Choose a Directory ");
// outputdir = getDirectory("Choose a Directory ");
list = getFileList(dir);

// Create ouput dir if absent
if (File.isDirectory(dir + "binary") == 0) {
    File.makeDirectory(dir + "binary");
    File.makeDirectory(dir + "outline");
    File.makeDirectory(dir + "XY_coordinates");
    }

for (j=0; j<list.length; j++) {

	open(list[j]);

	// Get filename and working directory
	name = getTitle();
  	index = lastIndexOf(name, ".");
  	if (index!=-1) name = substring(name, 0, index);

	// Binarize the scan
	setAutoThreshold("Default");
	setOption("BlackBackground", true);
	run("Convert to Mask");
	run("Analyze Particles...", "size=100-Infinity show=Masks include add");
	run("Invert");
	binaryImg = getImageID();

	// Here, make loop to select one ROI, copy it to a new file,
	// remove some discretization error at the edge (run("Close-")),
	// roate the image if needed to orient it as portrait with petiole
	// at the bottom of the image.

	n = roiManager("count");
	for (i=0; i<n; i++) {
		selectImage(binaryImg);
		roiManager("Select", i);
		run("Copy");
		run("Internal Clipboard");
		getDisplayedArea(x, y, width, height);
		// Rotate the image if it is in landscape format
		if (width > height) {
			run("Rotate 90 Degrees Left");
		}
		getDisplayedArea(xd, yd, wd, hd);
		run("Canvas Size...", "width="+wd + 4+" height="+hd+4+" + 4 position=Center"); //increase the size of the canvas by 2-px each side


		//  Save the image
		saveAs("Png", dir + "binary/" + name +"_"+  i+1);

		//  create the outline image
		run("Outline");
		saveAs("Png", dir + "outline/" + name +"_"+  i+1);

		// Save the XY coordinates of the outline for later use in the R package MoMocs
		roiManager("Select", i);
		saveAs("XY Coordinates", dir + "XY_coordinates/" + name +"_"+  i+1);
		close();
		}

	roiManager("reset")
	run("Close All");
}
