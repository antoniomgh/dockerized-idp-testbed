#!/usr/bin/env bash

BIN_FOLDER="$(dirname "$0")"

${BIN_FOLDER}/dxstop.sh "$1"

COMPOSE_FILENAME="docker-compose.yml"
if [ ! -z "$1" ]; then
  COMPOSE_FILENAME="docker-compose.r$1.yml"
fi

docker compose -f "$COMPOSE_FILENAME" build gh-saml-sp-shibboleth gh-saml-sp-simplesamlphp
docker compose -f "$COMPOSE_FILENAME" up --build --force-recreate