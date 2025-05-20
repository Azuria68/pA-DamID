originalTitle = getTitle();
run("Split Channels");

C1 = "C1-" + originalTitle; // DAPI
C2 = "C2-" + originalTitle; // m6A

working_dir = getDirectory("Choisissez le dossier de sauvegarde des résultats");
experiment_dir = working_dir + "analysis_results";
if (!File.exists(experiment_dir)) {
    File.makeDirectory(experiment_dir);
}

selectWindow(C1);
run("Duplicate...", "title=nuclei");
run("Gaussian Blur...", "sigma=1");
run("Enhance Contrast...", "saturated=0 normalize");
setOption("BlackBackground", false);
run("Make Binary");
run("Fill Holes");

selectWindow("nuclei");
run("Duplicate...", "title=periphery");
run("Erode");
run("Outline");
run("Dilate");
run("Dilate");
run("Dilate");

imageCalculator("Subtract create", "nuclei", "periphery");
selectWindow("Result of nuclei");
rename("interior");

run("3D OC Options", "volume integrated_density mean_gray_value median_gray_value redirect_to=[" + C2 + "]");

selectWindow("periphery");
run("3D Objects Counter", "threshold=128 slice=1 min.=10 max.=1048576 exclude_objects_on_edges statistics");
rename("Result");
saveAs("Results", experiment_dir + "/" + originalTitle +  "_periphery_IF.csv");
//run("Close");

selectWindow("interior");
run("3D Objects Counter", "threshold=128 slice=1 min.=10 max.=1048576 exclude_objects_on_edges statistics");
rename("Result");
saveAs("Results", experiment_dir + "/" + originalTitle + "_interior_IF.csv");
//run("Close");

//run("Close All");
//run("Collect Garbage");
showMessage("Analyse terminée.");
