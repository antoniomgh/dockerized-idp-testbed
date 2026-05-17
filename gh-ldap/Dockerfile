FROM osixia/openldap:1.5.0
LABEL maintainer="antoniomgh@gmail.com"

COPY bootstrap.ldif /container/service/slapd/assets/config/bootstrap/ldif/custom/50-bootstrap.ldif
COPY wait-for-it.sh /usr/bin/

ENV LDAP_BASE_DN="ou=people,dc=idptestbed,dc=localhost"
ENV LDAP_ORGANISATION="Example Organization"
ENV LDAP_DOMAIN="idptestbed.localhost"
ENV LDAP_ADMIN_PASSWORD="password"
ENV LDAP_TLS="false"