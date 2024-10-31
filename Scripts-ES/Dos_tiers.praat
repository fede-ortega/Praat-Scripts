listaArchivos = Create Strings as file list... listaArchivos *.wav
numeroArchivo = Get number of strings

for num from 1 to numeroArchivo
    select listaArchivos

	archivo$ = Get string... num
	sinWav$ = archivo$ - ".wav"
	textgrid$ = sinWav$ + ".TextGrid"

	if !fileReadable(textgrid$)
	so = Read from file... 'archivo$'
	tg = To TextGrid... "palabra silaba"

	select so
    plus tg
	View & Edit
	pause

    Save as text file... 'textgrid$'
	
	plus so
	Remove
	endif
endfor
select listaArchivos
Remove
