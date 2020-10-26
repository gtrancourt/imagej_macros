// Macro to combine vertically two image sequences
// Useful to work on large stacks that cannot be loaded
// due to not enough RAM for example.
//
// I have used this to reslice a large image stack.
// A typical workflow would be to load part of the stacks
// using "load image sequence". I would split the stack in 3
// and reslice each part and save as image sequence in separate
// folders. Then I would use this macro to combine two of the 
// folders, then save the result to a new folder

dir1 = getDir("Choose a Directory");
dir2 = getDir("Choose a Directory");

save_dir = getDir("Choose a Directory");
save_dir = File.makeDirectory(save_dir + "combine/");

list1 = getFileList(dir1);
list2 = getFileList(dir2);

setBatchMode("hide");

nb_slices = list1.length

for (i=0; i<nb_slices; i++) {
	showProgress(-i/nb_slices);
	open(dir1 + list1[i]);
	img1 = getTitle();
	open(dir2 +list2[i]);
	img2 = getTitle();
	run("Combine...", "stack1=["+img1+"] stack2=["+img2+"] combine");
	pos_label = IJ.pad(i, 4);
//	saveAs("Tiff", "/Users/guillaumetherouxrancourt/Documents/_uCT_scans/04_At_lcd_leaf1_/reslice_right/resliced_"+pos_label+".tif");
	saveAs("Tiff", save_dir + "resliced_"+pos_label+".tif");
	close("*");
}

setBatchMode("show");