listaArchivos = Create Strings as file list... listaArchivos *.wav
numeroArchivo = Get number of strings

result$ = "tablaResultados.csv"

filedelete 'result$'
fileappend "'result$'" participante;frase;segmento;duracion
fileappend "'result$'" 'newline$'

for num from 1 to numeroArchivo
select listaArchivos
# AO_S01td04_1
	so$ = Get string... num
	name$ = so$ - ".wav"
	tg$ = name$ + ".TextGrid"

	partic$ = left$(name$,2)

	sentence$ = mid$(name$,7,4)


# 4. Abrir los archivos y leer el TextGrid
	so = Read from file... 'so$'
	tg = Read from file... 'tg$'

	select tg
	nint = Get number of intervals... 2

	plus so
	View & Edit

	for int from 1 to nint
		select tg
		lab$ = Get label of interval... 2 int

		if index(lab$, "s")
			ini = Get starting point... 2 int
			end = Get end point... 2 int
			dur = end-ini


			fileappend "'result$'" 'partic$';'sentence$';'lab$';'dur:2'
			fileappend "'result$'" 'newline$'
		endif

	endfor
	select so
	plus tg
	Remove

endfor
select listaArchivos
Remove
