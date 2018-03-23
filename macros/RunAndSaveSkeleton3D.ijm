setBatchMode(true); //newly opened windows are not displayed -- up to 20x faster

  // get the anmes of all the opened images
  allStackTitles=newArray(nImages);
  nStacks=0;
  for (i=1; i<=nImages; i++) {
    selectImage(i);
    if (nSlices>1) {
      allStackTitles[nStacks]=getTitle();
      nStacks++;
    }
  }
  if (nStacks <1) exit("No Stack Window Open");

// Extract the info of the opened/selected image
  dir = getDirectory("image");
  outputDir = dir + "IndCellsResults/";
  name = getTitle();
  index = lastIndexOf(name, ".");
  if (index!=-1) name = substring(name, 0, index);

 // Create ouput dir if absent
  if (File.isDirectory(outputDir) == 0) {
    File.makeDirectory(outputDir);
  }

setBatchMode(false);

setThreshold(248, 255);
setOption("BlackBackground", true);
run("Convert to Mask", "method=Default background=Dark black");
run("Skeletonise 3D");
run("Analyse Skeleton", "prune=none show");

list = getList("window.titles");
  if (list.length==0)
     print("No non-image windows are open");
  else {
     print("Non-image windows:");
     for (i=0; i<list.length; i++)
        print("   "+list[i]);
  }

selectWindow("Branch information");
//resName = getInfo("window.name");
saveAs("Text", outputDir + name + "-Skeleton3D-Branch information.txt");
run("Close");
//resName = getInfo("window.name");
selectWindow("Results");
saveAs("Text", outputDir + name + "-Skeleton3D-Results.txt");
run("Close");
// Close all windows
while (nImages>0) {
  selectImage(nImages); 
  close(); 
}
IJ.freeMemory();
