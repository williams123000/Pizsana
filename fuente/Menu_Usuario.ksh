#!/bin/ksh
# Williams Chan Pescador 2193076730
# Equipo X-Men
# "X-Men: Transformando Código en Realidad, ¡Programamos el Mañana!
##############################################
#      Script Del Modulo Menu Usuario        #
# El cual es el encargado de tener las       #
# funciones adecuadas del usuario            #
# Ya sea en Usuarios, Producto y Ventas      #
#  Cada opcion que se desee hacer            #
# hacer dentro, se llama al correspondiente  #
# ksh ya generado con su id de quien esta    #
# haciendo dicha operacion y tambien se      #
# se registra en bitacora.                   #
##############################################

ID_Usuario=$1
# Define las opciones del menú
options=("Cuenta" "Producto" "Ventas" "Cerrar Sesión" "Salir")
options_MenuCuenta=("Cambiar contraseña" "Volver")
options_MenuProductos=("Dar entrada a productos" "Visualizar productos" "Volver")
options_MenuVentas=("Crear venta" "Visualizar ventas" "Volver")
selected=0
selected_MenuCuenta=0
selected_MenuProductos=0
selected_MenuVentas=0
# Función para mostrar el menú
function Registrar_Bitacora_Archivo_MenuUsuario
{
    Estado=$1
    ID_Usuario=$2
    echo "Usuario: $ID_Usuario"
    echo "Estado: $Estado"

    cd ./Bitacora
    . ./Bitacora.ksh
    Registrar_Bitacora $ID_Usuario "Menu Usuario" "Cerrar Sesion" $Estado
    cd ..
}

