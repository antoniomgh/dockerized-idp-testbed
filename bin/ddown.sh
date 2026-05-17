#!/usr/bin/env bash

# Configuración: Define aquí la ruta base donde guardas tus proyectos/composes
# Si tus carpetas están en el mismo directorio que el script, déjalo como "."
BASE_DIR="."
BIN_FOLDER="$(dirname "$0")"

# Colores para la terminal
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

COMPOSE_FILENAME="docker-compose.yml"
if [ ! -z "$1" ]; then
  COMPOSE_FILENAME="docker-compose.r$1.yml"
fi

COMPOSE_FILE="${BASE_DIR}/${COMPOSE_FILENAME}"

# 2. Verificar si el archivo docker-compose.yml existe
if [ ! -f "$COMPOSE_FILE" ]; then
    echo -e "${RED}Error: No se encontró el archivo: ${COMPOSE_FILE}${NC}"
    exit 1
fi

echo -e "${YELLOW}======================================================${NC}"
echo -e "${YELLOW} Iniciando limpieza para: ${COMPOSE_FILE}${NC}"
echo -e "${YELLOW}======================================================${NC}"

# 3. Parar y eliminar TODO lo relacionado con este compose actual
echo -e "\n${YELLOW}[1/3] Deteniendo y eliminando contenedores, redes y volúmenes locales...${NC}"
# -v elimina los volúmenes nombrados declarados en el compose
# --remove-orphans elimina contenedores residuales que ya no estén en el archivo yaml
docker compose -f "$COMPOSE_FILE" down -v --remove-orphans

# 4. Limpieza profunda de rastro previo (Caché, imágenes huérfanas y volúmenes)
echo -e "\n${YELLOW}[2/3] Eliminando imágenes (layers) específicas del proyecto...${NC}"
# Intentamos borrar las imágenes asociadas al proyecto para forzar el re-pull o re-build
docker compose -f "$COMPOSE_FILE" rm -f -s -v

echo -e "\n${YELLOW}[3/3] Ejecutando limpieza del sistema (Prune masivo)...${NC}"
# docker system prune -a --volumes elimina de forma agresiva:
#   - Todos los contenedores detenidos
#   - Todas las redes no usadas
#   - Todas las imágenes sin contenedores asociados (fuerza la descarga de nuevas capas)
#   - Toda la caché de construcción (build cache)
# El filtro 'label' asegura que, si usas etiquetas de proyecto, se enfoque ahí, pero el prune -f es ideal para asegurar residuo cero general.
docker system prune -a --volumes -f

echo -e "\n${GREEN}🚀 ¡Limpieza ${COMPOSE_FILE} completa!${NC}"