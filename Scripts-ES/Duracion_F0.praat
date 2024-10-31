# Guardar el script en la carpeta donde tenemos los audios!!!

# IMPORTANTE SINTAXIS PRAAT: 
# La creación de una variable que contenga texto lleva el signo del dólar $
# Para hacer comentarios en la misma línea del codigo, NO podemos usar el símbolo #, sino que debemos usar ;
# Praat distingue entre comillas simples y comillas dobles
	# Comillas simples = cuando una variable de texto es el argumento de una función
		# Utilizar una variable de texto (con el signo del dólar) con una función requiere comillas simples
		# excepto cuando va entre esta va entre paréntesis
	# Comillas dobles = cualquier cadena de texto debe ir entre comillas dobles



# 1. LEER ARCHIVOS DE AUDIO
# Hacemos una lista con todos los archivos .wav de la carpeta
str = Create Strings as file list... str *.wav
# Creamos una lista con todos los archivos que están dentro de la carpeta
# Queremos leer todos los archivos que estén dentro de una carpeta uno a uno
# Str es cadena de caracteres
# El asterisco es un comodín que significa cualquier caracter que vaya antes de .wav

# Con esto se nos crea un objeto que es una lista de strings de los audios

# Contamos cuántos archivos se han listado de esa carpeta
# Guarda el número total de archivos abiertos en una variable a la que llamamos nstr
nstr = Get number of strings


# 1.1 Preparamos la tabla de datos donde queremos guardar las variables
# Creamos una variable de texto llamada results$ como indica el signo del dólar con el nombre 
# que queremos que tenga nuestro archivo con los resultados
result$ = "results.csv"

# Borramos algún archivo que se pueda llamar igual para que se cree uno nuevo
filedelete 'result$'

# Le indicamos los nombres de las columnas que deben aparecer en la tabla:
fileappend 'result$' participante;frase;repeticion;duracion_L;f0
# El newline indica que siga a una línea de abajo para que siga haciendo lo mismo
# newline siempre debe ir en comillas simples
fileappend "'result$'" 'newline$'


# 2. NOMBRE DE ARCHIVOS Y EXTRACCIÓN DE CADENAS (STRINGS)
# 2.1 Bucle para pasar por cada uno de los archivos hasta el último (nstr)
# Estamos indicando que vaya por cada item (istr) desde el 1 hasta el final (nstr)
for istr from 1 to nstr


# 2.2 Para que el bucle pueda recorrer los nombres que están en la lista, 
# primero hay que seleccionarla con select str:
	select str


# 2.3 Extraer los nombres de los archivos
so$ = Get string... istr
name$ = so$ - ".wav"
tg$ = name$ + ".TextGrid"


# 2.4 Extraer la información del nombre del archivo para las variables
	# participante
	partic$ = left$(name$,2)
	# Guardamos esto en una variable seguida de dólar

	# identificador de la frase
	sentence$ = mid$(name$,9,2)
	sentenc_num = number(sentence$)
	# empieza a contar desde la posición 9, que entra dentro de la cuenta
	# por tanto cuenta la 9
	# el 2 significa que desde la nueve incluyéndola, contará ese y el siguiente caracter

	# identificador de la repetición
	rep$ = right$(name$,1)
	rep_num = number(rep$)

# Como el valor resultante que devuelven left$, right$ y mid$ es siempre texto hay que reconvertir 
# el número de frase y el número de repetición con la función number()



# 3. MEDICIONES
# Abrir los archivos y leer el TextGrid
so = Read from file... 'so$'
# Para esta tarea en concreto no es necesario abrir el sound object
tg = Read from file... 'tg$'


# 3.1 MEDICIONES DE F0
# Seleccionamos el archivo de audio que figure en el cuadro de objetos
	select so

# Establecemos los valores que vamos a emplear
	noprogress To Pitch... 0 75 600 # que no ejecute sino que guarde los ajustes en una variable llamada Pitch
	pitch = selected("Pitch")

	select tg
	nint = Get number of intervals... 1
	# Cuenta cuántas anotaciones hay hechas en ese TextGrid


# 3.2 MEDICIONES DE DURACIÓN
# Bucle para extraer los valores de duración de cada etiqueta
	for int from 1 to nint
	# Cuenta cuántos intervalos hay y cuando lo tengas empieza a correr por todos ellos
		select tg
		lab$ = Get label of interval... 1 int # dime la segmentación que está escrita en cada intervalo
	
# Calcular la duración para cada segmento /l/ en cada archivo
	if lab$ = "l" # si encuentras una "l", hazme lo siguiente:
		ini = Get starting point... 1 int # mide punto de inicio del intervalo
		end = Get end point... 1 int # mide punto de final del intervalo
		# El 1 indica que debe mirar la primera tira de intervalos (por si hay más de 1)
		# aunque haya sólo 1, hay que poner 1 igualmente
		dur = end-ini

		endif


# 3.3 SELECT PITCH PARA MEDIR F0
# Para medir otro intervalo diferente, por ejemplo "e":
if lab$ = "e"
	ini = Get starting point... 1 int
	end = Get end point... 1 int

# En el caso de que esta etiqueta sea diferente, por ejemplo "e", recuperamos los valores 
# que definimos previamente para medir f0 mediante select pitch
	select pitch

#  Luego obtenemos el valor medio de f0 para todos los segmentos “e” mediante la función 
# Get mean..., que toma tres valores: el punto inicial del segmento, calculado previamente como ini, 
# el del final end y el valor por defecto Hertz.
f0 = Get mean... ini end Hertz



# 3.4 Guardar los datos en la tabla
# Los valores de f0, y todos los demás que hayamos calculado previamente,
# deben ser guardados en la table antes de cerrar la condición con endif
fileappend 'result$' 'partic$';'sentenc_num'; 'rep_num'; 'dur:3'; 'f0'; 'newline$'
endif ; lab$ = "e"

endfor ; to nint

endfor ; lab$ = "l"


# 3.5 Borrar los archivos del cuadro de objetos
	select so
	plus tg
	plus pitch
	Remove
endfor ; to nstr

select str
Remove