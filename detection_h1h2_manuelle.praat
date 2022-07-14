# Ce script permet de sélectionner manuellement h1 et h2 dans un fichier son avec TextGrid, et ainsi
# obtenir h1-h2.

# création d'un fichier (les résultats seront renseignés dedans)
fichier_resultats$ = "resultats_h1_h2_manuel.xls"
fileappend 'fichier_resultats$' 'nom_fichier''tab$''h1''tab$''h2''tab$''h1-h2''newline$'


# acquisition des enregistrements
path$ = "C:\Users\Carole\Pictures\Autres\Travail\M1 S2\minimem\mem-20220303T171225Z-001\mem"
path_regexp$ = path$ + "\*.wav" 
string_files = Create Strings as file list: "fileList", "'path_regexp$'"
nb_files = Get number of strings



# création d'une boucle qui parcourt chaque fichier
for a from 1 to nb_files
	select 'string_files'
	file$ = Get string: a
	full_path_son$ = path$ + "\" + file$
	full_path_grille$ = path$ + "\" + file$ - "wav" + "TextGrid"
	son = Read from file: "'full_path_son$'"
	duree_tot = Get total duration
# on prend le milieu du fichier son qu'on extrait (50ms en tout) avec une fenêtre gaussienne. On prend son spectre et on obtient sa f0
	milieu = duree_tot/2
	extraction_pour_spectre = Extract part: milieu-0.025, milieu+0.025, "Gaussian1", 1, "yes"
	spectre = To Spectrum: "no"
	select 'son'
	analyse_f0 = To Pitch: 0, 75, 600
	f0 = Get value at time: milieu, "Hertz", "Linear"
	text_a_afficher$ = "'f0:0'" + "__" + "'file$'" - ".wav"
	grille = Read from file: "'full_path_grille$'"




# dans une fenêtre Demo, on affiche le spectre et on enregistre les coordonnées sur lesquelles clique l'utilisateur
demo Erase all
demo Black
demo Axes: 0, 100, 0, 100

demo Select outer viewport: 0, 100, 0, 100
select 'spectre'

demo Draw: 0, 1000, 0, 0, "yes"
demo Marks bottom: 6, "yes", "yes", "no"
demo Text top: "no", "'text_a_afficher$'"


compteur = 0

while demoWaitForInput ( )
    if demoClicked ( )

	compteur = compteur + 1
	if compteur = 1
	h1_frep = demoX ( )
	h1_amp = demoY ( )
	elsif compteur = 2
	h2_frep = demoX ( )
	h2_amp = demoY ( )
	endif
	endif

	if compteur = 2
	diff_h1_h2 = h1_amp - h2_amp
	goto END
	endif

   endif
endwhile


label END
demo Erase all



# on ajoute les résultats au fichier final
fileappend 'fichier_resultats$' 'file$''tab$''h1_amp:2''tab$''h2_amp:2''tab$''diff_h1_h2:2''newline$'

select 'son'
plus 'grille'
plus 'extraction_pour_spectre'
plus 'spectre'
plus 'analyse_f0'
Remove

endfor




exit




clear all