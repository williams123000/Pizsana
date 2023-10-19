#!/bin/ksh

function Crear_CSV_Login
{
    clear
    if [ -e "Usuarios.csv" ]; then
        echo 
    else
        touch Usuarios.csv
        echo "ID,Usuario,Password,Rol" > Usuarios.csv
    fi
}


function Registrar_Bitacora_Archivo_login
{
    Estado=$1
    ID_Usuario=$2
    Operacion=$3
    echo "Usuario: $ID_Usuario"
    echo "Estado: $Estado"

    cd ../Bitacora
    . ./Bitacora.ksh
    Registrar_Bitacora $ID_Usuario "Login" "$Operacion" $Estado
    cd ../Login
}

function Buscar_Usuario
{
    Usuario=$1
    if grep -qw "$Usuario" Usuarios.csv; then
        return 1
    else 
        return 0
    fi
}

function Buscar_Password
{
    Usuario=$1
    Password=$2
    Resultado=$(awk -F ',' -v user="$Usuario" -v password="$Password" 'BEGIN { found = 0 } $2 == user && $3 == password { found = 1; exit } END { print found }' Usuarios.csv)
    return $Resultado
}

function Buscar_Tipo_Usuario
{
    Usuario=$1
    Resultado=$(awk -F ',' -v user="$Usuario" 'BEGIN { } $2 == user { print $4 } ' Usuarios.csv)
    echo "$Resultado"
}

function Cambiar_Password
{
    Estado=0
    echo "#########################################################"
    echo "##                Cambiar contraseña                   ##"
    echo "#########################################################"
    ID_Usuario=$1
    echo "Usuario: $ID_Usuario"
    echo 
    Registrar_Bitacora_Archivo_login $Estado $ID_Usuario "Cambiar contraseña"

    while true
    do
        STTY_SAVE=`stty -g`
        stty -echo
        echo -n "Contraseña actual: "
        read Password_Actual
        echo
        Buscar_Password $ID_Usuario $Password_Actual
        Resultado=$?
        if [ $Resultado == "1" ]; then
            break
        else
            echo "Contraseña incorrecta!!"
        fi
    done

    echo -n "Nueva contraseña: "
    read Password_Nueva
    echo

    stty $STTY_SAVE
    echo

    awk -v ID="$ID_Usuario" -v Nueva_Password="$Password_Nueva" 'BEGIN { FS=OFS="," } $2 == ID { $3 = Nueva_Password } 1' Usuarios.csv > Usuarios_temp.csv
    mv Usuarios_temp.csv Usuarios.csv           
    Estado=1
    Registrar_Bitacora_Archivo_login $Estado $ID_Usuario "Cambiar contraseña"
    echo "Contraseña actualizada correctamente!!"
    echo "Presione Enter para continuar..."
    read p
        
}

function Actualizar_Usuario
{
    typeset ID_Usuario=$1
    typeset Estado=0
    
    clear
    echo "Actualizar usuario"
    while true
    do
        clear
        echo -e -n "Introduzca el ID a modificar: "
        read Id
        Buscar_Usuario $Id
        Busqueda=$?
        
        if [ $Busqueda == "1" ]; then
            clear
            echo "Datos a modificar"
            echo "1.- Usuario"
            echo "2.- Contraseña"
            echo "3.- Tipo de Rol"
            echo -e -n "Introduzca la opcion a modificar: "
            read Opcion

            case $Opcion in
                1) 
                    echo -e -n "Introduzca tu nuevo usuario: "
                    read Nuevo_Usuario
                    awk -v ID="$Id" -v Nuevo_Usu="$Nuevo_Usuario" 'BEGIN { FS=OFS="," } $1 == ID { $2 = Nuevo_Usu } 1' Usuarios.csv > Usuarios_temp.csv
                    mv Usuarios_temp.csv Usuarios.csv           
                    echo "Usuario modificado!!!"
                    Estado=1
                    Registrar_Bitacora_Archivo_login $Estado $ID_Usuario "Actualizar Usuario"
                    echo "Presione Enter para continuar..."
                    read p
                    ;;
                2)
                    STTY_SAVE=`stty -g`
                    stty -echo
                    echo -n "Introduzca tu nueva contraseña: "
                    read Nueva_Password
                    stty $STTY_SAVE
                    echo                  
                    awk -v ID="$Id" -v Nueva_Pass="$Nueva_Password" 'BEGIN { FS=OFS="," } $1 == ID { $3 = Nueva_Pass } 1' Usuarios.csv > Usuarios_temp.csv
                    mv Usuarios_temp.csv Usuarios.csv
                    echo "Contraseña modificada!!!"
                    Estado=1
                    Registrar_Bitacora_Archivo_login $Estado $ID_Usuario "Actualizar Contraseña de Usuario"
                    echo "Presione Enter para continuar..."
                    read p                  
                    ;;
                3)  
                    clear
                    echo "Tipos de roles:"
                    echo "1.- Administrativo"
                    echo "2.- Usuario"
                    echo -e -n "Introduzca tu nuevo rol: "
                    read Nuevo_Rol
                    if [ $Nuevo_Rol == "1" ]; then
                        Nuevo_Rol="Administrador"   
                    elif [ $Nuevo_Rol == "2" ]; then
                        Nuevo_Rol="Usuario"         
                    else
                        echo "Tipo de rol incorrecto!! "
                        echo "Presione Enter para continuar..."
                        read p
                    fi
                    awk -v ID="$Id" -v Nuevo_Ro="$Nuevo_Rol" 'BEGIN { FS=OFS="," } $1 == ID { $4 = Nuevo_Ro } 1' Usuarios.csv > Usuarios_temp.csv
                    mv Usuarios_temp.csv Usuarios.csv
                    echo "Rol modificado!!!"
                    Estado=1
                    Registrar_Bitacora_Archivo_login $Estado $ID_Usuario "Actualizar Rol de Usuario"
                    echo "Presione Enter para continuar..."
                    read p
                    ;;
                *) 
                    echo "Da una opcion valida!!!"
                    echo "Presione Enter para continuar..."
                    read p
                    ;;
            esac
            break
        else
            Estado=0
            Registrar_Bitacora_Archivo_login $Estado $ID_Usuario "Actualizar Usuario"
            echo "Usuario no existente!!"
            echo "Presione Enter para continuar..."
            read p
        fi
    done
}

