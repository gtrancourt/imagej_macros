// MACRO TO LOOP OVER A DIRECTORY
// FIND THE JPG FILES AND APPLY A MACRO.
// HERE, GET ALL THE VESSELS (DRAWN IN BLACK)
// THRESHOLD AND SAVE A NEW IMAGE.
//
// Klara Voggeneder
// Guillaume Théroux-Rancourt
// 2019-07-24

// Get information out of the opened image
fullIMG = getTitle();
getPixelSize(unit, pw, ph, pd);

// Get the ROIs
// Create RoiSets with all the zip file names for individual slices
dir = getDirectory("image");
list = getFileList(dir);

Array.print(list);

jpgFiles = newArray(1);

for (k=0; k<list.length; k++) {
	if (endsWith(list[k], ".zip"))
		jpgFiles = Array.concat(jpgFiles, list[k]);
}

jpgFiles = Array.slice(jpgFiles,1);

Array.show(jpgFiles);

// Resdets the ROI manager if it still contained something
roiManager("reset");

for (i=0; i<jpgFiles.length; i++) {

// Put your macro here

run("Set Scale...", "distance=1 known="+pd+" unit="+unit);
saveAs("Tiff", dir + fullIMG + "VESSELS");

}
