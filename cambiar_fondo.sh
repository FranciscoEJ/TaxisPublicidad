#!/bin/bash

# Configura entorno gráfico
export DISPLAY=:0
export XAUTHORITY=/home/pi/.Xauthority
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"

WALLPAPERS="/home/admin/Documents/TaxisPublicidad/img"
LOG="/home/admin/wallpaper_cron.log"
LAST_IMAGE_FILE="/home/admin/.ultima_imagen_usada"

echo "[INFO] Ejecutado: $(date)" >> "$LOG"

# Lista de imágenes
IMAGES=($(find "$WALLPAPERS" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \)))
NUM_IMAGES=${#IMAGES[@]}

if [[ $NUM_IMAGES -eq 0 ]]; then
    echo "[ERROR] No se encontraron imágenes en $WALLPAPERS" >> "$LOG"
    exit 1
fi

# Evitar imagen repetida
if [[ -f "$LAST_IMAGE_FILE" ]]; then
    LAST_IMAGE=$(cat "$LAST_IMAGE_FILE")
else
    LAST_IMAGE=""
fi

FILTERED_IMAGES=()
for img in "${IMAGES[@]}"; do
    [[ "$img" != "$LAST_IMAGE" ]] && FILTERED_IMAGES+=("$img")
done

if [[ ${#FILTERED_IMAGES[@]} -eq 0 ]]; then
    SELECTED_IMG="$LAST_IMAGE"
else
    RANDOM_INDEX=$((RANDOM % ${#FILTERED_IMAGES[@]}))
    SELECTED_IMG="${FILTERED_IMAGES[$RANDOM_INDEX]}"
fi

echo "$SELECTED_IMG" > "$LAST_IMAGE_FILE"
echo "[INFO] Imagen seleccionada: $SELECTED_IMG" >> "$LOG"

# Cambia el fondo
pcmanfm --set-wallpaper="$SELECTED_IMG" --wallpaper-mode=stretch >> "$LOG" 2>&1