function Eliminar_Usuario
{
    typeset ID_Usuario=$1
    typeset Estado=0
    clear
    echo "Eliminar usuario"
    Estado=0
    Registrar_Bitacora_Archivo_login $Estado $ID_Usuario "Dar de baja usuario"
    while true
    do
        clear
        echo -e -n "Introduzca el usuario a eliminar: "
        read Usuario
        Buscar_Usuario $Usuario
        Busqueda=$?
        if [ $Busqueda == "1" ]; then
            awk -v Usuario="$Usuario" 'BEGIN { FS=OFS="," } $1 != Usuario { print }' Usuarios.csv > Usuarios_temp.csv 
            mv Usuarios_temp.csv Usuarios.csv
            echo "Usuario Eliminado!!!"
            Estado=1
            Registrar_Bitacora_Archivo_login $Estado $ID_Usuario "Dar de baja usuario"
            echo "Presione Enter para continuar..."
            read p
            break
        else
            echo "Usuario no existente!!"
            echo "Presione Enter para continuar..."
            read p
        fi
    done

}

function Desplegado_Usuarios
{
    clear
    print "=========================================="
    print "                Usuarios                  "  
    print "=========================================="
    awk -F, 'BEGIN {OFS="\t"} NR==1 {printf "%-5s %-10s %-10s %-10s\n", $1, $2, $3, $4} NR>1 {printf "%-5s %-10s %-10s %-10s\n", $1, $2, $3, $4}' Usuarios.csv
    echo
    echo
    echo "Presione Enter para continuar..."
    read p

}

function Crear_Usuario 
{
    typeset Estado=0
    typeset ID_Usuario=$1

    Registrar_Bitacora_Archivo_login $Estado $ID_Usuario "Crear usuario"
    clear
    echo "Crear usuario"
    while true
    do
        if [ $(wc -l < Usuarios.csv) -eq 1 ]; then
            typeset nuevo_id=1
        else
            # Leer el último ID existente
            typeset ultimo_id=$(tail -n 1 Usuarios.csv | cut -d, -f1)

            # Calcular el nuevo ID sumando 1 al último ID
            typeset nuevo_id=$((ultimo_id + 1))
        fi
        echo -e -n "Introduzca el usuario: "
        read Usuario
        STTY_SAVE=`stty -g`
        stty -echo
        echo -n "Introduzca la contraseña: "
        read Password
        stty $STTY_SAVE
        echo         
        while true
        do
            clear
            echo "Tipos de roles:"
            echo "1.- Administrativo"
            echo "2.- Usuario"
            echo -e -n "Introduzca el tipo de rol: "
            read Rol
            if [ $Rol == "1" ]; then
                Rol="Administrador"
                break
            elif [ $Rol == "2" ]; then
                Rol="Usuario"
                break
            else
                echo "Tipo de rol incorrecto!! "
                echo "Presione Enter para continuar..."
                read p
            fi
        done
        Estado=1

        Registrar_Bitacora_Archivo_login $Estado $ID_Usuario "Crear usuario"
        echo "$nuevo_id,$Usuario,$Password,$Rol" >> Usuarios.csv
        break
 
    done
    
    echo "Presione Enter para continuar..."
    read p
}

Crear_CSV_Login
