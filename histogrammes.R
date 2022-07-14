library(sciplot)
library(languageR)
library(readxl)
library(ggplot2)

# Ce script construit des histogrammes montrant les mesures h1-h2 de chaque script.

# histogrammes selon le locuteur
data <- read_excel("h1h2_scripts_pivotr.xlsx")

ggplot(data, aes(fill=Script, y=Locuteur_1, x=Type_de_phonation)) +
geom_bar(position="dodge", stat="identity") +
  scale_fill_manual("Scripts", values = c("moyenne_script_auto_version_auto" = "deeppink4", "moyenne_script_auto_version_manuelle" = "darkorange", "script_manuel" = "aquamarine4"), labels = c("Script NasalityAutoMeasure version automatique", "Script NasalityAutoMeasure version manuelle", "Notre script")) +
  xlab("Type de phonation")+ scale_x_discrete(labels=c("craquee" = "Craqué", "modale" = "Modal", "soufflee" = "Soufflé")) + ylab("Amplitude h1 - Amplitude h2")

# histogrammes selon la voyelle
data_voyelles <- read_excel("h1h2_scripts_pivotr_voyelles.xlsx")

ggplot(data_voyelles, aes(fill=Script, y=`Voyelle /e/`, x=`Type de phonation`)) + 
  geom_bar(position="dodge", stat="identity") +
  scale_fill_manual("Scripts", values = c("moyenne_script_auto_version_auto" = "deeppink4", "moyenne_script_auto_version_manuelle" = "darkorange", "script_manuel" = "aquamarine4"), labels = c("Script NasalityAutoMeasure version automatique", "Script NasalityAutoMeasure version manuelle", "Notre script")) +
  xlab("Type de phonation")+ scale_x_discrete(labels=c("craquee" = "Craqué", "modale" = "Modal", "soufflee" = "Soufflé")) + ylab("Amplitude h1 - Amplitude h2")

# histogramme pour l'entièreté des mesures
data_total <- read_excel("h1h2_scripts_pivotr_total.xlsx")

ggplot(data_total, aes(fill=Script, y=Total_stimuli, x=Type_de_phonation)) +
  geom_bar(position="dodge", stat="identity") +
  scale_fill_manual("Scripts", values = c("moyenne_script_auto_version_auto" = "deeppink4", "moyenne_script_auto_version_manuelle" = "darkorange", "script_manuel" = "aquamarine4"), labels = c("Script NasalityAutoMeasure version automatique", "Script NasalityAutoMeasure version manuelle", "Notre script")) +
  xlab("Type de phonation")+ scale_x_discrete(labels=c("craquée" = "Craqué", "modale" = "Modal", "soufflée" = "Soufflé")) + ylab("Amplitude h1 - Amplitude h2")
