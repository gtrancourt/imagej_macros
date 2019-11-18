// Split an image stack in about 20 individual images.
//
// Author: Guillaume Théroux-Rancourt (guillaume.theroux-rancourt@boku.ac.at)
// Created on 15.11.2019


// Get information out of the opened image
fullIMG = getTitle();
dir = getDirectory("image");
nb_of_slices = nSlices;

// Wait for user to select a slice
waitForUser("Select first slice to segment");
starting_slice = getSliceNumber();

step_size = round(((nb_of_slices-100) - starting_slice) / 20);

// Keep only 20 or so slices
run("Slice Keeper", "first="+ starting_slice +" last="+ nb_of_slices - 100 +" increment="+step_size);
nb_of_slices_split = nSlices;
split_name = getTitle();

for (i=1; i<nb_of_slices_split+1; i++) {
	setSlice(i);
	lab = getMetadata("Label");
	lab = replace(lab, "\\:","\\_");
	run("Select All");
	run("Copy");
	run("Internal Clipboard");
	saveAs("Tiff...", dir + fullIMG + lab);
	close();
	selectWindow(split_name);
}

close();
