# Guardar el script en la carpeta donde tenemos los audios!!!

# IMPORTANTE SINTAXIS PRAAT: 
# La creación de una variable que contenga texto lleva el signo del dólar $
# Para hacer comentarios en la misma línea del codigo, NO podemos usar el símbolo #, sino que debemos usar ;
# Praat distingue entre comillas simples y comillas dobles
	# Comillas simples = cuando una variable de texto es el argumento de una función
		# Utilizar una variable de texto (con el signo del dólar) con una función requiere comillas simples
		# excepto cuando va entre esta va entre paréntesis
	# Comillas dobles = cualquier cadena de texto debe ir entre comillas dobles



# PARA CAMBIAR LOS kHz CUANDO HAY PROBLEMA DE COMPATIBILIDAD MAC - WINDOWS --------------------------------------------
# Problemas de compatibilidad: cuando grabamos audios en Praat, en Mac se graban a 44000 kHz y en Windows a 48000 kHz
# Y en Windows no se leen los de Mac


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



# 2. NOMBRE DE ARCHIVOS Y SELECCIÓN
# 2.1 Bucle para pasar por cada uno de los archivos hasta el último (nstr)
# Estamos indicando que vaya por cada item (istr) desde el 1 hasta el final (nstr)
for istr from 1 to nstr


# 2.2 Para que el bucle pueda recorrer los nombres que están en la lista, 
# primero hay que seleccionarla con select str:
	select str


# 2.3 Extraer los nombres de los archivos
so$ = Get string... istr
name$ = so$ - ".wav"


# 2.3 Abrir cada archivo de audio
so = Read from file... 'so$'

# Debemos seleccionarlo para poder operar con él
select so



# 3. CAMBIAR kHz
# 3.1 Creamos la variable con el comando
resample = Resample... 48000 1

# 3.2 Guardar el archivo nuevo con el nombre de archivo
Save as WAV file... 'so$'

endfor ; bucle nstr
select str
Remove




# FORMA 2 DE HACERLO
# Para Mac va bien, pero en Windows no se puede mirar
# El problema de hacer esto es que los guarda con el mismo nombre
# Por tanto, lo mejor es hacerlo así:

str = Create Strings as file list... str *.wav
nstr = Get number of strings

for istr from 1 to nstr
select str

so$ = Get string... istr
name$ = so$ - ".wav"
guardar$ = name$ + "new_sample" + ".wav"

so = Read from file... 'so$'
select so
resample = Resample... 48000 1

Save as WAV file... 'guardar$'
select so
plus resample
Remove
filedelete 'so$'

endfor
select str
Remove
