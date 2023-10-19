#!/bin/ksh

# Williams Chan Pescador 2193076730
# Equipo X-Men
# "X-Men: Transformando Código en Realidad, ¡Programamos el Mañana!
#########################################
#      Script Del Modulo Principal      #
# El cual es el encargado de saber si   #
# el que desea entrar es un usuario o   #
# Admin. Cada uno tiene su propio menu  #
# asi tambien como funciones diferen-   #
# tes dentro.                           #
#########################################
# Contiene la funcion para registrar en #
# bitacora el inicio de sesion          #
#########################################

export FPATH="$(pwd)/../lib"
autoload configurarColor
autoload Graficos_Pizza

function Registrar_Bitacora_Archivo
{
    Estado=$1
    ID_Usuario=$2
    echo "Usuario: $ID_Usuario"
    echo "Estado: $Estado"

    cd ./Bitacora
    . ./Bitacora.ksh
    Registrar_Bitacora $ID_Usuario "MenuPrincipal" "Iniciar Sesion" $Estado
    cd ..
}

while true
do
    
    clear
    configurarColor negrita
    configurarColor textocolor azul
    Graficos_Pizza    
    configurarColor textocolor verde
    echo -e -n "Usuario: "
    read Usuario 
    configurarColor reset
    cd ./Login
    . ./Login.ksh
    Buscar_Usuario $Usuario 
    Busqueda=$?
    cd ..

    if [ $Busqueda == "1" ]; then
        while true
        do  
            Estado_Bitacora=0
            
            clear
            STTY_SAVE=`stty -g`
            stty -echo
            Registrar_Bitacora_Archivo $Estado_Bitacora $Usuario
            configurarColor textocolor verde
            echo -n "Contraseña: "
            read Password
            configurarColor reset
            stty $STTY_SAVE
            echo
            cd ./Login
            . ./Login.ksh
            Buscar_Password $Usuario $Password
            Busqueda=$?
            cd ..
            if [ $Busqueda == "1" ]; then
                break
            else
                configurarColor textocolor rojo
                echo "Contraseña invalida"
                echo -e -n "Presione Enter para continuar..."
                read p
                configurarColor reset
            fi
        done
        break
    else
        configurarColor textocolor rojo
        echo "Usuario no existente!!"
        echo -e -n "Presione Enter para continuar..."
        read p
        configurarColor reset
    fi
    #break
done
cd ./Login
. ./Login.ksh
Rol=$(Buscar_Tipo_Usuario $Usuario)
cd ..
Estado_Bitacora=1
Registrar_Bitacora_Archivo $Estado_Bitacora $Usuario
echo -e -n "Presione Enter para continuar..."
read p
configurarColor reset
if [ "$Rol" == "Administrador" ]; then
    configurarColor textocolor magenta
    configurarColor negrita
    . ./Menu_Admin.ksh $Usuario
    configurarColor reset
    
else
    configurarColor textocolor cyan
    configurarColor negrita
    . ./Menu_Usuario.ksh $Usuario
    configurarColor reset

fi
