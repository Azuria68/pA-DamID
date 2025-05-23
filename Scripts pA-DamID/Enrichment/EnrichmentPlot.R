# ------------------------------------------------------------------------------
# Script R - Analyse de l'enrichissement en périphérie nucléaire (IF / m6A LBR / Dam only)
#
# Ce script compare les intensités moyennes de signaux (m6A, IF, Dam seul)
# entre la périphérie et l'intérieur des noyaux, pour chaque point de signal.
# L'enrichissement est calculé comme log2(périphérie / intérieur).
#
# Une visualisation par boîte à moustaches + points est générée
# pour comparer les enrichissements selon les conditions.
#
# Auteur : Tom Lanchec
# ------------------------------------------------------------------------------

library(tidyverse)
library(ggbeeswarm)
library(RColorBrewer)

analysis_dir <- '/Users/tom/Downloads/m6A/030325pADamRbLBR/analysis_results/'

periphery_m6A <- read.csv(file.path(analysis_dir, "periphery_m6A.csv"))
interior_m6A  <- read.csv(file.path(analysis_dir, "interior_m6A.csv"))
periphery_IF  <- read.csv(file.path(analysis_dir, "periphery_IF.csv"))
interior_IF   <- read.csv(file.path(analysis_dir, "interior_IF.csv"))
periphery_neg <- read.csv(file.path(analysis_dir, "periphery_neg.csv"))
interior_neg  <- read.csv(file.path(analysis_dir, "interior_neg.csv"))

match_and_compute_enrichment <- function(periphery, interior, label, max_distance = 20) {
  matched <- periphery %>%
    rowwise() %>%
    mutate(interior_mean = mean(interior$Mean[abs(interior$X - X) < max_distance & abs(interior$Y - Y) < max_distance], na.rm = TRUE)) %>%
    filter(!is.na(interior_mean)) %>%
    mutate(enrichment = log2(Mean / interior_mean), marker = label) %>%
    select(marker, enrichment)
  return(matched)
}

m6A_enrichment <- match_and_compute_enrichment(periphery_m6A, interior_m6A, "LBR_m6A")
IF_enrichment  <- match_and_compute_enrichment(periphery_IF, interior_IF, "LBR_IF")
neg_enrichment <- match_and_compute_enrichment(periphery_neg, interior_neg, "neg (Dam)")

combined <- bind_rows(m6A_enrichment, IF_enrichment, neg_enrichment)

plt <- ggplot(combined, aes(x = marker, y = enrichment, color = marker)) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "grey50") +
  geom_quasirandom(size = 1.5) +
  geom_boxplot(width = 0.3, outlier.shape = NA, fill = NA) +
  scale_color_brewer(palette = "Set1") +
  labs(title = "Peripheral vs Interior Enrichment",
       y = "Enrichment (log2)", x = "Marker") +
  theme_bw()

print(plt)

write.table(combined, file = "combined_enrichment_results.txt", 
            sep = "\t", quote = FALSE, row.names = FALSE)
