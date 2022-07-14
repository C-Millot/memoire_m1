clearinfo

# Ce script prend tous les fichiers .wav et .TextGrid d'un dossier, repère toutes les voyelles de chaque fichier
# (selon la tier qu'on lui a indiquée) et enregistre dans un fichier le type de phonation qui lui est associé
# (on prend celui indiqué au début de la voyelle et aussi à la fin, au cas où il soit changeant) ainsi que son
# contexte, sa durée et son point temporel de début dans l'enregistrement.

# création d'un fichier résultat
fichier_resultat$ = "resultat_tableau_occurrences.txt"

fileappend 'fichier_resultat$' fichier'tab$'voyelle'tab$'label_vq1'tab$'label_vq2'tab$'phon_prec'tab$'phon_suiv'tab$'duree'tab$'temps'newline$'

# acquisition des enregistrements
path_sons$ = "/home/carole/Documents/mini-memoire/44100_mono/"
path_grilles$ = "/home/carole/Documents/mini-memoire/a_envoyer_a_anais/"
regexp$ = path_sons$ + "*.wav"


liste = Create Strings as file list: "fileList", "'regexp$'"
nb_files = Get number of strings

# création d'une boucle qui parcourt chaque fichier
for a from 1 to nb_files
	select 'liste'
	fichier$ = Get string: a
	full_fichier_son$ = path_sons$ + fichier$
	full_fichier_grille$ = path_grilles$ + fichier$ - ".wav" + ".corr.textgrid"



	son = Read from file: "'full_fichier_son$'"
	grille = Read from file: "'full_fichier_grille$'"


	nb_intervalles5 = Get number of intervals: 5

# boucle qui trouve chaque voyelle d'un fichier et renseigne son type de phonation éventuellement changeant) ainsi que son
# contexte, sa durée et son point temporel de début dans l'enregistrement
	for b from 1 to nb_intervalles5
		voyelle$ = Get label of interval: 5, b
		if (voyelle$ != "" and voyelle$ != " " and voyelle$ != "	")
			start_time = Get start time of interval: 5, b
			end_time = Get end time of interval: 5, b
			duree = round((end_time-start_time)*1000)
			milieu = (start_time+end_time)/2
			interval_1 = Get low interval at time: 1, milieu
			phon_prec$ = Get label of interval: 1, interval_1-1
			phon_suiv$ = Get label of interval: 1, interval_1+1
			interval_6_debut = Get low interval at time: 6, start_time+0.01
			interval_6_fin = Get low interval at time: 6, end_time-0.01
			vq1$ = Get label of interval: 6, interval_6_debut
			vq2$ = Get label of interval: 6, interval_6_fin
			if vq2$ = vq1$
				vq2$ = ""
			endif

			fileappend 'fichier_resultat$' 'fichier$''tab$''voyelle$''tab$''vq1$''tab$''vq2$''tab$''phon_prec$''tab$''phon_suiv$''tab$''duree''tab$''start_time''newline$'
	
		endif

	endfor

endfor



printline FINI