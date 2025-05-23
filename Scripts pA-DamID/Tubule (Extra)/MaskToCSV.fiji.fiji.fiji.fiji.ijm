// ----------------------------------------------------------------------
// Script ImageJ/Fiji - Analyse par batch d’images et export des mesures
//
// Ce script parcourt tous les fichiers image (.tif, .jpg, .png) d’un dossier 
// sélectionné par l’utilisateur. Pour chaque image, il exécute une analyse de régions 
// via le plugin "Analyze Regions", puis sauvegarde les résultats
// dans un fichier CSV individuel, placé dans un sous-dossier "Results".
// 
// Ce script est utile pour traiter automatiquement un grand nombre d’images 
// sans intervention manuelle.
//
// Auteur : Tom Lanchec
// ----------------------------------------------------------------------

dir = getDirectory("Sélectionne le dossier contenant les CSV de résultats");
list = getFileList(dir);

resultsDir = dir + "Results/";
File.makeDirectory(resultsDir);

for (i = 0; i < list.length; i++) {
    filename = list[i];
    path = dir + filename;

    if (endsWith(filename, ".tif") || endsWith(filename, ".jpg") || endsWith(filename, ".png")) {
        open(path);
        run("Analyze Regions", "area perimeter circularity");

        saveAs("Results", resultsDir + filename + "_results.csv");
        run("Close All");
        run("Clear Results");
    }
}
