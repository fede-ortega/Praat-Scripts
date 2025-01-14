		str = Create Strings as file list... str *.wav
nstr = Get number of strings

result$ = "tablaResultados.csv"

filedelete 'result$'
fileappend "'result$'" participante;frase;repeticion;segmento;duracion;formante1;formante2
fileappend "'result$'" 'newline$'

for istr from 1 to nstr
select str

	so$ = Get string... istr
	name$ = so$ - ".wav"
	tg$ = name$ + ".TextGrid"

	partic$ = left$(name$,2)

	sentence$ = mid$(name$,9,2)
	sentenc_num = number(sentence$)
	
	rep$ = right$(name$,1)
	rep_num = number(rep$)

	so = Read from file... 'so$'
	tg = Read from file... 'tg$'


# El número 4 es cuántos formantes a calcular
# El número 3800 es el tope de Hz:
	select so
	noprogress To Formant (burg)... 0 4 3800 0.025 50
	frmnt = selected("Formant")

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
			# Esto último es cuál es el punto medio de la vocal
			# Calcula el punto de inicio de la vocal + 0.5 * duración de la vocal
		
			select frmnt
			f1_50 = Get value at time... 1 punto_50 hertz Linear
			f2_50 = Get value at time... 2 punto_50 hertz Linear
			# Nos guarda en una variable el valor del F1
			# Y el del formante 2

			fileappend "'result$'" 'partic$';'sentenc_num';'rep_num';'lab$';'dur:3';'f1_50:2';'f2_50:2'
			fileappend "'result$'" 'newline$'
		endif

	endfor
	select so
	plus tg
	plus frmnt
	Remove

endfor
select str
Remove
