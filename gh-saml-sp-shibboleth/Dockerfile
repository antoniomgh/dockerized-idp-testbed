FROM rockylinux/rockylinux:8.4
LABEL maintainer="antoniomgh@gmail.com"

# Shibboleth packakes: https://shibboleth-mirror.cdi.ti.ja.net/rockylinux8/x86_64/
# Sibboleth repository configuration
RUN <<EOF cat > /etc/yum.repos.d/shibboleth.repo
[shibboleth]
name=Shibboleth (rockylinux8)
type=rpm-md
mirrorlist=https://shibboleth.net/cgi-bin/mirrorlist.cgi/rockylinux8
gpgcheck=1
gpgkey=https://shibboleth.net/downloads/service-provider/RPMS/cantor.repomd.xml.key
enabled=1
EOF

ARG VERSION_PHP=7.4.33
ARG VERSION_HTTPD=2.4.37
ARG VERSION_SHIBBOLETH=3.5.2-1.el8.x86_64

RUN dnf module enable -y php:7.4 \
    && dnf install -y mod_ssl shibboleth-$VERSION_SHIBBOLETH httpd-$VERSION_HTTPD php-$VERSION_PHP \
    && dnf clean all \
    && rm -rf /var/cache/yum

RUN sed -i 's|^LogLevel \+[^ $]\+|LogLevel info |g' /etc/httpd/conf/httpd.conf

RUN find /etc/httpd/ -name "*.conf" -exec sed -i \
    -e 's|ErrorLog ".*"|ErrorLog /dev/stderr|g' \
    -e 's|ErrorLog [^/].*|ErrorLog /dev/stderr|g' \
    -e 's|CustomLog ".*"|CustomLog /dev/stdout|g' \
    -e 's|CustomLog \+[^\ ]\+|CustomLog /dev/stdout |g' \
    -e 's|TransferLog ".*"|TransferLog /dev/stdout|g' \
    -e 's|TransferLog [^/].*|TransferLog /dev/stdout|g' \
    {} +

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/pki/tls/private/localhost.key \
    -out /etc/pki/tls/certs/localhost.crt \
    -subj "/C=ES/ST=Madrid/L=Alcorcon/O=IT/CN=localhost"

COPY entrypoint /usr/local/bin/

EXPOSE 80 443

CMD ["entrypoint"]
