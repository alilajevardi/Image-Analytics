IJ.run("ROI Manager...", "");
rm.runCommand("Save", "C:\\Users\\alajevardipour\\Documents\\MyPhD\\Microscopy Data\\2014 Protein Structure\\S124\\RoiSet.zip");

imp = IJ.openImage("C:\\Users\\alajevardipour\\Documents\\MyPhD\\Microscopy Data\\2014 Protein Structure\\S124\\Image0002.oib");
rm.runCommand("Show All with labels");
rm.runCommand("Show All");

rm.select(0);
imp = new Duplicator().run(imp, 1, 1, 1, 1, 1, 20);
imp.close();
rm.runCommand("Show None");
rm.runCommand("Deselect");

IJ.run(imp, "Plot Z-axis Profile", "");
IJ.saveAs(imp, "Jpeg", "C:\\Users\\alajevardipour\\Documents\\MyPhD\\Microscopy Data\\2014 Protein Structure\\S124\\Image0002-1.tif-0-0.jpg");
imp.close();
IJ.run("Stack to Images", "");
IJ.run("FD Math...", "image1=Image0002-1-0001 operation=Correlate image2=Image0002-1-0001 result=[FD Math 01] do");
IJ.run("FD Math...", "image1=Image0002-1-0002 operation=Correlate image2=Image0002-1-0002 result=[FD Math 02] do");
IJ.run("FD Math...", "image1=Image0002-1-0003 operation=Correlate image2=Image0002-1-0003 result=[FD Math 03] do");
IJ.run("Stack to Images", "");
IJ.run(imp, "Images to Stack", "name=Stack title=[FD Math] use");
imp.setRoi(6, 6, 19, 20);
IJ.run(imp, "Plot Profile", "");
IJ.run("Set Measurements...", "");
IJ.run(imp, "Measure", "");
IJ.run(imp, "Measure", "");
IJ.run(imp, "Measure", "");
IJ.run("Input/Output...", "jpeg=100 gif=-1 file=.csv save_column save_row");
IJ.saveAs("Results", "C:\\Users\\alajevardipour\\Documents\\MyPhD\\Microscopy Data\\2014 Protein Structure\\S124\\Results.csv");
imp.close();

IJ.run("Input/Output...", "jpeg=100 gif=-1 file=.csv save_column save_row");
IJ.run("Set Measurements...", "area mean standard modal min center stack redirect=None decimal=3");


IJ.run("Select All", "");
rm.runCommand("Delete");
IJ.run("Close");

