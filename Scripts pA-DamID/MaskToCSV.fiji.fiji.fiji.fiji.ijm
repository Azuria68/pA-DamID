// Sélectionner le dossier contenant les images
dir = getDirectory("Sélectionne le dossier contenant les CSV de résultats");
list = getFileList(dir);

// Créer un dossier pour les résultats
resultsDir = dir + "Results/";
File.makeDirectory(resultsDir);

// Boucle sur chaque fichier du dossier
for (i = 0; i < list.length; i++) {
    filename = list[i];
    path = dir + filename;

    if (endsWith(filename, ".tif") || endsWith(filename, ".jpg") || endsWith(filename, ".png")) {
        open(path);
        run("Analyze Regions", "area perimeter circularity");

        // Enregistrer les résultats
        saveAs("Results", resultsDir + filename + "_results.csv");
        run("Close All");
        // Nettoyer les résultats avant la prochaine boucle
        run("Clear Results");
    }
}
