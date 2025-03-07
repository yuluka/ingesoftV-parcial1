#!/bin/bash

# Verificar si Docker está instalado
if ! command -v docker &> /dev/null; then
    echo "Hey, bro! Docker no está instalado. Instálalo y vuelve a intentar -_-"
    exit 1
fi

echo "Todo nais. Docker está instalado."

IMAGE_NAME="devops-evaluacion"
CONTAINER_NAME="devops-container"

# Cargar las variables desde .env
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
else
    echo "¡CÓRCHOLIS! No se encontró el archivo .env."
    exit 1
fi

# Verificar que la variable PORT esté definida
if [ -z "$PORT" ]; then
    echo "¡HEY HEY HEY! La variable PORT no está definida en .env."
    exit 1
fi

echo "Usando el puerto: $PORT"

# Construir la imagen
echo "Por acá andamos, construyendo la imagen Docker..."
docker build -t $IMAGE_NAME .

# Verificar que la imagen se haya creado correctamente
if [[ $? -ne 0 ]]; then
    echo "Hey, pana! Error al construir la imagen Docker."
    exit 1
fi

echo "Todo bien. Imagen Docker construida exitosamente."

# Ejecutar el contenedor con las variables de entorno
echo "Iniciando el contenedor..."
docker run -d --name $CONTAINER_NAME --env-file .env -p $PORT:$PORT $IMAGE_NAME

# Verificar que el contenedor esté corriendo
if [[ $(docker ps -q -f name=$CONTAINER_NAME) ]]; then
    echo "Contenedor corriendo :-)"
else
    echo "Error al iniciar el contenedor :("
    exit 1
fi

# Probar la respuesta
echo "Verificando que la aplicación responde..."
sleep 3
curl -s http://localhost:$PORT/health | grep "OK"

if [[ $? -eq 0 ]]; then
    echo "YEIIIII! La aplicación está funcionando como debe."
else
    echo "¡CÓRCHOLIS! La aplicación no está respondiendo correctamente."
    exit 1
fi

echo "Todo nais. La aplicación está en ejecución en http://localhost:$PORT"