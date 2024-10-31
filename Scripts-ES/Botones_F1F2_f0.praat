listaArchivos = Create Strings as file list... listaArchivos *.wav
numeroArchivo = Get number of strings

result$ = "tablaResultados.csv"

filedelete 'result$'
fileappend "'result$'" participante;frase;acentoLexico;formante1;formante2;F0
fileappend "'result$'" 'newline$'

for num from 1 to numeroArchivo
	select listaArchivos

	archivo$ = Get string... num
	sinWav$ = archivo$ - ".wav"
	textgrid$ = sinWav$ + ".TextGrid"

	partic$ = left$(sinWav$,2)
	sentence$ = mid$(sinWav$,7,4)

	so = Read from file... 'archivo$'
	tg = Read from file... 'textgrid$'

	select so
	noprogress To Formant (burg)... 0 5 5500 0.25 50
	formants = selected("Formant")

	select so
	noprogress To Pitch... 0 75 600
	pitch = selected("Pitch")

	select tg
	nint = Get number of intervals... 1

	select so
	plus tg
	View & Edit

	for int from 1 to nint
		select tg
		lab$ = Get label of interval... 1 int

		if lab$ = "e"
			ini = Get starting point... 1 int
			end = Get end point... 1 int
			dur = end-ini
			punto_50 = ini + (0.5*dur)
		
			select formants
			f1_50 = Get value at time... 1 punto_50 hertz Linear
			f2_50 = Get value at time... 2 punto_50 hertz Linear
			
			select pitch
			f0 = Get mean... ini end Hertz

			editor TextGrid 'sinWav$'
				Select... ini end
				Zoom to selection
				Zoom out
				
				beginPause: "¿Tónica o átona?"
				
				clicked = endPause: "Tónica", "Átona", 0
				
				if clicked == 1
					acentoLexico$ = "tonica"
				elsif clicked == 2
					acentoLexico$ = "atona"
				endif

			endeditor

			fileappend "'result$'" 'partic$';'sentence$';'acentoLexico$';'f1_50:2';'f2_50:2';'f0:2'
			fileappend "'result$'" 'newline$'
		endif

	endfor
		select so
		plus tg
		plus formants
		Remove

endfor
select listaArchivos
Remove
