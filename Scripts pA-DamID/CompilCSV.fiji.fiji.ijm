// ----------------------------------------------------------------------
// Script ImageJ/Fiji - Compilation automatique de résultats CSV
//
// Ce script permet de compiler automatiquement les fichiers CSV de résultats issus d'analyses ImageJ
// présents dans un dossier sélectionné par l'utilisateur. 
//
// Il produit un fichier regroupant toutes les lignes 
// de résultats des différents fichiers, en les annotant avec le nom de l’image 
// associée (déduit du nom du fichier CSV).
//
// Auteur : Tom Lanchec
// ----------------------------------------------------------------------

csvDir = getDirectory("Sélectionne le dossier contenant les CSV de résultats");
csvList = getFileList(csvDir);

compilation = "Image,Label,Area,Perimeter,Circularity\n";

for (i = 0; i < csvList.length; i++) {
    csvFile = csvList[i];
    if (endsWith(csvFile, ".csv")) {
        fileContent = File.openAsString(csvDir + csvFile);
        lines = split(fileContent, "\n");

        for (j = 1; j < lines.length; j++) {
            if (lines[j] != "") {
                compilation += csvFile + "," + lines[j] + "\n";
            }
        }
    }
}

compiledPath = csvDir + "Compilation_globale.csv";
File.saveString(compilation, compiledPath);

showMessage("Terminé!", "Résultats compilés et sauvegardés en :\n" + compiledPath);
