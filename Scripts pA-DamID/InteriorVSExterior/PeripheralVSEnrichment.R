# Chargement des librairies
library(tidyverse)
library(ggbeeswarm)
library(RColorBrewer)

# Dossier des données
analysis_dir <- '/Users/tom/Downloads/m6A/030325pADamRbLBR/analysis_results/'

# Lecture des fichiers CSV
periphery_m6A <- read.csv(file.path(analysis_dir, "periphery_m6A.csv"))
interior_m6A  <- read.csv(file.path(analysis_dir, "interior_m6A.csv"))
periphery_IF  <- read.csv(file.path(analysis_dir, "periphery_IF.csv"))
interior_IF   <- read.csv(file.path(analysis_dir, "interior_IF.csv"))
periphery_neg <- read.csv(file.path(analysis_dir, "periphery_neg.csv"))
interior_neg  <- read.csv(file.path(analysis_dir, "interior_neg.csv"))

# Fonction pour appariement et calcul d'enrichissement
match_and_compute_enrichment <- function(periphery, interior, label, max_distance = 20) {
  matched <- periphery %>%
    rowwise() %>%
    mutate(interior_mean = mean(interior$Mean[abs(interior$X - X) < max_distance & abs(interior$Y - Y) < max_distance], na.rm = TRUE)) %>%
    filter(!is.na(interior_mean)) %>%
    mutate(enrichment = log2(Mean / interior_mean), marker = label) %>%
    select(marker, enrichment)
  return(matched)
}

# Calcul enrichissement pour chaque condition
m6A_enrichment <- match_and_compute_enrichment(periphery_m6A, interior_m6A, "LBR_m6A")
IF_enrichment  <- match_and_compute_enrichment(periphery_IF, interior_IF, "LBR_IF")
neg_enrichment <- match_and_compute_enrichment(periphery_neg, interior_neg, "neg (Dam)")

# Combinaison de toutes les conditions
combined <- bind_rows(m6A_enrichment, IF_enrichment, neg_enrichment)

# Graphique enrichissements
plt <- ggplot(combined, aes(x = marker, y = enrichment, color = marker)) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "grey50") +
  geom_quasirandom(size = 1.5) +
  geom_boxplot(width = 0.3, outlier.shape = NA, fill = NA) +
  scale_color_brewer(palette = "Set1") +
  labs(title = "Peripheral vs Interior Enrichment",
       y = "Enrichment (log2)", x = "Marker") +
  theme_bw()

print(plt)

# Sauvegarde résultats
write.table(combined, file = "combined_enrichment_results.txt", 
            sep = "\t", quote = FALSE, row.names = FALSE)
