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

		if lab$ == "s"
			ini = Get starting point... 2 int
			end = Get end point... 2 int
			dur = end-ini


			editor TextGrid 'name$'
			Select... ini end
			Zoom to selection
			Zoom out

			beginPause: "¿Qué posición ocupa la /s/?"
				comment: "(A) Ataque de palabra"
				comment: "(B) Ataque de sílaba"
				comment: "(C) Coda de silaba + consonante"
				comment: "(D) Coda de palabra + consonante"
				comment: "(E) Coda + vocal"
			
			clicked = endPause: "A", "B", "C", "D", "E", 0
	
				if clicked == 1
					lab$ = "s_at"
				elsif clicked == 2
					lab$ = "s_at_int"
				elsif clicked == 3
					lab$ = "s_cod_int"
				elsif clicked == 4
					lab$ = "s_cod"
				elsif clicked == 5
					lab$ = "s_cod_res"
				endif			
			endeditor

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
