library(openxlsx)
library(ggplot2)
library(reshape2)
library(gridExtra)

# Définir une palette de couleurs pour chaque gène
mycolors <- c("Lbr"   = "#c0372f",  # rouge
              "Lmnb1" = "#6a8ab9",  # bleu
              "Lmnb2" = "#5aaa46",  # vert
              "Lmna"  = "#984EA3")  # violet

#########################################################################
########################### Gonadal development #########################
#########################################################################

RNAseq <- read.xlsx("TPM_values_Sangrithi.xlsx")
Lamins <- RNAseq[which(RNAseq$gene %in% c("Lbr", "Lmnb1", "Lmnb2", "Lmna")),]

# Extraction des données pour les cellules mâles en excluant XX et "female"
Lamins_Male <- Lamins[, -which(grepl('XX', colnames(Lamins), fixed = TRUE))]
Lamins_Male <- Lamins_Male[, -which(grepl('female', colnames(Lamins_Male), fixed = TRUE))]

# Sélection des cellules somatiques
Lamins_Male_Somatic <- Lamins_Male[, which(grepl('somatic', colnames(Lamins_Male), fixed = TRUE))]
Lamins_Male_Somatic <- Lamins_Male_Somatic[, -which(grepl('non-gonadal', colnames(Lamins_Male_Somatic), fixed = TRUE))]
colnames(Lamins_Male_Somatic) <- sub("\\_.*", "", colnames(Lamins_Male_Somatic))
colnames(Lamins_Male_Somatic)[9] <- "P2"
Lamins_Male_Somatic$gene <- Lamins_Male$gene
Lamins_Male_Somatic <- melt(Lamins_Male_Somatic, "gene")
Lamins_Male_Somatic$variable <- factor(Lamins_Male_Somatic$variable,
                                       levels = c("E9.5", "E11.5", "E12.5", "E14.5", 
                                                  "E15.5", "E16.5", "E18.5", "P2", "P11"))
Lamins_Male_Somatic$value <- as.numeric(Lamins_Male_Somatic$value)

p <- ggplot(Lamins_Male_Somatic, aes(x = variable, y = value, group = gene)) +
  geom_line(aes(color = gene), size = 1.2) +
  geom_point(aes(color = gene), size = 2.5) +
  theme_classic(base_size = 14) +
  ylim(0, 300) +
  ggtitle("Somatic cells") +
  xlab("Gonadal development") +
  ylab("TPM") +
  scale_color_manual(name = "Gene", values = mycolors) +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5, size = 16),
    axis.text.x = element_text(angle = 45, hjust = 1),
    legend.title = element_text(size = 14),
    legend.text  = element_text(size = 12)
  )

# Sélection des cellules germinales
Lamins_Male_germcell <- Lamins_Male[, which(grepl('germ', colnames(Lamins_Male), fixed = TRUE))]
rownames(Lamins_Male_germcell) <- Lamins_Male$gene
colnames(Lamins_Male_germcell) <- sub("\\_.*", "", colnames(Lamins_Male_germcell))
colnames(Lamins_Male_germcell)[c(4, 5, 8)] <- c("E15.5", "E16.5", "P11")
Lamins_Male_germcell$gene <- Lamins_Male$gene
Lamins_Male_germcell <- melt(Lamins_Male_germcell, "gene")
Lamins_Male_germcell$variable <- factor(Lamins_Male_germcell$variable,
                                        levels = c("E9.5", "E11.5", "E12.5", "E14.5",
                                                   "E15.5", "E16.5", "E18.5", "P2", "P11"))
Lamins_Male_germcell$value <- as.numeric(Lamins_Male_germcell$value)

q <-ggplot(Lamins_Male_germcell, aes(x = variable, y = value, group = gene)) +
  geom_line(aes(color = gene), size = 1.2) +
  geom_point(aes(color = gene), size = 2.5) +
  theme_classic(base_size = 14) +
  ylim(0, 300) +
  ggtitle("Germ cells") +
  xlab("Gonadal development") +
  ylab("TPM") +
  scale_color_manual(name = "Gene", values = mycolors) +
  theme(
    plot.title = element_text(hjust = 0.5, size = 16),
    axis.text.x = element_text(angle = 45, hjust = 1),
    legend.title = element_text(size = 14),
    legend.text  = element_text(size = 12)
  )
q

#########################################################################
########################### ESCells in Serum+LIF ########################
#########################################################################

EScells <- read.csv("jh_129_genes_2i_serum.csv")
Serum <- EScells[, c(2, 4)]
Serum$TPM <- (Serum$S_counts / sum(Serum$S_counts)) * 10^6
Serum_Lamins <- Serum[which(Serum$Geneid %in% c("Lbr", "Lmnb1", "Lmnb2", "Lmna")),]

r <- ggplot(data = Serum_Lamins, aes(x = Geneid, y = TPM, fill = Geneid)) +
  geom_bar(stat = "identity") +
  theme_classic(base_size = 14) +
  ggtitle("ESCells in Serum+LIF") +
  xlab("Genes") +
  ylab("TPM") +
  scale_fill_manual(name = "Gene", values = mycolors) +
  theme(
    plot.title = element_text(face = "bold", hjust = 0, size = 16),
    axis.text.x = element_text(angle = 45, hjust = 1),
    legend.title = element_text(size = 14),
    legend.text  = element_text(size = 12)
  )

r
