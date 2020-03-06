// Crop microCT scans made at the TOMCAT beamline of the Swiss Light Source
//
// Author: Guillaume Théroux-Rancourt (guillaume.theroux-rancourt@boku.ac.at)
// Created on 25.02.2020

  function pad(n) {
      str = toString(n);
      while (lengthOf(str)<5)
          str = "0" + str;
      return str;
  }

 function cropSLS(input, output, filename, a, b, c, d) {
 	open(input + "/" + filename);
 	makeRectangle(a, b, c, d);
 	run("Crop");
 	saveAs("Tiff", output + filename);
 	close(); 	
 }

// Select a folder to import
dir = getDirectory("Choose a Directory");
print(dir);

// Create the new directories
File.makeDirectory(dir + "/rec_16bit_0_cropped");
File.makeDirectory(dir + "/rec_16bit_Paganin_0_cropped");

// Open gridrec directory as virtual stack
run("Image Sequence...", "open=[" + dir + "/rec_16bit_0] sort use");

setTool("rectangle");
waitForUser("Draw the region around the leaf\nalong the full stack.");
getSelectionBounds(x, y, width, height);
print(x, y, width, height);

input = dir + "/rec_16bit_0";
output = dir + "/rec_16bit_0_cropped/";

setBatchMode(true); 
list = getFileList(input);
for (i = 0; i < list.length; i++)
// 		showProgress(i, list.length-1);
		cropSLS(input, output, list[i], x, y, width, height);
setBatchMode(false);

input = dir + "/rec_16bit_Paganin_0";
output = dir + "/rec_16bit_Paganin_0_cropped/";

setBatchMode(true); 
list = getFileList(input);
for (i = 0; i < list.length; i++)
// 		showProgress(i, list.length-1);
		cropSLS(input, output, list[i], x, y, width, height);
setBatchMode(false);

close("*");
showMessage("Done!");
