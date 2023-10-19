#!/bin/ksh

# Williams Chan Pescador
# Equipo X-Men
#
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
    tput sgr0  
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
            echo -n "Contraseña: "
            read Password
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
                echo "Contraseña invalida"
                echo -e -n "Presione Enter para continuar..."
                read p
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
if [ "$Rol" == "Administrador" ]; then
    
    . ./Menu_Admin.ksh $Usuario
else
    . ./Menu_Usuario.ksh $Usuario

fi
