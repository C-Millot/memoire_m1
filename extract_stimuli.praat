﻿clearinfo

# Ce script nous a servi à obtenir les extraits répondant à nos attentes en termes de voyelle,
# type de phonation et durée.

# acquisition des enregistrements
path_sons$ = "/home/carole/Documents/mini-memoire/44100_mono/"
path_grilles$ = "/home/carole/Documents/mini-memoire/a_envoyer_a_anais/"
regexp$ = path_sons$ + "PTSVOX_LG024*.wav"
qualite$ = "s"

liste = Create Strings as file list: "fileList", "'regexp$'"
nb_files = Get number of strings

# fichier qui recevra l'extrait vocalique
extract_01_s = Create Sound from formula: "extract_01_s", 1, 0, 0.1, 44100, "0"

# création d'une boucle qui parcourt chaque fichier
for a from 1 to nb_files
	select 'liste'
	fichier$ = Get string: a
	full_fichier_son$ = path_sons$ + fichier$
	full_fichier_grille$ = path_grilles$ + fichier$ - ".wav" + ".corr.textgrid"

	son = Read from file: "'full_fichier_son$'"
	grille = Read from file: "'full_fichier_grille$'"

	nb_intervalles5 = Get number of intervals: 5

# si la voyelle trouvée par le script a une certaine configuration (ici, un /œ/), un certain type de phonation, un certain contexte et
# une certaine durée, elle est extraite
	for b from 1 to nb_intervalles5
		select grille
		voyelle$ = Get label of interval: 5, b
		if (voyelle$ = "eu_final")
			start_time = Get start time of interval: 5, b
			end_time = Get end time of interval: 5, b
			milieu = (start_time+end_time)/2
			intervalle_6 = Get low interval at time: 6, milieu
			vq$ = Get label of interval: 6, intervalle_6
			duree = end_time-start_time
			if (vq$ = qualite$ and duree >= 0.15)
        			select son
        			soundExtract = Extract part: start_time, end_time, "rectangular", 1, "no"
#select extract_ss_eu_m
#plus soundExtract
#Concatenate recoverably
			endif
		endif
	endfor
	selectObject: son
	plusObject: grille
	Remove
endfor
