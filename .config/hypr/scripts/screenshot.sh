#!/usr/bin/env bash

DIR="$HOME/Pictures/Screenshots"
mkdir -p "$DIR"
FILE="$DIR/screenshot_$(date +'%Y-%m-%d_%H-%M-%S').png"

# Capturar área seleccionada
grim -g "$(slurp)" "$FILE"

if [ -f "$FILE" ]; then
    wl-copy < "$FILE"
    notify-send -a "Screenshot" -i "$FILE" "Captura guardada" "Copiada al portapapeles y guardada en $FILE"
fi
