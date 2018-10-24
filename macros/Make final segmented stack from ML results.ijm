selectWindow("C_I_5_Strip1_BINARY-8bit.tif");
selectWindow("C_I_5_Strip1_MLresults-no-air-2x-small.tif");
run("Size...", "width=1334 height=1240 depth=1920 constrain average interpolation=Bilinear");
run("Duplicate...", "duplicate");
setThreshold(170, 170);
//setThreshold(170, 170);
run("Convert to Mask", "method=Default background=Dark black");
run("Options...", "iterations=8 count=1 black do=Open stack");
selectWindow("C_I_5_Strip1_MLresults-no-air-2x-small-1.tif");
run("Invert", "stack");
run("Options...");
run("Options...", "iterations=1 count=1 black do=[Fill Holes] stack");
run("Analyze Particles...", "size=10000-Infinity add stack");
selectWindow("C_I_5_Strip1_BINARY-8bit.tif");
setForegroundColor(170, 170, 170);
runMacro("/home/gtrancourt/Dropbox/_github/imagej_macros/macros/fillInside-macro.txt");
run("Save");

//CLOSE THE ROI MANAGER OR DELETE ALL

run("Duplicate...", "duplicate");
setThreshold(185, 185);
//setThreshold(185, 185);
run("Convert to Mask", "method=Default background=Light black");
run("Options...", "iterations=1 count=1 black do=[Fill Holes] stack");
run("Options...", "iterations=3 count=1 black do=Dilate stack");
run("Analyze Particles...", "add stack");
selectWindow("C_I_5_Strip1_BINARY-8bit.tif");
setForegroundColor(85, 85, 85);
runMacro("/home/gtrancourt/Dropbox/_github/imagej_macros/macros/fillInside-macro.txt");

//CLOSE THE ROI MANAGER OR DELETE ALL

selectWindow("C_I_5_Strip1_MLresults-no-air-2x-small.tif");
setThreshold(152, 152);
//setThreshold(152, 152);
run("Convert to Mask", "method=Default background=Light black");
run("Analyze Particles...", "size=50-Infinity add stack");
setForegroundColor(152, 152, 152);
selectWindow("C_I_5_Strip1_BINARY-8bit.tif");
runMacro("/home/gtrancourt/Dropbox/_github/imagej_macros/macros/fillInside-macro.txt");

run("Save");
