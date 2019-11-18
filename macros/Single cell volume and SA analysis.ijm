// Set what needs to be measured
run("Set Measurements...", "area perimeter bounding fit feret's stack display redirect=None decimal=3");

// The next line prevents ImageJ from showing the processing steps during
// processing of a large number of images, speeding up the macro
setBatchMode(true);

// Show the user a dialog to select a directory of images
inputDirectory = getDirectory("Choose a Directory of Images");

// Get the list of files from that directory
// NOTE: if there are non-image files in this directory, it may cause the macro to crash
fileList = getFileList(inputDirectory);

//tifList = newArray(1);
//for (k=0; k<fileList.length; k++) {
//	if (endsWith(fileList[k], ".tif"))
//		tifList = Array.concat(tifList, fileList[k]);
//}

for (i = 0; i < fileList.length; i++)
{
  open(fileList[i]);
//  inputDirectory = '/home/guillaume/Seafile/GTRancourt-shared-w-DT/New_Phytologist-Commentary/_cell_shapes/';
  filename = getTitle();
  outputFile = replace(filename, ".tif", "");
  print("starting with " + outputFile);
  run("Particle Analyser", "surface_area enclosed_volume euler min=0.000 max=Infinity surface_resampling=1 show_thickness surface=Gradient split=0.000 volume_resampling=2 labelling=Mapped slices=2");
//  run("Particle Analyser", "surface_area feret enclosed_volume euler thickness mask min=0.000 max=Infinity surface_resampling=1 show_thickness surface=Gradient split=0.000 volume_resampling=2 labelling=Mapped slices=2");
  print("done with 3D Feret, SA, and volume");
  saveAs("Results", inputDirectory + "/Results/" + outputFile + "_Results_3D_resamp1.csv");
//  saveAs("Tiff", inputDirectory + "/Results/" + outputFile + "_thickness.tif");
//  close(); // Uncomment this if creating thickness (will close the main image if not generating thickness
  selectWindow(filename);
  run("Particle Analyser", "surface_area enclosed_volume min=0.000 max=Infinity surface_resampling=2 surface=Gradient split=0.000 volume_resampling=2 labelling=Mapped slices=2");
  saveAs("Results", inputDirectory + "/Results/" + outputFile + "_Results_3D_resamp2.csv");
  run("Analyze Particles...", "display clear stack");
  saveAs("Results", inputDirectory + "/Results/" + outputFile + "_Results_2D_SIDEview.csv");
  run("Reslice [/]...", "output=0.325 start=Top avoid");
  run("Analyze Particles...", "display clear stack");
  saveAs("Results", inputDirectory + "/Results/" + outputFile + "_Results_2D_TOPview.csv");
  run("Close");
  close();
  print("done!");
}

setBatchMode(false);
