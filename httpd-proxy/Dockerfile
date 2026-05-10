FROM centos:centos7

# https://dev.to/franzwong/fix-cannot-find-a-valid-baseurl-for-repo-in-centos-1h07
ARG repo_file="/etc/yum.repos.d/CentOS-Base.repo"
RUN cp ${repo_file} ~/CentOS-Base.repo.backup
RUN sed -i s/#baseurl/baseurl/ ${repo_file}
RUN sed -i s/mirrorlist.centos.org/vault.centos.org/ ${repo_file}
RUN sed -i s/mirror.centos.org/vault.centos.org/ ${repo_file}
RUN yum clean all

RUN yum -y update \
    && yum -y install httpd mod_ssl mod_ldap \
    && yum -y clean all

COPY httpd-foreground /usr/local/bin/
COPY etc-httpd/ /etc/httpd/
COPY var-www-html/ /var/www/html/

RUN chmod +x /usr/local/bin/httpd-foreground

EXPOSE 80 443

CMD ["httpd-foreground"]