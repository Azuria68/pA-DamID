🔬 Scripts d’analyse pA-DamID & imagerie

⚠️ Ce jeu de scripts a été grandement inspiré par ceux développés par Tom van Schaik, puis modifié et adapté pour les besoins spécifiques de ce projet.
Scripts développés dans le cadre d’un projet sur la répression des éléments transposables via la lamina nucléaire, combinant microscopie, quantification par ImageJ/Fiji et analyses statistiques sous R.

📁 Contenu du dépôt
🧪 Scripts Fiji / ImageJ (quantification sur images m6A / IF)

Script	Description
CompilCSV.fiji.ijm	Compile automatiquement plusieurs fichiers CSV produits par Fiji après mesure sur images (e.g. mesures d’intensité).
MaskToCSV.fiji.ijm	Extrait les intensités à partir de masques binaires et sauvegarde les valeurs dans un CSV pour chaque noyau.
PeripheryMesurement.fiji.ijm	Mesure l’intensité du signal spécifiquement en périphérie nucléaire après érosion/dilatation.
InteriorVSPeriphery.fiji.ijm	Compare l’intensité en périphérie et intérieur du noyau dans chaque cellule pour différents canaux.

📊 Scripts R (analyse quantitative et visualisation)
Script	Description
PeripheralVSEnrichment.R	Compare le log2 d’enrichissement du signal entre la périphérie et l’intérieur pour différentes conditions (LBR-m6A, LBR-IF, Dam négatif), avec visualisation type beeswarm + boxplot.
Plot_Expression_LBR.R	Trace l’expression des gènes de la lamina (Lbr, Lmnb1, Lmnb2, Lmna) dans les cellules germinales/somatiques au cours du développement gonadique (données RNA-seq TPM). Inclut aussi les ES cells en Serum+LIF.

🗂 Organisation des données

    Les images sont analysées dans Fiji puis exportées sous forme de CSV contenant les mesures (intensité moyenne, coordonnée, etc.).

    Ces CSV sont ensuite analysés dans R pour calculer des enrichissements locaux (log2) ou pour visualiser les profils d’expression.

    Dossiers attendus :

        analysis_results/ avec les fichiers interior_*.csv, periphery_*.csv

        fichiers TPM_values_Sangrithi.xlsx et jh_129_genes_2i_serum.csv pour les profils d’expression

⚙️ Dépendances
🧬 R (packages nécessaires)

    tidyverse

    ggplot2

    ggbeeswarm

    RColorBrewer

    reshape2

    gridExtra

    openxlsx

🧫 Fiji (ImageJ)

    Scripts .ijm compatibles avec Fiji avec Bio-Formats installé.

    Les macros utilisent la segmentation de noyaux et des masques binaires pour définir la périphérie ou l’intérieur.

🔧 Exemple d'utilisation
Dans Fiji :

// Ouvrir l’image multi-canaux
// Appliquer la macro : InteriorVSPeriphery.ijm
// Obtenir les CSV pour chaque cellule analysée

Dans R :

# Analyse enrichissement périphérie
source("PeripheralVSEnrichment.R")

# Expression des lamines
source("Plot_Expression_LBR.R")

✍️ Auteur

Tom Lanchec
Master 2 — Université de Strasbourg
Projet réalisé à l’Institut Curie dans l'équipe de Déborah Bourc'his (2025)
📧 tom.lanchec@outlook.fr

