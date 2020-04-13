FROM centos:7

ENV VERSION=0.4.0


RUN yum install -y yum-utils && yum-config-manager --add-repo https://openresty.org/package/centos/openresty.repo  && \
    yum install epel-release -y && yum install awk mysql gcc gcc-c++ openresty openresty-resty luarocks lua-devel libtool pcre-devel which -y && \
    rpm -ivh https://github.com/apioak/apioak/releases/download/v${VERSION}/apioak-${VERSION}-1.el7.x86_64.rpm && \
    yum clean all && rm -rf /var/cache/yum/* && \
    ln -sf /dev/stdout /usr/local/apioak/logs/access.log && ln -sf /dev/stderr /usr/local/apioak/logs/error.log && \
    sed -i "1i\\daemon off;" /usr/local/apioak/conf/nginx.conf

ENV TIME_ZONE= \
    DB_HOST=127.0.0.1 \
    DB_PORT=3306 \
    DB_NAME=apioak \
    DB_USER=root \
    DB_PASSWORD=  

EXPOSE 10080
ADD entrypoint.sh /entrypoint.sh 

ENTRYPOINT ["sh", "/entrypoint.sh"]