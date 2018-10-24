


run("Analyze Particles...", "size=100-Infinity show=Masks stack");

setAutoThreshold("Default");
//run("Threshold...");
//setThreshold(129, 255);
setOption("BlackBackground", true);
run("Convert to Mask", "method=Default background=Light black");
run("Analyze Particles...", "size=100-Infinity show=Nothing add stack");
selectWindow("C_D_5_Strip3-rec_8bit_0-SEGMENTED.tif");
run("Colors...", "foreground=orange background=yellow selection=yellow");
runMacro("/home/gtrancourt/Dropbox/_github/imagej_macros/macros/fillInside-macro.txt");
//save image
