//*****************************************************************
//By: Alireza Lajevardipour
// Date: 29 January 2015
//Open raw files (obi files) and their related ROI files in a folder by turn then read ROIs from ROI Manager and anlysis ROIs via FD Math.. (Correlation) then save data in different xls files related to ROI numbers.
//Before running macro, ROIs must be adjusted in ROI Manager. the last ROI should be adjusted to measure background noise (there won't be a xls file for it).
// StackReg plugin has been used to alighn slices in stack
//********************************************************************

SampleNo_dif = "01"; //Need to be adjusted for each sample
SampleNo = "S" + getString("Sample#", SampleNo_dif); //read sample#

N_Img_in_Stack = 20; // Need to be adjusted Number of images in a stack
N_Using_Img = 20;  //Need to be adjusted; Number of images which will be used in analysis
ROI_Size = 64;    // Size of ROI 64*64 or 32*32
AutoCorr_Portion = 3/4;  //Portion of autocorrelation image for analysis
Centre_ROI = ROI_Size*(1 - AutoCorr_Portion)/2;
Registration=false;
fileType="tif";//"tif"; //"oib"


sdir = getDirectory("Choose a Directory"); //getDirectory("image");
list1 = getFileList(sdir);

for (img=0; img<list1.length; img++) {
        roiManager("reset");
        if (endsWith(list1[img], "."+fileType) & (File.exists(sdir+"RoiSet"+"_"+replace(list1[img],fileType,"zip")))){
           //open(dir+list1[i]);
           run("Bio-Formats (Windowless)","open=["+sdir+list1[img]+"]");
           fileID = getImageID();
           if(isOpen(fileID))
           {
           //showMessage("title", getImageID());
            SampleStackName=File.nameWithoutExtension;
            SampleStackNameFull = File.name;
            rename(SampleStackNameFull);         
           	
           	if (Registration) {
           	run("StackReg", "transformation=[Translation]"); // run plugin to align slices
           	run("Remove Slice Labels");
           	run("Green");}
           	run("Remove Slice Labels");
           	roiManager("Open", sdir+"RoiSet"+"_"+SampleStackName+".zip");
           	n_ROI = roiManager("count");
			roiManager("Show All with labels");

			for (ii=0; ii<n_ROI; ii++) {
			     jj=ii+1;
			     roiManager("select", ii);
			     CropImgName= SampleNo+"_"+SampleStackName+"_ROI_"+jj;
			     ddir = sdir+CropImgName;
			     selectWindow(SampleStackNameFull);
			     run("Duplicate...", "title = CropImgName duplicate frames=1-"+N_Using_Img);
			     rename(CropImgName+".tif");
			     saveAs("Tiff",ddir+".tif");
			     roiManager("Deselect");
			     selectWindow(SampleStackNameFull);
			     run("Select None");
			};

			for (i=0; i<n_ROI-1; i++){
				j=i+1;
				run("Clear Results");
				CropImgName = SampleNo+"_"+SampleStackName+"_ROI_"+j+".tif";
				if (!isOpen(CropImgName)) {
			    		exit(CropImgName + " is not open!");
				}
				selectWindow(CropImgName);
				run("Select None");
				run("Plot Z-axis Profile");
				namm0="Plot Z-axis Profile_"+j;
				saveAs("jpeg", sdir+SampleNo+"_"+SampleStackName+"_"+namm0);
				close();
				selectWindow(CropImgName);
				run("Stack to Images");
				run("Select None");
				UnstackedImgName= SampleNo+"_"+SampleStackName+"_ROI_"+j;
				
				for (k=1;k<= N_Using_Img; k++){
				
				if (k<10) {
					kk="000"+k;} 
				else {
					kk="00"+k;}
				
				run("FD Math...", "image1=["+UnstackedImgName+"-"+kk+"] operation=Correlate image2=["+UnstackedImgName+"-"+kk+"] result=FDMath_"+k+" do");
				if (k<61){
					namm9="AutoCorrelation_"+j+"_"+kk;
					saveAs("jpeg", sdir+SampleNo+"_"+SampleStackName+"_"+namm9);
					rename("FDMath_"+k);}
				}
				namm="AutoCorrelation_"+j;
				run("Images to Stack", "name="+namm+" title=FDMath use");
				//saveAs("Tiff", sdir+SampleNo+"_"+SampleStackName+"_"+namm);
				//rename(namm);
				//selectWindow(namm);
				makeRectangle(Centre_ROI, Centre_ROI, ROI_Size*AutoCorr_Portion, ROI_Size*AutoCorr_Portion);
				run("Plot Profile");
				selectWindow(namm);     
				setOption("Stack position", true); //sets stack position in the  Set Measurements…
				for (n=1; n<=nSlices; n++) {
			          	setSlice(n);
			          	run("Measure"); //Calculates and dispalys Resutl Table, based on activated options in the Set Measurements… 
			      	}
			      	//waitForUser;
			        namm2="Plot of AutoCorrelation_"+j;
			      	selectWindow(namm2);
			        saveAs("jpeg", sdir+SampleNo+"_"+SampleStackName+"_"+namm2);
			        //rename();
			      	close();
			      	selectWindow("Results");
			      	run("Input/Output...", "jpeg=100 gif=-1 file=.csv save_column save_row");
				saveAs("Results", sdir+SampleNo+"_ExtractedData_"+SampleStackName+"_ROI_"+j+".xls");
				close("*-00*");
				//close("FDMath*");
				run("Clear Results");
				close("Auto*");
			};
			CropImgName = SampleNo+"_"+SampleStackName+"_ROI_"+n_ROI+".tif";
			selectWindow(CropImgName);
			run("Statistics");
			close(CropImgName);
			//run("Clear Results");
			//close("Results");
			selectWindow(SampleStackNameFull);
			run("Statistics");
			selectWindow("Results");
			//run("Clear Results");
			//close("Results");
           };

           close(SampleStackNameFull);        
           print(list1[img]);
           };
 };
