
# 🕺 Hasheito 💃 

Hasheito es un generador de codigos hash md5, sha2, sha3, blank3 para archivos y directorios. Fue hecho con Lua y Love2d en una noche de delirio mistico, pocas horas de sueño, mucha cafeína y algo de IA.

⚠️ **PROFE:** En el caso de que no pueda ejecutarlo le dejo [un video](https://drive.google.com/file/d/1dcUSjSQzLVu9CyKfLfLHq9zBoGRKQcZE/view?usp=sharing) mostrando las funcionalidades. Se ve un poco lento pero es por mi pc.⚠️

## **Consideraciones previas:**
* Necesita Ubuntu linux 24.04.02 para ejecutarlo.
* Los txt con los hasheos se crearan en el escritorio.
* La fecha y hora del hasheo están en el nombre del txt siendo por ej: `Hasheito_nombre_año-mes-dia-hora-minutoss-segundos.txt`
* Una vez que clickea fuera para arrastrar el archivo/directorio la ventana pierde el 'foco' por lo que a veces debe hacer un doble click para apretar los botones. (No se puede cambiar es una restriccion del os). Ya saben:
    * **Un click** para volver a poner el 'foco' en la ventana.
    * **Otro click** para apretar el botón. 

## Instalación

1. **Ingresar al [repositorio de github](https://github.com/Enzo-Ro-Haus/Hasheito).**

2. **Acceder a la carpeta ['Descargas'](https://github.com/Enzo-Ro-Haus/Hasheito/tree/main/Descargar)**

3. **Descargar el paquete que desee:**
* **.AppImg:** No requiere instalación. (Recomendado)
* **.deb:** Requiere instalación.
* **.love:** Requiere de love en su sistema linux.

4. **Instalación & Ejecución**
* **Con AppImg:**
    1. Una vez descargado el archvio abrimos una terminal en la carpeta contenedora.
    2. Le otorgamos privilegios con: `chmod -x Hasheito-x86_64.AppImage`
    3. Y luego ejecutamos con el comando: `./Hasheito-x86_64.AppImage`
    4. Si todo a salido correctamente vera la ventana de inicio.

* **Con .deb:**
    1. Una vez descargado el archvio abrimos una terminal en la carpeta contenedora.
    2. Instalamos el programa con el comando:`sudp dpkg -i hasheito_1.0_all.deb` 
    3. Una vez finalizada la instalacion lo ejecutamos con el comando:`hasheito`
    4. Si todo a salido correctamente vera la ventana de inicio.

* **Con love:**
    1. Una vez descargado el archivo .love abra la terminal.
    2. Descargue Love2D en su OS:
* **En Ubunto:** 
1. Instale el repositorio de love en su sistema. `sudo add-apt-repository ppa:bartbes/love-stable`
    2. Instale love `sudo apt install love`
    3. En la carpeta en la que se encuentr el archivo .love abra la terminal.
    4.  si todo salió bien verá la ventana de inico.
* **Otros sistemas operativos:**
1. Descarge e instale Love2D desde su web oficial [love2d.org](https://love2d.org)
2. Ejecute el archivo .love en caso de que no funciones abra la terminal en el directorios donde se encuentra Hasheito.love y ejecute el comando `love Hasheito.love`


4. **Desintalación**
* **Con AppImage:** Solo borre el archivo descargado.
* **Con .deb:** Utilice el comando `sudo apt remove hasheito`
* **Con .love:**
    1.  Borre el archivo.
    2.  Elimine love de su sustema con `sudo apt remove love`
    3. Elimine el repositorio de su sistema con ` sudo rm /etc/apt/sources.list.d/bartbes-ubuntu-love-stable-noble.sources` (Puede variar según su Os).

## Instrucciones de uso:
1.  Una vez abierto el programa arraste su archivo o directorio a la ventana donde hay texto.
2. Automaticamente se generará sus hasheos tanto en la pantalla como en un archivo txt en su Escritorio.
3. Puede copiar la información en pantalla con el botón de **Copiar**.
4. Si lo desea puede borrar la información con el botón de **Borrar**.
5. Y también puede salir precionando el botón **Salir**.

### Espero que les sea de utilidad! ☝️🥸🤏