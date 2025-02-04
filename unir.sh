#!/bin/bash

# Variables de idioma
lang="es"  # Por defecto es español

# Función para mostrar la descripción y ejemplos en español
mostrar_descripcion_es() {
    echo "========================================"
    echo "    SCRIPT DE UNIÓN DE VIDEOS - unir.sh"
    echo "========================================"
    echo ""
    echo "Este script permite unir varios archivos de video del mismo formato y códec en un solo archivo de salida."
    echo ""
    echo "Ejemplos de uso:"
    echo "  Unir 2 archivos de video:"
    echo "    ./unir.sh video1.mp4,video2.mp4 video_unido.mp4"
    echo ""
    echo "  Unir 3 archivos de video:"
    echo "    ./unir.sh video1.mp4,video2.mp4,video3.mp4 video_unido.mp4"
    echo ""
    echo "========================================"
    echo ""
}

# Función para mostrar la descripción y ejemplos en inglés
mostrar_descripcion_en() {
    echo "========================================"
    echo "    VIDEO MERGE SCRIPT - v6.sh"
    echo "========================================"
    echo ""
    echo "This script allows merging multiple video files of the same format and codec into one output file."
    echo ""
    echo "Examples of use:"
    echo "  Merge 2 video files:"
    echo "    ./unir.sh video1.mp4,video2.mp4 merged_video.mp4"
    echo ""
    echo "  Merge 3 video files:"
    echo "    ./unir.sh video1.mp4,video2.mp4,video3.mp4 merged_video.mp4"
    echo ""
    echo "========================================"
    echo ""
}

# Función para mostrar un mensaje de uso correcto
mostrar_uso() {
    if [ "$lang" = "en" ]; then
        echo "Usage: $0 file_input1.ext,file_input2.ext,... output_file.ext"
    else
        echo "Uso: $0 archivo_input1.extension,archivo_input2.extension,... archivo_output.extension"
    fi
    exit 1
}

# Detectar el idioma a partir del argumento
if [[ "$1" == "-en" ]]; then
    lang="en"
    shift
elif [[ "$1" == "-es" ]]; then
    lang="es"
    shift
fi

# Mostrar la descripción según el idioma
if [ "$lang" = "en" ]; then
    mostrar_descripcion_en
else
    mostrar_descripcion_es
fi

# Verificar si se han proporcionado los argumentos correctos
if [ $# -lt 2 ]; then
    mostrar_uso
fi

# Separar los archivos de entrada y el archivo de salida
archivos_input="${1%,}"  # Archivos de entrada
archivo_output="${2}"    # Archivo de salida

# Verificar que los archivos de entrada existan
IFS=',' read -ra archivos <<< "$archivos_input"  # Archivos de entrada separados por coma
for archivo in "${archivos[@]}"; do
    archivo=$(echo "$archivo" | sed 's/^ *//;s/ *$//')  # Limpiar espacios alrededor del archivo
    if [ ! -f "$archivo" ]; then
        if [ "$lang" = "en" ]; then
            echo "Error: File $archivo does not exist."
        else
            echo "Error: El archivo $archivo no existe."
        fi
        exit 1
    fi
done

# Verificar si FFmpeg y FFprobe están instalados
if ! command -v ffmpeg &> /dev/null || ! command -v ffprobe &> /dev/null; then
    if [ "$lang" = "en" ]; then
        echo "Error: FFmpeg or FFprobe is not installed. Please install FFmpeg and FFprobe to proceed."
    else
        echo "Error: FFmpeg o FFprobe no están instalados. Por favor, instala FFmpeg y FFprobe para continuar."
    fi
    exit 1
fi

# Usar GPU NVIDIA para la conversión si está disponible
if command -v nvidia-smi &> /dev/null; then
    if ffmpeg -encoders 2>/dev/null | grep -q nvenc; then
        if [ "$lang" = "en" ]; then
            echo "Using NVENC for GPU-accelerated conversion."
        else
            echo "Usando NVENC para la conversión con GPU."
        fi
        encoder_option="-c:v h264_nvenc"
    else
        if [ "$lang" = "en" ]; then
            echo "Error: NVENC support not found in FFmpeg."
        else
            echo "Error: No se encontró soporte para NVENC en FFmpeg."
        fi
        exit 1
    fi
else
    if [ "$lang" = "en" ]; then
        echo "No NVIDIA drivers detected. Using CPU for conversion."
    else
        echo "No se detectaron drivers de NVIDIA. Usando CPU para la conversión."
    fi
    encoder_option="-c:v copy"
fi

# Preguntar si se desea comenzar la unificación
while true; do
    if [ "$lang" = "en" ]; then
        read -p "Do you want to start merging the video files? (y/n): " iniciar_union
    else
        read -p "¿Deseas comenzar a unir los archivos de video? (s/n): " iniciar_union
    fi
    case "$iniciar_union" in
        [YySs]) break;;
        [Nn]) if [ "$lang" = "en" ]; then
                  echo "Operation canceled."
              else
                  echo "Operación cancelada."
              fi
              exit 0;;
        *) if [ "$lang" = "en" ]; then
                echo "Invalid input. Please enter 'y' for yes or 'n' for no."
            else
                echo "Entrada no válida. Por favor, introduce 's' para sí o 'n' para no."
            fi;;
    esac
done

# Crear el archivo de lista en el directorio actual
archivo_lista="lista_archivos.txt"
> "$archivo_lista"  # Crear o limpiar el archivo de lista

# Escribir los archivos en el archivo temporal
for archivo in "${archivos[@]}"; do
    echo "file '$archivo'" >> "$archivo_lista"
done

# Ejecutar FFmpeg para unir los archivos de video
log_file="ffmpeg_log_0.txt"
ffmpeg -f concat -safe 0 -i "$archivo_lista" $encoder_option -c copy "$archivo_output" > "$log_file" 2>&1

# Verificar si la operación fue exitosa
if [ $? -eq 0 ] && [ -s "$archivo_output" ]; then
    if [ "$lang" = "en" ]; then
        echo "Video files successfully merged into $archivo_output"
    else
        echo "Archivos de video unidos exitosamente en $archivo_output"
    fi
else
    if [ "$lang" = "en" ]; then
        echo "Error merging the video files. Check the log in $log_file."
    else
        echo "Error al unir los archivos de video. Revisa el log en $log_file."
    fi
fi

# Limpiar el archivo de lista
rm "$archivo_lista"

if [ "$lang" = "en" ]; then
    echo "Tasks completed!"
else
    echo "¡Tareas finalizadas!"
fi

exit 0
