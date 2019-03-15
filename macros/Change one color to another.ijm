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
// Last update: 2019-03-15


Dialog.addNumber("Value to change", 128);
Dialog.addNumber("New value", 85);

val1 = Dialog.getNumber();
val2 = Dialog.getNumber();

setColor(val2,val2,val2);
setThreshold(val1,val1);
run("Create Selection");
fill();
run("Select None");
