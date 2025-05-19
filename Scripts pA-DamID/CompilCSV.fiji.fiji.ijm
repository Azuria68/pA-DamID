// Sélectionner le dossier contenant les CSV de résultats
csvDir = getDirectory("Sélectionne le dossier contenant les CSV de résultats");
csvList = getFileList(csvDir);

// Préparer la table compilée
compilation = "Image,Label,Area,Perimeter,Circularity\n";

// Parcourir et compiler chaque fichier CSV
for (i = 0; i < csvList.length; i++) {
    csvFile = csvList[i];
    if (endsWith(csvFile, ".csv")) {
        fileContent = File.openAsString(csvDir + csvFile);
        lines = split(fileContent, "\n");

        // Ignorer l'en-tête et ajouter les données à la compilation
        for (j = 1; j < lines.length; j++) {
            if (lines[j] != "") {
                compilation += csvFile + "," + lines[j] + "\n";
            }
        }
    }
}

// Sauvegarder la compilation
compiledPath = csvDir + "Compilation_globale.csv";
File.saveString(compilation, compiledPath);

// Message final
showMessage("Terminé!", "Résultats compilés et sauvegardés en :\n" + compiledPath);