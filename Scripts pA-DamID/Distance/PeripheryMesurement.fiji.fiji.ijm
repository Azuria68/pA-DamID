originalTitle = getTitle();
run("Split Channels");

C1 = "C1-" + originalTitle; // Canal DAPI
C2 = "C2-" + originalTitle; // Canal tracer

// Dossier de sauvegarde
working_dir = getDirectory("Choisissez le dossier de sauvegarde des résultats");
experiment_dir = working_dir + "distance_analysis_results";
if (!File.exists(experiment_dir)) {
    File.makeDirectory(experiment_dir);
}

// Préparer le fichier CSV pour les résultats
results = "Nucleus,Distance,MeanIntensity\n";

// 1) Segmentation des noyaux (DAPI)
selectWindow(C1);
run("Duplicate...", "title=nuclei");
run("Gaussian Blur...", "sigma=2");
run("Enhance Contrast...", "saturated=0 normalize");
setOption("BlackBackground", false);
run("Make Binary", "method=Li");
run("Fill Holes");

// 2) Définir périphérie nucléaire
selectWindow("nuclei");
run("Duplicate...", "title=periphery");
run("Outline");
run("Dilate");
run("Dilate");

// 3) Génération de la carte de distance
selectWindow("periphery");
run("Distance Map");
rename("DistanceMap");

// 4) Identifier les noyaux
selectWindow("nuclei");
run("Analyze Particles...", "size=2000-Infinity show=Outlines display clear add");
roiCount = roiManager("count");

for (i=0; i<roiCount; i++){
    roiManager("Select", i);

    // Obtenir coordonnées ROI
    getSelectionBounds(x, y, width, height);

    // Extraction signal tracer
    selectWindow(C2);
    run("Duplicate...", "title=tracer_nucleus" + (i+1));
    makeRectangle(x, y, width, height);
    run("Crop");
    rename("tracer_nucleus" + (i+1));

    // Extraction carte distance
    selectWindow("DistanceMap");
    run("Duplicate...", "title=distance_nucleus" + (i+1));
    makeRectangle(x, y, width, height);
    run("Crop");
    rename("distance_nucleus" + (i+1));

    // Sauvegarde images individuelles
    selectWindow("tracer_nucleus" + (i+1));
    saveAs("Tiff", experiment_dir + "/" + originalTitle + "_" + (i+1) + "_tracer.tif");

    selectWindow("distance_nucleus" + (i+1));
    saveAs("Tiff", experiment_dir + "/" + originalTitle + "_" + (i+1) + "_distance.tif");

    // Calcul et ajout des données pour CSV
    selectWindow("distance_nucleus" + (i+1));
    getStatistics(area, mean, min, max);
    for(dist=0; dist<=max; dist++){
        selectWindow("distance_nucleus" + (i+1));
        setThreshold(dist, dist);
        run("Create Selection");

        selectWindow("tracer_nucleus" + (i+1));
        run("Measure");
        meanIntensity = getResult("Mean", nResults-1);
        results += (i+1) + "," + dist + "," + meanIntensity + "\n";
    }
    run("Clear Results");

    close("tracer_nucleus" + (i+1));
    close("distance_nucleus" + (i+1));
}

// Sauvegarder les résultats CSV
File.saveString(results, experiment_dir + "/" + originalTitle + "_distance_intensity.csv");

// Nettoyage
run("Close All");
run("Collect Garbage");
showMessage("Analyse terminée.");