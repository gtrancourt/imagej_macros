n = roiManager("count"); 
   for (i=0; i<n; i++) { 
      roiManager('select', i); 
      run("Fill", "slice");
   } 