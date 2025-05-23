Scripts d’analyse pA-DamID & imagerie

Ce jeu de scripts a été grandement inspiré par ceux développés par Tom van Schaik, puis modifié et adapté pour les besoins spécifiques de ce projet.
Scripts développés dans le cadre d’un projet sur le rôle de la lamina nucléaire sur la répression des éléments transposables dans les cellules germinales mâle de souris, combinant microscopie, quantification et analyses sous R.

**Arborescence du dépôt 

pA-DamID/
│
├── Scripts pA-DamID/             ← Scripts R pour analyses quantitatives
│   ├── Enrichment                ← Analyse d'enrichissement
│   ├── Gene_Expression           ← Analyse d'expression de gènes de la lamina (RNA-seq)
│   ├── Tubule (Extra)            ← Analyse de l'air des tubules issus de cryosections
│   └── Distance (Extra)          ← Analyse des distances signal/lamina
│
└── README.md                     ← Ce fichier


Organisation des données

    Les images (set minimisé dans ce répertoire pour test des scripts) sont analysées dans Fiji puis exportées sous forme de CSV contenant les mesures (intensité moyenne, coordonnée, etc.).

    Ces CSV sont ensuite analysés dans R pour calculer des enrichissements locaux (log2) ou pour visualiser les profils d’expression.

    Dossiers attendus :

        analysis_results/ avec les fichiers interior_*.csv, periphery_*.csv

        fichiers TPM_values_Sangrithi.xlsx et jh_129_genes_2i_serum.csv pour les profils d’expression

Dépendances
R (packages nécessaires)

    tidyverse

    ggplot2

    ggbeeswarm

    RColorBrewer

    reshape2

    gridExtra

    openxlsx

Fiji (ImageJ)

    Scripts .ijm compatibles avec Fiji avec Bio-Formats installé.

    Les macros utilisent la segmentation de noyaux et des masques binaires pour définir la périphérie ou l’intérieur.

Exemple d'utilisation
Dans Fiji :

// Ouvrir l’image multi-canaux
// Appliquer la macro : Enrichment.ijm
// Obtenir les CSV pour chaque cellule analysée

Dans R :

# Analyse enrichissement périphérie
source("EnrichmentPlot.R")

# Expression des lamines
source("Plot_Expression_LBR.R")

Auteur : 

Tom Lanchec
Master 2 — Université de Strasbourg
Projet réalisé à l’Institut Curie dans l'équipe de Déborah Bourc'his (2025)
📧 tom.lanchec@outlook.fr

