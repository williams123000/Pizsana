#!/bin/ksh

function Crear_CSV_Productos
{
    clear
    if [ -e "Productos.csv" ]; then
        echo
    else
        touch Productos.csv      
        echo "ID,Nombre,Tamaño,Cantidad,Precio" > Productos.csv  
    fi
}

function Registrar_Bitacora_Archivo_Productos
{
    Estado=$1
    ID_Usuario=$2
    Operacion=$3
    echo "Usuario: $ID_Usuario"
    echo "Estado: $Estado"

    cd ../Bitacora
    . ./Bitacora.ksh
    Registrar_Bitacora $ID_Usuario "Productos" "$Operacion" $Estado
    cd ../Producto
}

function Buscar_Producto
{
    Id=$1
    if grep -qw "$Id" Productos.csv; then
        return 1
    else 
        return 0
    fi
}

function Modificar_Cantidad
{
    typeset Estado=0
    typeset ID_Usuario=$1

    while true
    do
        clear
        Desplegado_Productos
        print "======================================================="
        print "             Dar entrada a producto                    "  
        print "======================================================="
        echo 
        echo -e -n "ID del Producto a dar entradar: "
        read ID_Producto
        Buscar_Producto $ID_Producto
        Busqueda=$?
        if [ $Busqueda == "1" ]; then
            break
        else
            echo "Producto no existente!"
            Estado=0
            Registrar_Bitacora_Archivo_Productos $Estado $ID_Usuario "Modificar cantidad"
            echo "Presione Enter para continuar..."
            read p
        fi
    done

    echo -e -n "Piezas a agregar: "
    read Nueva_Cantidad
    
    awk -v ID="$ID_Producto" -v Nueva_Cant="$Nueva_Cantidad" 'BEGIN { FS=OFS="," } $1 == ID { $4 = $4+Nueva_Cant } 1' Productos.csv > Productos_temp.csv
    mv Productos_temp.csv Productos.csv     

    echo "Piezas agregadas!!!"
    Estado=1
    Registrar_Bitacora_Archivo_Productos $Estado $ID_Usuario "Modificar cantidad"
    echo "Presione Enter para continuar..."
    read p
}

function Cambios_Producto
{
    typeset ID_Usuario=$1
    typeset Estado=0
    clear
    echo "Cambios Producto"

    while true
    do
        clear
        echo -e -n "Introduzca el ID del producto a modificar: "
        read Id
        Buscar_Producto $Id
        Busqueda=$?
        
        if [ $Busqueda == "1" ]; then
            clear
            echo "Datos a modificar"
            echo "1.- Nombre"
            echo "2.- Cantidad"
            echo "3.- Tamanio"
            echo "4.- Precio"
            echo -e -n "Introduzca la opcion a modificar: "
            read Opcion
            case $Opcion in
                1) 
                    echo -e -n "Introduzca el nuevo nombre: "
                    read Nuevo_Nombre
                    awk -v ID="$Id" -v Nuevo_Nom="$Nuevo_Nombre" 'BEGIN { FS=OFS="," } $1 == ID { $2 = Nuevo_Nom } 1' Productos.csv > Productos_temp.csv
                    mv Productos_temp.csv Productos.csv          
                    echo "Producto modificado!!!"
                    Estado=1
                    Registrar_Bitacora_Archivo_Productos $Estado $ID_Usuario "Actualizacion de nombre de producto"
                    echo "Presione Enter para continuar..."
                    read p
                    ;;
                2)
                    echo -e -n "Introduzca la nueva cantidad: "
                    read Nueva_Cantidad
                    awk -v ID="$Id" -v Nueva_Cant="$Nueva_Cantidad" 'BEGIN { FS=OFS="," } $1 == ID { $4 = Nueva_Cant } 1' Productos.csv > Productos_temp.csv
                    mv Productos_temp.csv Productos.csv     
                    Estado=1
                    Registrar_Bitacora_Archivo_Productos $Estado $ID_Usuario "Actualizacion de cantidad de producto"
                    echo "Producto modificado!!!"
                    echo "Presione Enter para continuar..."
                    read p
                    ;;
                3)
                    echo -e -n "Introduzca el nuevo tamanio: "
                    read Nuevo_Tamanio
                    awk -v ID="$Id" -v Nuevo_Tam="$Nuevo_Tamanio" 'BEGIN { FS=OFS="," } $1 == ID { $3 = Nuevo_Tam } 1' Productos.csv > Productos_temp.csv
                    mv Productos_temp.csv Productos.csv
                    Estado=1
                    Registrar_Bitacora_Archivo_Productos $Estado $ID_Usuario "Actualizacion de tamaño de producto"
                    echo "Producto modificado!!!"
                    echo "Presione Enter para continuar..."
                    read p
                    ;;
                4)
                    echo -e -n "Introduzca el nuevo precio: "
                    read Nuevo_Precio
                    awk -v ID="$Id" -v Nuevo_Pre="$Nuevo_Precio" 'BEGIN { FS=OFS="," } $1 == ID { $5 = Nuevo_Pre } 1' Productos.csv > Productos_temp.csv
                    mv Productos_temp.csv Productos.csv

                    Estado=1
                    Registrar_Bitacora_Archivo_Productos $Estado $ID_Usuario "Actualizacion de precio de producto"
                    echo "Producto modificado!!!"
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
            echo "Producto no existente!!"
            echo "Presione Enter para continuar..."
            Estado=0
            Registrar_Bitacora_Archivo_Productos $Estado $ID_Usuario "Actualizacion de producto"
            read p
        fi
    done
}

