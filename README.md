
https://github.com/osixia/container-openldap/blob/main/image/service/slapd/assets/config/bootstrap/ldif/01-config-password.ldif

# Docker commands

Down:
docker compose -f docker-compose.r1.yml down -v

Up:
docker compose --progress plain -f docker-compose.r1.yml up --detach --build --force-recreate

Logs:
docker logs -f ldap

# Web Admin

http://localhost:8081/

cn=admin,dc=idptestbed
password

# ladpsearch

## Inside the container

docker exec -it ldap /bin/bash

ok: Query using admin all objects
% ldapsearch -x -b dc=idptestbed -D "cn=admin,dc=idptestbed" -w password -s sub "objectclass=*"

ok: Query using admin a specific user
% ldapsearch -x -b dc=idptestbed -D "cn=admin,dc=idptestbed" -w password -s sub "(uid=student1)"

ok: Query using admin a organizational unit
% ldapsearch -x -b dc=idptestbed -D "cn=admin,dc=idptestbed" -w password -s sub "(ou=people)"

ok: Query using admin a specific user without attributes
% ldapsearch -x -b "ou=People,dc=idptestbed" -D "cn=admin,dc=idptestbed" -w password -s one "(uid=student1)" 1.1

--> 32 No such object
% ldapsearch -x -b "ou=People,dc=idptestbed" -D "uid=student1,ou=People,dc=idptestbed" -w password

## Outside the container (docker exec)

ok: Query using admin all objects
% docker exec ldap ldapsearch -x -b dc=idptestbed -D "cn=admin,dc=idptestbed" -w password -s sub "objectclass=*"

ok: Query using admin a specific user
% docker exec ldap ldapsearch -x -b dc=idptestbed -D "cn=admin,dc=idptestbed" -w password -s sub "(uid=student1)"

ok: Query using admin a organizational unit
% docker exec ldap ldapsearch -x -b dc=idptestbed -D "cn=admin,dc=idptestbed" -w password -s sub "(ou=people)"

ok: Query using admin a specific user without attributes
% docker exec ldap ldapsearch -x -b "ou=People,dc=idptestbed" -D "cn=admin,dc=idptestbed" -w password -s one "(uid=student1)" 1.1

docker exec ldap ldapsearch -x -H ldap://ldap:389 -b "ou=people,dc=idptestbed" -s one "(uid=student1)" 1.1
docker exec ldap ldapsearch -x -b "ou=people,dc=idptestbed" -D "cn=admin,dc=idptestbed" -w password -s one "(uid=student1)" 1.1
## Outside the container

ok: Query using admin all objects
% ldapsearch -x -H ldap://ldap:389 -b dc=idptestbed -D "cn=admin,dc=idptestbed" -w password -s sub "objectclass=*"

ok: Query using admin a specific user
% ldapsearch -x -b dc=idptestbed -D "cn=admin,dc=idptestbed" -w password -s sub "(uid=student1)"

ok: Query using admin a organizational unit
% ldapsearch -x -b dc=idptestbed -D "cn=admin,dc=idptestbed" -w password -s sub "(ou=people)"

ok: Query using admin a specific user without attributes
% ldapsearch -x -H ldap://ldap:389 -b "ou=People,dc=idptestbed" -D "cn=admin,dc=idptestbed" -w password -s one "(uid=student1)" 1.1


# dockerized-idp-testbed

Used to validate the following Unicon docker images:

- shibboleth-idp: [https://hub.docker.com/r/unicon/shibboleth-idp](https://github.com/Unicon/shibboleth-idp-dockerized).
- shibboleth-sp: [https://hub.docker.com/r/unicon/shibboleth-sp](https://github.com/Unicon/shibboleth-sp-dockerized).
- simplesamlphp: [https://hub.docker.com/r/unicon/simplesamlphp](https://github.com/Unicon/simplesamlphp-dockerized).

More documentation is forthcoming, but it's a full working IDP, SP, and LDAP server that runs under `docker-compose`. 

1. Update the `idp/Dockerfile` with the version of the base image you want to test.
2. Call `docker-compose build` and then `docker-compose up` (or `docker-compose up -d` to run as a daemon).
3. Browse to `https://idptestbed/` (after setting up an `etc/hosts` file entry pointing to your Docker Host IP), and you can login with `staff1` and `password`.  
4. `ctrl+c` then `docker-compose rm` cleans everything up to try again.

## Prepping for the Test

If testing the Shibboleth IdP build process locally, you'll want to make sure to `docker pull centos:centos7` to ensure that you have the latest before building the IdP. This will ensure that your version will match what Docker Hub will use when it builds. 

Build the IdP with `docker build --tag="unicon/shibboleth-idp:<version>" .`. Make sure the `FROM` entry in testbed's `idp/Dockerfile` matches the tag used in the idp build  or Docker Compose will pull the wrong version when running the Testbed (see step #1).

If testing the SimpleSAMLphp build process locally, you'll want to make sure to `docker pull centos:centos7` to ensure that you have the latest before building the image. This will ensure that your version will match what Docker Hub will use when it builds. 

Build the application with `docker build --tag="unicon/simplesamlphp:<version>" .`. Make sure the `FROM` entry in testbed's `simplesamlphp/Dockerfile` matches the tag used in the ssp build or Docker Compose will pull the wrong version when running the Testbed (see step #1).

## HTTP/2 support for Shibboleth IdP

HTTP/2 support can be added to Jetty by doing the following:

1. Adding the following to the `idp-http2/Dockerfile`:
 
```bash
RUN cd /opt/shib-jetty-base \
    && /opt/jre-home/bin/java -jar ../jetty-home/start.jar --add-to-startd=http2 -Dorg.eclipse.jetty.start.ack.licenses=true
ADD shib-jetty-base/alpn.ini /opt/shib-jetty-base/start.d/
```

> This will automatically accept the GPLv2 license used by the ALPN library utilized by Jetty.

2. Create and populate `idp-http2/shib-jetty-base/alpn.ini`:

```apache
# ---------------------------------------
# Module: alpn
--module=alpn

## Overrides the order protocols are chosen by the server.
## The default order is that specified by the order of the
## modules declared in start.ini.
# jetty.alpn.protocols=h2-16,http/1.1

## Specifies what protocol to use when negotiation fails.
jetty.alpn.defaultProtocol=http/1.1

## ALPN debug logging on System.err
# jetty.alpn.debug=false
```

3. Run the container(s): `docker-compose -f docker-compose-http2.yml build && docker-compose -f docker-compose-http2.yml up`.

4. Test:

- Open the browser network analyzer tools. 
- Ensure that the `protocol` type is shown. 1.
- Browse to `https://idptestbed/idp/`. Chrome, firefox, and safari should show a protocol of "h2".
- Try `curl -k -v https://idptestbed/idp/`. "HTTP/1.1" will likely be shown as curl (at least on OS X) does not have http/2 support.
