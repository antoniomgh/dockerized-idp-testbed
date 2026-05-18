#!/usr/bin/env bash

BIN_FOLDER="$(dirname "$0")"

COMPOSE_FILENAME="docker-compose.yml"
if [ ! -z "$1" ]; then
  COMPOSE_FILENAME="docker-compose.r$1.yml"
fi

${BIN_FOLDER}/clear-images.sh
docker compose -f "$COMPOSE_FILENAME" down -v
docker compose -f "$COMPOSE_FILENAME" rm