function Alta_Producto
{
    typeset ID_Usuario=$1
    typeset Estado=0

    Registrar_Bitacora_Archivo_Productos $Estado $ID_Usuario "Alta de producto"
    clear
    echo "Alta Producto"
    while true
    do
        
        if [ $(wc -l < Productos.csv) -eq 1 ]; then
            typeset nuevo_id=1
        else
            # Leer el último ID existente
            typeset ultimo_id=$(tail -n 1 Productos.csv | cut -d, -f1)

            # Calcular el nuevo ID sumando 1 al último ID
            typeset nuevo_id=$((ultimo_id + 1))
        fi
            
            echo "El nuevo ID asignado es: $nuevo_id"
            echo -e -n "Introduzca el nombre: "
            read Nombre
            echo -e -n "Introduzca el tamanio: "
            read Tamanio
            echo -e -n "Introduzca la cantidad: "
            read Cantidad
            echo -e -n "Introduzca el precio: "
            read Precio
            echo "$nuevo_id,$Nombre,$Tamanio,$Cantidad,$Precio" >> Productos.csv
            echo "Producto agregado!!!"
            Estado=1
            Registrar_Bitacora_Archivo_Productos $Estado $ID_Usuario "Alta de producto"
            echo "Presione Enter para continuar..."
            read p
            break       

       
    done
}

function Baja_Producto
{
    typeset ID_Usuario=$1
    typeset Estado=0
    
    clear
    echo "Baja Producto"
    while true
    do
        clear
        echo -e -n "Introduzca el ID del producto a eliminar: "
        read Id
        Buscar_Producto $Id
        Busqueda=$?
        if [ $Busqueda == "1" ]; then
            awk -v ID="$Id" 'BEGIN { FS=OFS="," } $1 != ID { print }' Productos.csv > Productos_temp.csv 
            mv Productos_temp.csv Productos.csv
            echo "Producto Eliminado!!!"
            Estado=1
            Registrar_Bitacora_Archivo_Productos $Estado $ID_Usuario "Baja de Producto"
            echo "Presione Enter para continuar..."
            read p
            break
        else
            Estado=0
            Registrar_Bitacora_Archivo_Productos $Estado $ID_Usuario "Baja de Producto"
            echo "Producto no existente!!"
            echo "Presione Enter para continuar..."
            read p
        fi
    done
}

function Desplegado_Productos
{
    clear
    print "======================================================="
    print "                     Productos                         "  
    print "======================================================="
    awk -F, 'BEGIN {OFS="\t"} NR==1 {printf "%-5s %-20s %-10s %-10s %-20s\n", $1, $2, $3, $4, $5} NR>1 {printf "%-5s %-20s %-10s %-10s %-20s\n", $1, $2, $3, $4, $5}' Productos.csv
    echo
    echo
    echo "Presione Enter para continuar..."
    read p
}

Crear_CSV_Productos
