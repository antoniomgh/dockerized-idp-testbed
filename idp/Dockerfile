FROM unicon/shibboleth-idp:latest
MAINTAINER Unicon, Inc.

# https://dev.to/franzwong/fix-cannot-find-a-valid-baseurl-for-repo-in-centos-1h07
ARG repo_file="/etc/yum.repos.d/CentOS-Base.repo"
RUN cp ${repo_file} ~/CentOS-Base.repo.backup
RUN sed -i s/#baseurl/baseurl/ ${repo_file}
RUN sed -i s/mirrorlist.centos.org/vault.centos.org/ ${repo_file}
RUN sed -i s/mirror.centos.org/vault.centos.org/ ${repo_file}
RUN yum clean all

RUN yum -y update \
    && yum -y install openldap-clients \
    && yum -y clean all

COPY shibboleth-idp/ /opt/shibboleth-idp/
COPY shib-jetty-base/ /opt/shib-jetty-base/
