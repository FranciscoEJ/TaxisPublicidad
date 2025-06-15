#!/bin/bash
IMG=$(find /home/admin/Documents/TaxisPublicidad/img -type f | shuf -n 1)
pcmanfm --set-wallpaper "$IMG"

#!/bin/bash

# Variables necesarias
export DISPLAY=:0
export XAUTHORITY=/home/pi/.Xauthority
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"

WALLPAPERS="/home/admin/Documents/TaxisPublicidad/img"
LOG="/home/admin/wallpaper_cron.log"
LAST_IMAGE_FILE="/home/admin/.ultima_imagen_usada"

echo "[INFO] Ejecutado: $(date)" >> "$LOG"

# Buscar imágenes válidas
IMAGES=($(find "$WALLPAPERS" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \)))
NUM_IMAGES=${#IMAGES[@]}

if [[ $NUM_IMAGES -eq 0 ]]; then
    echo "[ERROR] No se encontraron imágenes." >> "$LOG"
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
    if [[ "$img" != "$LAST_IMAGE" ]]; then
        FILTERED_IMAGES+=("$img")
    fi
done

if [[ ${#FILTERED_IMAGES[@]} -eq 0 ]]; then
    SELECTED_IMG="$LAST_IMAGE"
else
    SELECTED_IMG="${FILTERED_IMAGES[$((RANDOM % ${#FILTERED_IMAGES[@]}))]}"
fi

echo "$SELECTED_IMG" > "$LAST_IMAGE_FILE"
echo "[INFO] Imagen seleccionada: $SELECTED_IMG" >> "$LOG"

# Cambiar fondo usando PCManFM dentro del entorno gráfico activo
DISPLAY=:0 dbus-launch --exit-with-session pcmanfm --set-wallpaper="$SELECTED_IMG" --wallpaper-mode=stretch >> "$LOG" 2>&1


# Filtrar para evitar repetir la misma imagen si hay más de 1
FILTERED_IMAGES=()
for img in "${IMAGES[@]}"; do
    if [[ "$img" != "$LAST_IMAGE" ]]; then
        FILTERED_IMAGES+=("$img")
    fi
done

# Si solo hay una imagen posible (porque las otras son iguales), la usamos
if [[ ${#FILTERED_IMAGES[@]} -eq 0 ]]; then
    SELECTED_IMG="$LAST_IMAGE"
else
    RANDOM_INDEX=$((RANDOM % ${#FILTERED_IMAGES[@]}))
    SELECTED_IMG="${FILTERED_IMAGES[$RANDOM_INDEX]}"
fi

# Guardar la nueva imagen como última usada
echo "$SELECTED_IMG" > "$LAST_IMAGE_FILE"

echo "[INFO] Imagen seleccionada: $SELECTED_IMG" >> "$LOG"

# Cambiar el fondo
dbus-launch pcmanfm --set-wallpaper="$SELECTED_IMG" --wallpaper-mode=stretch >> "$LOG" 2>&1
