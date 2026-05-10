FROM centos:centos7 as stage

# https://dev.to/franzwong/fix-cannot-find-a-valid-baseurl-for-repo-in-centos-1h07
ARG repo_file="/etc/yum.repos.d/CentOS-Base.repo"
RUN cp ${repo_file} ~/CentOS-Base.repo.backup
RUN sed -i s/#baseurl/baseurl/ ${repo_file}
RUN sed -i s/mirrorlist.centos.org/vault.centos.org/ ${repo_file}
RUN sed -i s/mirror.centos.org/vault.centos.org/ ${repo_file}
RUN yum clean all

RUN yum -y update \
    && yum -y install ant doxygen git php-pear wget \
    && yum -y clean all

RUN wget http://pear.php.net/go-pear.phar \
 && php go-pear.phar \
 && rm go-pear.phar

RUN git clone --depth=1 --branch=1.3-stable https://github.com/apereo/phpCAS.git apereo/phpCAS \
 && pear upgrade --force --alldeps \
 && cd apereo/phpCAS/utils \
 && pear install --onlyreqdeps PEAR_PackageFileManager2-beta \
 && ant dist -Ddoxygen.path=/usr/bin/doxygen -Dphp.path=/usr/bin/php

FROM centos:centos7

MAINTAINER Unicon, Inc.

# https://dev.to/franzwong/fix-cannot-find-a-valid-baseurl-for-repo-in-centos-1h07
ARG repo_file="/etc/yum.repos.d/CentOS-Base.repo"
RUN cp ${repo_file} ~/CentOS-Base.repo.backup
RUN sed -i s/#baseurl/baseurl/ ${repo_file}
RUN sed -i s/mirrorlist.centos.org/vault.centos.org/ ${repo_file}
RUN sed -i s/mirror.centos.org/vault.centos.org/ ${repo_file}
RUN yum clean all

RUN yum -y update \
    && yum -y install httpd mod_ssl php php-pear php-xml php-pdo wget \
    && yum -y clean all

COPY --from=stage /apereo/phpCAS/utils/dist/CAS-1.3.4.tgz /

RUN pear install CAS-1.3.4.tgz \
 && rm /CAS-1.3.4.tgz

COPY httpd-foreground /usr/local/bin/
COPY etc-httpd/ /etc/httpd/
COPY var-www-html/ /var/www/html/

RUN chmod +x /usr/local/bin/httpd-foreground

EXPOSE 80 443

CMD ["httpd-foreground"]
