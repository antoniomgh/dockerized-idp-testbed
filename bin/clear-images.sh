#!/usr/bin/env bash

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color
DONE="[${GREEN}DONE${NC}]"
PROGRESS="[${YELLOW}....${NC}]"

echo -ne "${PROGRESS} Stop all running containers\r"
docker stop $(docker ps -q) 2>/dev/null
echo -ne "${DONE} Stop all running containers\r"
echo -ne '\n'

echo -ne "${PROGRESS} Remove old containers\r"
docker rm $(docker ps -a -q) 2>/dev/null
echo -ne "${DONE} Remove old containers\r"
echo -ne '\n'

echo -ne "${PROGRESS} Remove dangling images\r"
docker rmi $(docker images --filter dangling=true -q) 2>/dev/null
echo -ne "${DONE} Remove dangling images\r"
echo -ne '\n'

echo -ne "${PROGRESS} Remove all images\r"
docker rmi $(docker images -q) 2>/dev/null
echo -ne "${DONE} Remove images\r"
echo -ne '\n'

echo -ne "${PROGRESS} Cleaning volumes\r"
docker volume rm $(docker volume ls -q) 2>/dev/null
echo -ne "${DONE} Cleaning volumes\r"
echo -ne "\n"
