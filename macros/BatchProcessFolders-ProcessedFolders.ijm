// ADAPTED FROM https://imagej.nih.gov/ij/macros/BatchProcessFolders.txt
//
// "BatchProcessFolders"
//
// This macro batch processes all the files in a folder and any
// subfolders in that folder. In this example, it runs the Subtract 
// Background command of TIFF files. For other kinds of processing,
// edit the processFile() function at the end of this macro.

   requires("1.33s"); 
   dir = getDirectory("Choose a Directory");
   basedir = dir
   print("baseDir = " + basedir);
   print(File.isDirectory(basedir + "previews/"));


   if (File.isDirectory(basedir + "previews/") == 0)
   		File.makeDirectory(basedir + "previews/");
  
   setBatchMode(true);
   count = 0;
   countFiles(dir);
   n = 0;
   processFiles(dir);
   //print(count+" files processed");
   
   function countFiles(dir) {
      list = getFileList(dir);
      for (i=0; i<list.length; i++) {
          if (endsWith(list[i], "/"))
              countFiles(""+dir+list[i]);
          else
              count++;
      }
  }

print("Done counting files!");

   function processFiles(dir) {
      list = getFileList(dir);
      for (i=0; i<list.length; i++) {
              if (endsWith(list[i], "8bit.tif.zip")) {
              	print("dir: " + dir);
              	print(list[i]);
              	parentPath = File.getParent(dir + list[i]);
              	print("parent Path: " + parentPath);
              	//processFiles(""+dir+list[i]);
              	processFile(list[i]);
              }
              else 
				processFiles(""+dir+list[i]);
      }
  }

  function processFile(path) {
       if (endsWith(list[i], "GRID-8bit.tif.zip")) {
       		print(parentPath + path);
       		scanName = split(parentPath, File.separator);
       		scanName = scanName[scanName.length - 1];
       		print("Scan Name: " + scanName);
       		recName = split(path, File.separator);
       		recName = recName[0];
       		print("rec name: " + recName);
       		open(parentPath + "/" + path);
       		getDimensions(width, height, channels, slices, frames);
       		// Below is to change channels to slices: this happens sometimes
       		// when saving in Python and opening in ImageJ
       		if (channels>1) {
				run("Properties...", "channels="+slices+" slices="+channels+" frames=1 unit=pixel pixel_width=1.0000 pixel_height=1.0000 voxel_depth=1.0000");
				slices = channels;
       		}
			run("Make Substack...", "slices=1-" + slices + "-100");
			saveAs("Tiff", basedir + "previews/" + scanName + recName + ".tif");
			close("*");
      }
  }
