# README - Script de Unión de Videos `unir.sh`

## Descripción

El script `unir.sh` permite unir múltiples archivos de video del mismo formato y códec en un solo archivo de salida. Funciona con `FFmpeg` y detecta automáticamente si hay una GPU NVIDIA disponible para utilizar la aceleración `NVENC`.

## Características

- Soporta múltiples archivos de video en la misma ejecución.
- Puede ejecutarse en español o inglés.
- Detecta automáticamente la presencia de `FFmpeg` y `FFprobe`.
- Verifica si `NVENC` está disponible para aceleración por GPU o utiliza CPU en su defecto.
- Crea automáticamente un archivo de lista de videos y ejecuta la unión con `FFmpeg`.
- Permite al usuario confirmar antes de iniciar la unión de los archivos.
- Guarda un log con el resultado de la conversión para diagnóstico.

## Requisitos

Antes de ejecutar el script, asegúrate de tener instalados los siguientes paquetes:

```bash
sudo apt install ffmpeg
```

Si deseas utilizar aceleración por GPU, asegúrate de que `NVIDIA` y `NVENC` estén instalados correctamente:

```bash
nvidia-smi
ffmpeg -encoders | grep nvenc
```

## Uso

Ejemplo de uso para unir dos archivos de video:

```bash
./unir.sh video1.mp4,video2.mp4 video_unido.mp4
```

Ejemplo de uso para unir tres archivos de video:

```bash
./unir.sh video1.mp4,video2.mp4,video3.mp4 video_unido.mp4
```

Para ejecutar el script en inglés:

```bash
./unir.sh -en video1.mp4,video2.mp4 video_unido.mp4
```

## Funcionalidad

### Detección de Idioma
El script detecta si el primer argumento es `-en` (inglés) o `-es` (español, por defecto) y ajusta los mensajes de salida en el idioma seleccionado.

### Verificación de Archivos de Entrada
El script verifica que todos los archivos de entrada existan antes de iniciar la unión. Si falta algún archivo, se muestra un error y se detiene la ejecución.

### Detección de `FFmpeg` y `FFprobe`
Antes de procesar los videos, el script verifica que `FFmpeg` y `FFprobe` estén instalados. Si no se encuentran, se muestra un mensaje de error y se detiene la ejecución.

### Uso de `NVENC` para GPU
Si una tarjeta gráfica NVIDIA es detectada y `FFmpeg` tiene soporte para `NVENC`, el script usará aceleración por hardware para la conversión. En caso contrario, usará la CPU para la tarea.

### Confirmación del Usuario
El usuario debe confirmar manualmente antes de iniciar la unión de archivos, evitando conversiones accidentales.

### Proceso de Conversión
1. Se genera un archivo temporal `lista_archivos.txt` con la lista de videos a unir.
2. Se ejecuta `FFmpeg` utilizando el modo `concat` para unir los videos.
3. Se guarda un log del proceso en `ffmpeg_log_0.txt`.
4. Se elimina el archivo temporal después de la conversión.

### Verificación del Archivo de Salida
Si la conversión fue exitosa y el archivo de salida se creó correctamente, se muestra un mensaje de confirmación. En caso contrario, se muestra un error indicando que la unión falló.

## Posibles Errores y Soluciones

| Error | Solución |
|--------|---------|
| `FFmpeg or FFprobe is not installed` | Instala `FFmpeg` con `sudo apt install ffmpeg`. |
| `File <nombre> does not exist` | Verifica que el archivo exista en el directorio actual. |
| `NVENC support not found in FFmpeg` | Verifica que tu GPU NVIDIA sea compatible y que `NVENC` esté instalado correctamente. |
| `Error merging the video files` | Revisa el log en `ffmpeg_log_0.txt` para obtener más detalles. |

## Licencia
Este script es de código abierto y puede ser utilizado y modificado libremente.

## Autor
Este script fue desarrollado por MGM 2025 y para facilitar la unión de videos de manera eficiente utilizando `FFmpeg`. Para dudas o mejoras, contribuye en el repositorio de GitHub.

