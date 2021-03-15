// Replace one color with another
//
// Macro taken from
// http://imagej.1557.x6.nabble.com/change-pixel-values-within-a-macro-td5002663.html
//
// Will ask the user what value to change, and the new value to replace with.
// Works on single images and stacks.
//
// Current form created by: Guillaume Théroux-Rancourt
// Created on: 2019-03-15
// Last update: 2021-01-28

Dialog.create("Change one color to another");
Dialog.addNumber("Value to change", 30);
Dialog.addNumber("New value", 0);
Dialog.show();

val1 = Dialog.getNumber();
val2 = Dialog.getNumber();

setBatchMode(true);
setColor(val2,val2,val2);
setThreshold(val1,val1);
for (i=1; i<nSlices+1;i++) {
  setSlice(i);
  run("Create Selection");
  fill();
  run("Select None");
}
setBatchMode(false);
