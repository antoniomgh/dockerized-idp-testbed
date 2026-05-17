#!/bin/bash
../clear-images.sh
docker compose -f docker-compose.yml down -v
docker compose -f docker-compose.yml rm