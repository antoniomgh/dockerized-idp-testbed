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

# =====================================================================
# 🔄 LLAMADA AL SCRIPT DE LIMPIEZA
# =====================================================================
echo -e "${YELLOW}🔄 Ejecutando limpieza previa con ddown.sh...${NC}"
${BIN_FOLDER}/ddown.sh "$1"

COMPOSE_FILENAME="docker-compose.yml"
if [ ! -z "$1" ]; then
  COMPOSE_FILENAME="docker-compose.r$1.yml"
fi

COMPOSE_FILE="${BASE_DIR}/${COMPOSE_FILENAME}"

echo -e "${GREEN}[🔧] Compilando absolutamente todo el árbol de dependencias...${NC}\n"
docker compose -f "$COMPOSE_FILE" build gh-saml-sp-shibboleth gh-saml-sp-simplesamlphp

# 5. Levantar el entorno descargando capas frescas y forzando la construcción
echo -e "\n${GREEN}Levantando el entorno desde cero (Pull & Build)...${NC}"
# --pull intenta descargar siempre la última versión de las imágenes base de los Node/Debian/Alpine, etc.
# --build fuerza la reconstrucción de los Dockerfiles locales sin usar caché antigua.
docker compose -f "$COMPOSE_FILE" up -d --pull always --build

echo -e "\n${GREEN}🚀 ¡Entorno ${COMPOSE_FILE} desplegado con éxito desde absoluto cero!${NC}"