function show_MenuPrincipal
{
    clear
    echo "#########################################################"
    echo "##                      Usuario                        ##"
    echo "#########################################################"
    echo "Usuario: $ID_Usuario"
    echo
    for ((i = 0; i < ${#options[*]}; i++)); do
        if [ $i -eq $selected ]; then
            echo "> ${options[i]}"
        else
            echo "  ${options[i]}"
        fi
    done
}

function show_Cuenta
{
    clear
    echo "#########################################################"
    echo "##                   Menu Cuenta                       ##"
    echo "#########################################################"
    for ((i = 0; i < ${#options_MenuCuenta[*]}; i++)); do
        if [ $i -eq $selected_MenuCuenta ]; then
            echo "> ${options_MenuCuenta[i]}"
        else
            echo "  ${options_MenuCuenta[i]}"
        fi
    done
}

function show_MenuProductos
{
    clear
    echo "#########################################################"
    echo "##                  Menu Productos                     ##"
    echo "#########################################################"
    for ((i = 0; i < ${#options_MenuProductos[*]}; i++)); do
        if [ $i -eq $selected_MenuProductos ]; then
            echo "> ${options_MenuProductos[i]}"
        else
            echo "  ${options_MenuProductos[i]}"
        fi
    done
}

function show_MenuVentas
{
    clear
    echo "#########################################################"
    echo "##                   Menu Ventas                       ##"
    echo "#########################################################"
    for ((i = 0; i < ${#options_MenuVentas[*]}; i++)); do
        if [ $i -eq $selected_MenuVentas ]; then
            echo "> ${options_MenuVentas[i]}"
        else
            echo "  ${options_MenuVentas[i]}"
        fi
    done
}

# Función para manejar las teclas de flecha
function keypress_menuPrincipal
{
    typeset key
    read -s -n 1 key

    echo $key
    case "$key" in
        A) # Flecha arriba
            selected=$((selected - 1))
            [ $selected -lt 0 ] && selected=$((${#options[*]} - 1))
            ;;
        B) # Flecha abajo
            selected=$((selected + 1))
            [ $selected -ge ${#options[*]} ] && selected=0
            ;;
        C) # Enter
            handle_selection_MenuPrincipal
            ;;
        *) # Otro
            ;;
    esac
}

function keypress_menuCuenta
{
    typeset key
    read -s -n 1 key

    echo $key
    case "$key" in
        A) # Flecha arriba
            selected_MenuCuenta=$((selected_MenuCuenta - 1))
            [ $selected_MenuCuenta -lt 0 ] && selected_MenuCuenta=$((${#options_MenuCuenta[*]} - 1))
            ;;
        B) # Flecha abajo
            selected_MenuCuenta=$((selected_MenuCuenta + 1))
            [ $selected_MenuCuenta -ge ${#options_MenuCuenta[*]} ] && selected_MenuCuenta=0
            ;;
        C) # Enter
            handle_selection_MenuCuenta
            ;;
        *) # Otro
            ;;
    esac
}

function keypress_menuProductos
{
    typeset key
    read -s -n 1 key

    echo $key
    case "$key" in
        A) # Flecha arriba
            selected_MenuProductos=$((selected_MenuProductos - 1))
            [ $selected_MenuProductos -lt 0 ] && selected_MenuProductos=$((${#options_MenuProductos[*]} - 1))
            ;;
        B) # Flecha abajo
            selected_MenuProductos=$((selected_MenuProductos + 1))
            [ $selected_MenuProductos -ge ${#options_MenuProductos[*]} ] && selected_MenuProductos=0
            ;;
        C) # Enter
            handle_selection_MenuProducto
            ;;
        *) # Otro
            ;;
    esac
}

function keypress_menuVentas
{
    typeset key
    read -s -n 1 key

    echo $key
    case "$key" in
        A) # Flecha arriba
            selected_MenuVentas=$((selected_MenuVentas - 1))
            [ $selected_MenuVentas -lt 0 ] && selected_MenuVentas=$((${#options_MenuVentas[*]} - 1))
            ;;
        B) # Flecha abajo
            selected_MenuVentas=$((selected_MenuVentas + 1))
            [ $selected_MenuVentas -ge ${#options_MenuVentas[*]} ] && selected_MenuVentas=0
            ;;
        C) # Enter
            handle_selection_MenuVentas
            ;;
        *) # Otro
            ;;
    esac
}

# Función para manejar la selección
function handle_selection_MenuPrincipal
{
    clear
    case $selected in
        0) # Opción 1
            echo "Seleccionaste Opción 1"
            while true; do
                show_Cuenta
                keypress_menuCuenta
            done
            ;;
        1) # Opción 2
            echo "Seleccionaste Opción 2"
            while true; do
                show_MenuProductos
                keypress_menuProductos
            done
            ;;
        2) # Opción 3
            echo "Seleccionaste Opción 3"
            while true; do
                show_MenuVentas
                keypress_menuVentas
            done
            ;;
        3) # Cerrar Sesion
            Estado=1
            Registrar_Bitacora_Archivo_MenuUsuario $Estado $ID_Usuario "Cerrar sesion/Usuario"
            . ./Menu_Principal.ksh           
            ;;
        4) # Salir
            exit 0
            ;;
    esac
    echo "Presiona una tecla para continuar..."
    read p
}

function handle_selection_MenuCuenta
{
    clear
    case $selected_MenuCuenta in
        0) # Opción 1
            #echo "Seleccionaste Opción 1"
            cd ./Login
            . ./Login.ksh
            Cambiar_Password $ID_Usuario
            cd ..
            ;;
        1) # Opción 2
            main
            ;;
    esac
}

function handle_selection_MenuProducto
{
    clear
    case $selected_MenuProductos in
        0) # Opción 1
            echo "Seleccionaste Opción 1"
            
            cd ./Producto
            . ./Productos.ksh
            Modificar_Cantidad $ID_Usuario
            cd ..
            ;;
        1) # Opción 2
            cd ./Producto
            . ./Productos.ksh
            Desplegado_Productos
            cd ..
            ;;
        2) # Opción 3
            main
            ;;
    esac
}

function handle_selection_MenuVentas
{
    clear
    case $selected_MenuVentas in
        0) # Opción 1
            #echo "Seleccionaste Opción 1"
            
            cd ./Ventas
            . ./Ventas.ksh
            Crear_Venta $ID_Usuario
            cd ..
            #Modificar_Cantidad
            ;;
        1) # Opción 2
            cd ./Ventas
            . ./Ventas.ksh
            Desplegar_Ventas
            cd ..
            ;;
        2) # Opción 3
            main
            ;;
    esac
}

function main
{
    while true; do
        show_MenuPrincipal
        keypress_menuPrincipal
    done
}
# Bucle principal

main
