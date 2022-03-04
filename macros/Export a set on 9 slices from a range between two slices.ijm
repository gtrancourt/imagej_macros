// Get 9 slices out of a stack within a defined range of slices.
//
// Author: Guillaume Théroux-Rancourt (guillaume.theroux-rancourt@boku.ac.at)
// Created on 3.12.2021
//
// This macro requires an image to be opened.
// This macro probably requires Fiji because Slice Keeper 
// is not in base ImageJ (ImageJ 1) I think.


// Create dialog window
Dialog.create("Select slice range");
Dialog.addNumber('First mesophyll slice', 0);
Dialog.addNumber('Last mesophyll slice', 500);
Dialog.show();

// Extract info from dialog values
firstSlice = Dialog.getNumber();
lastSlice = Dialog.getNumber();

// Get info on the image to work with
imgPath = getInfo("image.directory");
filename_w_ext = getTitle();
filename_wo_ext = File.getNameWithoutExtension(imgPath + filename_w_ext);

// Compute the slice range and the step size
sliceRange = lastSlice - firstSlice;
sliceStep = floor(sliceRange / 10);

// Print outputs in log window
print(filename_w_ext + ': steps of ' + sliceStep + ' slices');
print('First mesophyll slice: ' + firstSlice);
print('Last mesophyll slice: ' + lastSlice);

// Create the new file name
newName = 'slicesSel_' + filename_wo_ext + '_stepsOf' + sliceStep + '_firstSlice' + firstSlice + '.tif';

// Run Slice Keeper and rename the window to the new name
run("Slice Keeper", "first="+ (firstSlice + sliceStep) +" last="+ (firstSlice + (sliceStep*9)) +" increment="+sliceStep);
rename(newName);

// Save the kept slices to the folder in which the current image was in.
saveAs("Tiff", imgPath + newName);