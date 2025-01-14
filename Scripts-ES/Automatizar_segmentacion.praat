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


# 2. EL NOMBRE DE CADA ARCHIVO
# Bucle para pasar por cada uno de los archivos hasta el último (nstr)
# Estamos indicando que vaya por cada item (istr) desde el 1 hasta el final (nstr)
for istr from 1 to nstr

# Para que el bucle pueda recorrer los nombres que están en la lista, 
# primero hay que seleccionarla con select str:
	select str

# Vamos a extraer el nombre del archivo incluyendo su extensión
	# sound_object - para hacerlo más corto lo abreviamos como so
	# es una variable de texto así que necesita el símbolo $
	# Queremos que ahora se extraigan los nombres de los archivos, porque hasta ahora
	# sólo hemos hecho una lista con los archivos que hay sin abrirlos
	# Para abrirlos debemos saber cómo se llaman:
	so$ = Get string... istr
	# so = sound object
	# $ = variable de texto, lo que contenga esa variable será texto
	# Por tanto, nos da el nombre de cada uno de los archivos, no la lista de todos

	# Obtenemos el nombre del archivo sin la extensión
	nombre$ = so$ - ".wav"

	# Le añadimos la extensión del TextGrid al nombre del archivo para guardarlo
	tg$ = nombre$ + ".TextGrid"

# Como no sabemos si la variable es correcta o no:
# Debugging!!
	# El siguiente comando comprueba qué valor está guardado en la variable de texto
	# primero limpiamos cualquier cosa que pueda estar impresa en la consola
	clearinfo
	# y luego imprimimos el valor de la variable (símbolo $ si la variable es texto)
	appendInfoLine(tg$)

# Al ejecutarlo en Praat, 
# se ve lo que contiene la variable por las que acabamos de preguntar

# El debugging sirve para comprobar que el código es correcto
# Al usar en combinación clearinfo + appendInfoLine es asegurarnos que las variables
# que están dentro del bucle contienen lo que deben contener
# Es simplemente para asegurarnos de que los archivos con los que trabajamos
# están bien y tienen los valores que queremos

# Tenemos también las variables ultimo y str, y podemos pedir dentro del
# argumento (del paréntesis) de appendInfoLine que nos dé la info, ejemplo:
# appendInfoLine(str)



# 3. SEGMENTAR CON VIEW & EDIT
# Todo esto debe estar dentro del bucle for!!!!
	# Con el nombre que hemos extraído de cada archivo abrimos el audio y creamos 
	# un ‘sound object’ en el cuadro de objetos de Praat junto al TextGrid donde vamos a segmentar


# 3.1 INTERRUMPIR EL SCRIPT
# En el caso de que tengamos que cerrar todo y lo queremos volver a abrir otro día
# Volverá a abrir el primer archivo aunque ya hayamos trabajado con él
# Queremos que abra el archivo desde el que nos hemos quedado, por lo que
# creamos una condición:
	if !fileReadable(tg$)
	# ! = "si no te encuentras a un archivo que se llame así"
	# Si el archivo en concreto no existe en la carpeta, abrirá el audio,
	# creará el textgrid y podremos trabajar con él


	# Abrimos el archivo que se llame como so$
	# y usamos comillas simples cuando una variable de texto es el argumento de una función
	so = Read from file... 'so$'
	# Queremos leer el archivo de audio
	# Aquí tenemos la variable de antes pero sin el símbolo de dolar
	# El "so" es lo que tendremos resaltado en el cuadro de diálogo y ya no tendrá
	# el nombre del audio sino "so"


	# Creamos el TextGrid
	tg = To TextGrid... segmentacion
	# Los puntos suspensivos significan que abrirá un cuadro de diálogo
	# después de los tres puntos debemos poner lo que pondríamos en la cajita 

	# Si queremos crear 2 tiras de TextGrid en lugar de una, debemos agruparlas en comillas dobles
	# tg = To TextGrid... "palabras segmentos"


	# Selecciona el audio y el tg a la vez del cuadro de objetos para segmentarlos
	select so
	plus tg

	# Se abre la ventana para editar y segmentar el audio y deja el bucle en una pausa
	View & Edit

	# La pausa crea un cuadro de diálogo con los botones stop y Continue
	# para que presionemos Continue después de haber hecho la segmentación manualmente
	pause


	# Para que Praat guarde la segmentación cuando apretemos "continue" y nos lleve
	# al siguiente archivo a segmentar, debemos añadir las siguientes líneas.
	# Seleccionamos el TextGrid y lo guardamos con el nombre de la variable tg$
	# Esta variable tenía la extensión ".TextGrid"
	select tg
	Save as text file... 'tg$'

	# Añadimos lo que acabamos de crear en la lista de objetos y lo eliminamos
	plus so
	Remove
	# "Remove" borra todos los archivos que hemos ido creando en el cuadro de objetos de Praat

endif ; bucle de if
endfor ; bucle de istr
select str
Remove