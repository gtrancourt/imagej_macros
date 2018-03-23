// Find Stack Maxima,
// create a new stack with single points
// and the local thickness data (i.e. one point for each maxima)
// and analyse each watershed particle
//
// 
// https://imagej.nih.gov/ij/macros/FindStackMaxima.txt
//
// This macro runs the Process>Binary>Find Maxima
// command on all the images in a stack.


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

  thicknessChoiceArray = Array.concat("none", allStackTitles);

  // Create the dialog box
  Dialog.create("Analyze cells in each slice");
  Dialog.addChoice("Stack to analyze", allStackTitles);
  Dialog.addRadioButtonGroup("Current view", newArray("Paradermal", "Cross/Longitudinal - Adaxial on top", "Cross/Longitudinal - Abaxial on top"), 3, 1, "Paradermal");
  Dialog.addRadioButtonGroup("Do you want to measure under the current view or rotate the image under paradermal view?", newArray("rotate view","current view"), 1, 2, "rotate view");
  Dialog.addCheckbox("Exclude cells touching the edges from analysis?", true);
  Dialog.addCheckbox("Combine with local thickness?", true);
  Dialog.addChoice("Local thickness stack", thicknessChoiceArray); 
  Dialog.addMessage("Find Maxima Options");
  Dialog.addNumber("Noise Tolerance:", 10);
  Dialog.addChoice("Output Type:", newArray("Single Points", "Maxima Within Tolerance", "Segmented Particles", "Count"));
  Dialog.addCheckbox("Exclude Edge Maxima", true);
  Dialog.addCheckbox("Light Background", false);
  Dialog.addMessage("Result files will be saved to a new directory (~/IndCellsResults) within the source image directory");
  Dialog.show();

  // Assign variables for Dialog choices
  imgId = Dialog.getChoice();
  thicknessStackID =  Dialog.getChoice();
  edgesChoice = Dialog.getCheckbox();
  thicknessChoice = Dialog.getCheckbox();
  view = Dialog.getRadioButton();
  rotateChoice = Dialog.getRadioButton();

  // Find maxima options
  tolerance = Dialog.getNumber();
  type = Dialog.getChoice();
  exclude = Dialog.getCheckbox();
  light = Dialog.getCheckbox();


  // Extract the info of the opened/selected image
  dir = getDirectory("image");
  outputDir = dir + "IndCellsResults/";
  name = getTitle();
  index = lastIndexOf(name, ".");
  if (index!=-1) name = substring(name, 0, index);

  getVoxelSize(wd, ht, dp, un);


  // Create ouput dir if absent
  if (File.isDirectory(outputDir) == 0) {
    File.makeDirectory(outputDir);
  }

  // Reslice the stack if not in paradermal view, 
  // with the abaxial epidermis outputed as the first slice
  if(view == "Cross/Longitudinal - Adaxial on top")
    orientation = "Top";
  else
    if(view == "Cross/Longitudinal - Abaxial on top")
      orientation = "Bottom";

  if((rotateChoice == "rotate view") & (view != "Paradermal"))
    run("Reslice [/]...", "output="+wd+" start="+orientation+" avoid");

  if(view == "Paradermal")
  	nameOrientation = "_paradermal";
  else
  	nameOrientation = "_cross_section";

  // Watershed the image
  setBatchMode(false);
  paradermalID = getImageID();
  run("Duplicate...", "duplicate");
  run("Watershed", "stack");
  watershedID = getImageID();
  waitForUser("Quality control", "How is the watershedded image?\nPress ESC to stop the macro.");

  setBatchMode(true);
  // Analyze the watershed image and save the results
  if(edgesChoice)
  	edges = " exclude ";
  else
  	edges = " ";

  run("Analyze Particles...", "display"+edges+"clear stack");
  saveAs("Results", outputDir + name + nameOrientation + "_watershed-particle-results.txt");
  run("Close");

  if(thicknessChoice == 0)
  	waitForUser("Done!");
  else {
// Find Stack Maxima
// (from Wayne Rasband)
// https://imagej.nih.gov/ij/macros/FindStackMaxima.txt
//
// This macro runs the Process>Binary>Find Maxima
// command on all the images in a stack.

  options = "";
  if (exclude) options = options + " exclude";
  if (light) options = options + " light";
  //setBatchMode(true);
  input = getImageID();
  n = nSlices();
  for (i=1; i<=n; i++) {
     showProgress(i, n);
     selectImage(input);
     setSlice(i);
     run("Find Maxima...", "noise="+ tolerance +" output=["+type+"]"+options);
     if (i==1)
        output = getImageID();
    else if (type!="Count") {
       run("Select All");
       run("Copy");
       close();
       selectImage(output);
       run("Add Slice");
       run("Paste");
    }
  }
  run("Select None");
  setBatchMode(false);
  // End Find Stack Maxima


  // Convert the maxima stack to a max of the maximas (0 and 1)
  run("Divide...", "value=255 stack");
  maximaID = getImageID();

  // Combine with local thickness
    if(thicknessStackID == "none") {
      selectImage(paradermalID);
      run("Thickness", "thickness graphic");
      thicknessStackID = getImageID();      
      selectWindow("Results");
      run("Close");
    }
    selectImage(paradermalID);
    getMinAndMax(min, max);
  	setBatchMode(true);    
    if(max > 1) {
      run("Duplicate...", "duplicate");
      run("Divide...", "value="+max+" stack");
      maskID = getImageID();
    } else {
      maskID = paradermalID;
    }
    setBatchMode(false);    
    imageCalculator("Multiply create stack", thicknessStackID, maskID);
    saveAs("tiff", outputDir + name + "_Th-with-mask");
    imageCalculator("Multiply create stack", thicknessStackID, maximaID);
    saveAs("tiff", outputDir + name + "_Th-maxima");
    Stack.getStatistics(voxelCount, mean, stackMin, stackMax, stdDev);
    setThreshold(wd, stackMax);
    run("Analyze Particles...", "display clear stack");
    saveAs("Results", outputDir + name + nameOrientation + "_Th-maxima-results.txt");
    resetThreshold;

    waitForUser("Click OK to close some image windows\nor ESC to do nothing.");
    setBatchMode(true);
    selectImage(watershedID);
    run("Close");
    selectImage(maximaID);
    run("Close");
    selectImage(maskID);
    run("Close");
    setBatchMode(false); 
  }


