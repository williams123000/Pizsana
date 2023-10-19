#!/bin/ksh
# Williams Chan Pescador 2193076730
# Equipo X-Men
# "X-Men: Transformando Código en Realidad, ¡Programamos el Mañana!
    ##########################################
    #      Script Del Modulo Ventas          #
    #           CRUD DE VENTAS               #
##################################################
#                 Funciones                      #
# 1. Crea el csv de ventas con su:               #
# ID_Venta,ID_Producto,Cantidad,SubTotal,        #
# Total,Fecha_Hora,ID_Usuario todo va redirigido #
# al csv respectivo.                             #
# 2. Registrar en bitacora cada operacion que    #
# se realice con el id de quien la realiza, que  # 
# hace en dicha operacion y su estado.           #
# 3. Desplegado de ventas correspondiente al     #
# csv que se genero.                             #
# 4. Cancelar venta el cual es con respecto a su #
# id, con el cual si se ejecuta, en productos se #
# le suma el producto que se iva a llevar.       #  
# 5. Crear Venta el cual se le genera un id en   #
# automatico tomando su id anterior, al momento  #
# de realizar se le pregunta la cantidad de pi-  #
# zzas a llevar y esas mismas se le resta ala    #
# cantidad que teneemos en producto.             #
# 6.Enviar Bitacora Ventas el cual es el encar-  #
# do de mandar un correo con las ventas que se   #
# hayan generado dentro de nuestro Ventas.csv    #
##################################################



function Crear_CVS_Ventas
{
    clear
    if [ -e "Ventas.csv" ]; then
        echo 
    else
        touch Ventas.csv      
        echo "ID_Venta,ID_Producto,Cantidad,SubTotal,Total,Fecha_Hora,ID_Usuario" > Ventas.csv
    fi
}

function Registrar_Bitacora_Archivo_Ventas
{
    Estado=$1
    ID_Usuario=$2
    Operacion=$3
    echo "Usuario: $ID_Usuario"
    echo "Estado: $Estado"

    cd ../Bitacora
    . ./Bitacora.ksh
    Registrar_Bitacora $ID_Usuario "Ventas" "$Operacion" $Estado
    cd ../Ventas
}


function Desplegar_Ventas
{   
    clear
    print "================================================================================================"
    print "                                      Ventas realizadas                                         "  
    print "================================================================================================"
    tail -n 10 Ventas.csv | awk -F, 'BEGIN {OFS="\t"} NR==1 {printf "%-10s %-15s %-10s %-10s %-10s %-25s %-15s\n", $1, $2, $3, $4, $5, $6, $7} NR>1 {printf "%-10s %-15s %-10s %-10s %-10s %-25s %-15s\n", $1, $2, $3, $4, $5, $6, $7}' Ventas.csv
    echo "Presione Enter para continuar..."
    read p
}

function Cancelar_Venta
{
    typeset ID_Usuario=$1
    typeset Estado=0

    Estado=0
    Registrar_Bitacora_Archivo_Ventas $Estado $ID_Usuario "Cancelar venta"

    clear
    echo "Cancelar venta"
    while true
    do
        clear
        echo -e -n "ID de la venta a cancelar: "
        read ID_Venta
        Cantidad=$(awk -v ID="$ID_Venta" 'BEGIN { FS=OFS="," } $1 == ID { print $3 }' Ventas.csv)  
        ID_Producto=$(awk -v ID="$ID_Venta" 'BEGIN { FS=OFS="," } $1 == ID { print $2 }' Ventas.csv)  
        awk -v ID="$ID_Venta" 'BEGIN { FS=OFS="," } $1 != ID { print }' Ventas.csv > Ventas_temp.csv 
        mv Ventas_temp.csv Ventas.csv
        cd ../Producto
        awk -v ID="$ID_Producto" -v Cantidad="$Cantidad" 'BEGIN { FS=OFS="," } $1 == ID { $4 = $4+Cantidad } 1' Productos.csv > Productos_temp.csv
        mv Productos_temp.csv Productos.csv
        Estado=1
        Registrar_Bitacora_Archivo_Ventas $Estado $ID_Usuario "Cancelar venta"
        cd ../Ventas
        echo "Venta Eliminada!!!"
        
        echo "Presione Enter para continuar..."
        read p
        break
    done
}

function Crear_Venta
{
    ID_Usuario=$1
    clear
    echo "Crear venta"
    while true
    do
        
        if [ $(wc -l < Ventas.csv) -eq 1 ]; then
            nuevo_id=1
        else
            # Leer el último ID existente
            ultimo_id=$(tail -n 1 Ventas.csv | cut -d, -f1)

            # Calcular el nuevo ID sumando 1 al último ID
            nuevo_id=$((ultimo_id + 1))
        fi
            
            echo "El nuevo ID_Venta asignado es: $nuevo_id"
            cd ../Producto
            . ./Productos.ksh
            Desplegado_Productos
            cd ../Ventas
            echo -e -n "Introduzca el producto (ID): "
            read id_producto
            echo -e -n "Introduzca las piezas: "
            read piezas
            
            cd ../Producto
            #precio=$(awk -F ',' '$1 ==  {print $2}' datos.csv)
            precio=$(awk -v ID="$id_producto" 'BEGIN { FS=OFS="," } $1 == ID { print $5 }' Productos.csv)   
            awk -v ID="$id_producto" -v piezas="$piezas" 'BEGIN { FS=OFS="," } $1 == ID { $4 = $4-piezas } 1' Productos.csv > Productos_temp.csv
            mv Productos_temp.csv Productos.csv
            # Exporta la variable "edad" para que esté disponible en el entorno del shell actual
            export precio
            total=$(echo "scale=2; $precio * $piezas" | bc)
            export total
            cd ../Ventas
            fecha_hora=$(date +"%Y-%m-%d %H:%M:%S")
            echo "$nuevo_id,$id_producto,$piezas,$precio,$total,$fecha_hora,$ID_Usuario" >> Ventas.csv
            echo "Venta realizada!!!"
            echo "Presione Enter para continuar..."
            read p
            break       
    done
}

function Enviar_Bitacora_Ventas
{
    # Dirección de correo electrónico del destinatario
    recipient="williams.chan@cua.uam.mx"

    # Asunto del correo
    subject="Ventas Pizsana"

    # Nombre del archivo CSV formateado
    formatted_csv="Ventas.csv"

    echo "Adjunto encontrará el archivo CSV formateado." | mailx -s "$subject" -a "$formatted_csv" "$recipient"
    echo "Reporte enviado!!!"
    echo "Presione Enter para continuar..."
    read p
}

Crear_CVS_Ventas

