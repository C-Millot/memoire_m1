library(tidyverse)
library(tcltk)
library(writexl)

experimentResultsFilesColumnNames <- c("stimuli", "voix", "correct", "likert")

# choix du dossier contenant les données à traiter
data_dir <- tk_choose.dir(default = getwd(), caption = "Choix du dossier avec les fichiers de données (ouvrez le dossier avant de valider)")
# on vérifie qu'un dossier a bien été choisi et qu'il contient au moins le fichier data.csv
if(!is.na(data_dir)) {
  data_csv_full_path <- paste0(data_dir, .Platform$file.sep, "data.csv")
  if(file.exists(data_csv_full_path)) {
    # lecture du fichier data.csv (avec désactivation des messages d'avertissement car la ligne d'en-tête inclut une virgule finale superflue)
    main_dataset <- suppressWarnings(read_csv(data_csv_full_path, col_types = cols()))
    n_participants <- nrow(main_dataset)
    # renommage des colonnes correspondant aux questions initiales, et recodage de 
    main_dataset <- main_dataset %>% 
      rename(
        responses_file = `Test:1`
      )
    # élimination des participants ayant arrêté après la partie questionnaire
    main_dataset <- main_dataset %>% 
      filter(!is.na(responses_file))
    # traitement des réponses de chaque participant
    participant_responses_lst <- list()
    for(participant_responses_file in main_dataset %>% pull(responses_file)) {
      participant_responses_path <- paste0(data_dir, .Platform$file.sep, participant_responses_file)
      if(file.exists(participant_responses_path)) {
        # lecture du fichier individuel de réponses
        participant_responses_lst[[participant_responses_file]] <- read_delim(
          participant_responses_path,
          delim = " ",
          col_names = experimentResultsFilesColumnNames,
          col_types = cols()
        ) %>% 
          # suppression des réponses non valides (absence de réponse)
          #filter(statutReponse!=3) %>% 
          # recodage et ajout d'informations complémentaires
          mutate(
            # ajout d'une colonne avec le nom du fichier de réponses
            responses_file = participant_responses_file,
            # numérotation des stimuli pour garder l'ordre de présentation
            ordre_presentation_stimulus = row_number()
          )
      } else
        message(paste0("File ", participant_responses_file, " not  found in folder ", data_dir))
    }
    # fusion des réponses de l'ensemble des participants en un seul tableau de données
    participant_responses <- bind_rows(participant_responses_lst)
    # intégration au tableau principal
    main_dataset <- main_dataset %>% 
      left_join(participant_responses, by = "responses_file")
    # export dans un fichier Excel, avec nombre de participants, date et heure dans le nom de fichier
    write_xlsx(main_dataset, path = paste0("resultats_experience_psytoolkit_", n_participants, "participants_", str_replace_all(str_replace_all(Sys.time(), " ", "_"), ":", "-"), ".xlsx"), format_headers = F)
}
