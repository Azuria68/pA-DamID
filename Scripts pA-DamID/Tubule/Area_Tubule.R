library(ggplot2)
library(dplyr)
library(tidyr)
library(readr)
library(ggpubr)

# Charger les données CSV
combined_data <- read_csv("chemin/vers/votre/dossier/combined_data_corrected.csv")

# Dimensions pour normalisation
dimensions <- tibble(
  Sample = c("1M01-Spin1WT-slide1.1", "1M01-Spin1WT-slide1.2", "1M02-Spin1WT-slide2", "1M03-Spin1WT-slide3.1", 
             "1M04-Spin1WT-slide4.1", "1M04-Spin1WT-slide4.2", "1M05-Spin1WT-slide5.1", "1M05-Spin1WT-slide5.2", 
             "1M06-Annotation2", "1M06-Spin1KO2loxWT-slide1.1", "1M07-Spin1KO2loxWT-slide2.1", "1M07-Spin1KO2loxWT-slide2.2", 
             "1M08-AnnotationSpin1KO2loxWT-slide3.1", "1M08-Spin1KO2loxWT-slide3.2", "1M09-Spin1KO2loxWT-slide4.1", 
             "1M09-Spin1KO2loxWT-slide4.2", "1M10-Spin1KO2loxWT-slide5.1", "1M10-Spin1KO2loxWT-slide5.2", "1M11-Spin1KO2lox-slide1.1", 
             "1M11-Spin1KO2lox-slide1.2", "1M12-Spin1KO2lox-slide2.1", "1M12-Spin1KO2lox-slide2.2", "1M13-Spin1KO2lox-slide3.1", 
             "1M13-Spin1KO2lox-slide3.2", "1M14-Spin1KO2lox-slide4.1", "1M14-Spin1KO2lox-slide4.2", "1M15-Spin1KO2lox-slide5.1", 
             "1M15-Spin1KO2lox-slide5.2"),
  Width = rep(1280, 28),
  Height = c(979, 1006, 1088, 1090, 1145, 1067, 1020, 1168, 1179, 1116, 1109, 1109, 1067, 1200, 1090, 1126, 1138, 1135, 1147, 1126, 1152, 1180, 1280, 1159, 1063, 1067, 1085, 1073)
)

# Normaliser les données
combined_data <- combined_data %>%
  left_join(dimensions, by = "Sample") %>%
  mutate(NormalizationFactor = (1280 * 1280) / (Width * Height),
         Area_Norm = Area * NormalizationFactor,
         Perimeter_Norm = Perimeter * sqrt(NormalizationFactor))

# Mesures d'intérêt
mesures <- c("Area_Norm", "Perimeter_Norm", "Circularity", "EulerNumber", 
             "GeodesicDiameter", "Tortuosity", "AverageThickness", "GeodesicElongation")

# Adapter les données
long_data <- combined_data %>%
  pivot_longer(cols = all_of(mesures), names_to = "Variable", values_to = "Value") %>%
  drop_na(Value) %>%
  filter(Value != 0) %>%
  mutate(Group = factor(case_when(
    grepl("Spin1WT", Sample) ~ "Spin1WT",
    grepl("Spin1KO2loxWT", Sample) ~ "Spin1KO2loxWT",
    grepl("Spin1KO2lox(?!WT)", Sample, perl=TRUE) ~ "Spin1KOlox",
    TRUE ~ NA_character_
  ), levels = c("Spin1WT", "Spin1KO2loxWT", "Spin1KOlox"))) %>%
  filter(!is.na(Group))

# Définir couleurs
colors <- c("Spin1WT" = "#4DAF4A", "Spin1KO2loxWT" = "#56B4E9", "Spin1KOlox" = "#E69F00")

# Générer les boxplots avec test statistique
for (mesure in mesures) {
  p <- ggplot(long_data %>% filter(Variable == mesure), aes(x = Group, y = Value, fill = Group)) +
    geom_boxplot(width = 0.6, color = "black") +
    theme_minimal() +
    labs(title = mesure, x = "Groupe", y = mesure) +
    scale_fill_manual(values = colors) +
    stat_summary(fun.data = function(y) data.frame(y = min(y) - 0.1*(max(y)-min(y)),
                                                   label = paste0("n=", length(y))),
                 geom = "text", size = 4.5, color = "black") +
    stat_compare_means(method = "kruskal.test", label.y = max(long_data$Value, na.rm = TRUE) * 1.05, size=5) +
    stat_compare_means(method = "wilcox.test", comparisons = list(c("Spin1WT", "Spin1KO2loxWT"),
                                                                  c("Spin1KO2loxWT", "Spin1KOlox"),
                                                                  c("Spin1WT", "Spin1KOlox")),
                       label = "p.signif") +
    theme_minimal() +
    theme(
      axis.text = element_text(size = 12),
      axis.title = element_text(size = 14, face = "bold"),
      legend.position = "none"
    )
    
  # Sauvegarder les graphiques
  ggsave(filename = paste0(mesure, "_grouped_boxplot.jpg"), plot = p, width = 6, height = 5, dpi = 300)
}

print("Boxplots avec tests statistiques enregistrés avec succès.")
