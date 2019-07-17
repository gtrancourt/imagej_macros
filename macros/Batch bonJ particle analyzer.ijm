// Runs boneJ's particle analyzers on all files from a directory.
//
// Author: Guillaume Théroux-Rancourt (guillaume.theroux-rancourt@boku.ac.at)
// Created on 23.05.2019

// Ask the user to select a directory
dir = getDirectory("Choose a folder");

list = getFileList(dir);

for (k=0; k<list.length; k++) {
	if (endsWith(list[k], ".tif"))
		open(list[k]);
		fullIMG = getTitle();
		getPixelSize(unit, pw, ph, pd);
		getDimensions(width, height, channels, slices, frames);
		print(fullIMG, pw, width, height, slices);
		minDetectVol = (3*(pw*pw*pw))*1.1;
		run("Threshold...");
		waitForUser("set the threshold and press OK, or cancel to exit macro");
		setOption("BlackBackground", true);
		run("Convert to Mask", "method=Default background=Dark black");
		run("Particle Analyser", "surface_area enclosed_volume min="+minDetectVol+" max=Infinity surface_resampling=1 surface=Gradient split=0.000 volume_resampling=2 labelling=Mapped slices=2");
		saveAs("Results", "/run/media/gtrancourt/microCT_GTR_8tb/Phylogeny/Palisade-Spongy-data/RESULTS/"+fullIMG+"_Results.csv");
		run("Close");
		close();
}
