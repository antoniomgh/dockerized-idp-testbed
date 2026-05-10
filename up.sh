#!/bin/bash
#!/bin/bash
../clear-images.sh

docker compose -f docker-compose.yml down
docker compose -f docker-compose.yml rm
docker compose -f docker-compose.yml build gh-saml-sp-shibboleth gh-saml-sp-simplesamlphp
docker compose -f docker-compose.yml up --build --force-recreate