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

   function processFiles(dir) {
      list = getFileList(dir);
      for (i=0; i<list.length; i++) {
          if (endsWith(list[i], "/")) {
              if (startsWith(list[i], "rec")) {
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
          else 
			  processFiles(""+dir+list[i]);
      }
  }

  function processFile(path) {
       if (startsWith(path, "rec")) {
       		print(parentPath + path);
       		scanName = split(parentPath, File.separator);
       		scanName = scanName[scanName.length - 1];
       		print("Scan Name: " + scanName);
       		recName = split(path, File.separator);
       		recName = recName[0];
       		print("rec name: " + recName);
       		run("Image Sequence...", "dir="+ parentPath + "/" + path + " start=50 step=200 sort");
			saveAs("Tiff", basedir + "previews/" + scanName + recName + ".tif");
      }
  }