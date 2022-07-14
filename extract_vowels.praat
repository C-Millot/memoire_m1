clearinfo

# Ce script permet d'obtenir des extraits d'un enregistrement selon la voyelle, son type de phonation ("qualite$")
# et son contexte.

# acquisition des enregistrements
path_sons$ = "/home/carole/Documents/mini-memoire/44100_mono/"
path_grilles$ = "/home/carole/Documents/mini-memoire/a_envoyer_a_anais/"
regexp$ = path_sons$ + "*.wav"
qualite$ = "m"

liste = Create Strings as file list: "fileList", "'regexp$'"
nb_files = Get number of strings

# fichier qui recevra l'extrait vocalique
extract_ss_eu_m = Create Sound from formula: "extract_ss_eu_m", 1, 0, 0.1, 44100, "0"


# création d'une boucle qui parcourt chaque fichier
for a from 1 to nb_files
	select 'liste'
	fichier$ = Get string: a
	full_fichier_son$ = path_sons$ + fichier$
	full_fichier_grille$ = path_grilles$ + fichier$ - ".wav" + ".corr.textgrid"

	son = Read from file: "'full_fichier_son$'"
	grille = Read from file: "'full_fichier_grille$'"

	nb_intervalles5 = Get number of intervals: 5

# si la voyelle trouvée par le script a une certaine configuration (ici, un /œ/), un certain type de phonation
#  et un certain contexte, elle est extraite
  for b from 1 to nb_intervalles5
    select grille
    voyelle$ = Get label of interval: 5, b
    if (voyelle$ = "eu_final")
      start_time = Get start time of interval: 5, b
			end_time = Get end time of interval: 5, b
			milieu = (start_time+end_time)/2
			intervalle_6 = Get low interval at time: 6, milieu
      vq$ = Get label of interval: 6, intervalle_6
      intervalle_1 = Get low interval at time: 1, milieu
			contexte$ = Get label of interval: 1, intervalle_1-1
      if (vq$ = qualite$ and contexte$ = "ss")
        select son
        soundExtract = Extract part: start_time, end_time, "rectangular", 1, "no"
#        select extract_ss_eu_m
#        plus soundExtract
#        Concatenate recoverably
      endif
    endif
  endfor
	selectObject: son
	plusObject: grille
	Remove
endfor