FROM gh/saml-sp-simplesamlphp:latest

RUN yum -y update \
    && yum -y install mod_ssl \
    && yum -y clean all

COPY etc-httpd /etc/httpd/
COPY var-simplesamlphp /var/simplesamlphp/
COPY var-www-html/ /var/www/html/

COPY etc-httpd/ssl/domain.crt /etc/pki/tls/certs/localhost.crt
COPY etc-httpd/ssl/domain.key /etc/pki/tls/private/localhost.key

RUN chown apache:apache /var/simplesamlphp/log/ \
    && chown -R apache:apache /var/simplesamlphp/cert/