#!/bin/ksh
# Williams Chan Pescador 2193076730
# Equipo X-Men
# "X-Men: Transformando Código en Realidad, ¡Programamos el Mañana!
    ##########################################
    #      Script Del Modulo Bitacora        #
    #                                        #
##################################################
#                 Funciones                      #
# 1. Crea el csv de Bitacoras con su:            #
# ID_Bitacoras,ID_Usuario,Modulo,Operacion,      #
# Estado,Fecha_Hora                              #
# 2. Registrar en bitacora cada operacion que    #
# se realice con el id de quien la realiza, que  # 
# hace en dicha operacion y su estado.           #
# 3. Visualizar bitacora el cual te muestra las  #
# operaciones que se han realizado dentro con    #
# respecto al csv generado. Al igual este manda  #
# a llamar a otra funcion de enviar bitacora por #
# email.                                         #
# 4. Enviar Bitacora Email el cual es el encar-  #
# gado de mandar toda la bitacora generada por   #
# correo.                                        #
##################################################



function Crear_CSV_Bitacora
{
    clear
    if [ -e "Bitacora.csv" ]; then
        echo
    else
        touch Bitacora.csv      
        echo "ID_Bitacoras,ID_Usuario,Modulo,Operacion,Estado,Fecha_Hora" > Bitacora.csv  
    fi
}

# Estado es igual a 0 si no es exitoso y 1 si es exitoso
function Registrar_Bitacora
{
    typeset ID_Usuario=$1
    typeset Modulo=$2
    typeset Operacion=$3
    typeset Estado=$4   

    if [ $(wc -l < Bitacora.csv) -eq 1 ]; then
        nuevo_id=1
    else
        # Leer el último ID existente
        ultimo_id=$(tail -n 1 Bitacora.csv | cut -d, -f1)
        # Calcular el nuevo ID sumando 1 al último ID
        nuevo_id=$((ultimo_id + 1))
    fi

    if [ $Estado == "1" ]; then
        Estado="Exitoso"
    else
        Estado="No exitoso"
    fi
    fecha_hora=$(date +"%Y-%m-%d %H:%M:%S")
    echo "$nuevo_id,$ID_Usuario,$Modulo,$Operacion,$Estado,$fecha_hora" >> Bitacora.csv
}

function Visualizar_Bitacora
{
    awk -F, 'BEGIN {OFS="\t"} NR==1 {printf "%-20s %-10s %-20s %-40s %-20s %-10s\n", $1, $2, $3, $4, $5, $6} NR>1 {printf "%-20s %-10s %-20s %-40s %-20s %-10s\n", $1, $2, $3, $4, $5, $6}' Bitacora.csv
    Enviar_Bitacora_Email
    echo "Presione Enter para continuar..."
    read p
}

function Enviar_Bitacora_Email
{
    # Dirección de correo electrónico del destinatario
    recipient="williams.chan@cua.uam.mx"

    # Asunto del correo
    subject="Bitacora Pizsana"

    # Nombre del archivo CSV formateado
    formatted_csv="Bitacora.csv"

    echo "Adjunto encontrará el archivo CSV formateado." | mailx -s "$subject" -a "$formatted_csv" "$recipient"
}

Crear_CSV_Bitacora