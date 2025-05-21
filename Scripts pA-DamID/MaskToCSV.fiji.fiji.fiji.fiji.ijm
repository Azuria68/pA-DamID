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
