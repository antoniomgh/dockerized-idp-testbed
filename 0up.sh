#!/bin/bash
./0down.sh
docker compose -f docker-compose.yml build gh-saml-sp-shibboleth gh-saml-sp-simplesamlphp
docker compose -f docker-compose.yml up --build --force-recreate