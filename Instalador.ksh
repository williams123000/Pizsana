#!/bin/ksh

# Función para imprimir la barra de progreso
print_progress() {
  typeset width=100
  typeset progress=$1
  typeset percentage=$(($progress * 2))

  printf "["
  for ((i = 0; i < $width; i++)); do
    if [ $i -lt $percentage ]; then
      printf "="
    else
      printf " "
    fi
  done
  printf "] %d%%\r" $percentage
}

# Simula una instalación de ejemplo
total_steps=50
for ((step = 1; step <= total_steps; step++)); do
  sleep 0.05  # Ajusta el tiempo de espera para que se ajuste al progreso
  print_progress $step
done

# Definir las rutas de origen y destino
origen="./fuente"
destino="./bin"

# Copiar todos los archivos de origen a destino
cp -r "$origen"/* "$destino"

# Asignar el permiso de ejecución a todos los archivos en la carpeta de destino
find "$destino" -type f -exec chmod +x {} \;

archivo="./Pizsana.ksh"
chmod +x "$archivo"
# Línea en blanco para limpiar la salida
printf "\n"

# Aquí puedes continuar con el script de instalación
echo "¡Instalación completada!"
