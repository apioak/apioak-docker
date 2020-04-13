#!/bin/bash

#timezone
if [[ -n $TIME_ZONE ]];then
    ln -sf /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime
fi

#apioak config
sed -i "s@127.0.0.1@$DB_HOST@g" /usr/local/apioak/conf/apioak.yaml
sed -i "s@3306@$DB_PORT@g" /usr/local/apioak/conf/apioak.yaml
sed -i "s@apioak@$DB_NAME@g" /usr/local/apioak/conf/apioak.yaml
sed -i "s@root@$DB_USER@g" /usr/local/apioak/conf/apioak.yaml
sed -i "s@123000@$DB_PASSWORD@g" /usr/local/apioak/conf/apioak.yaml

sed -i "s@resolver 8.8.8.8 114.114.114.114 ipv6=off;@resolver $(grep nameserver /etc/resolv.conf|awk '{printf $2" "}')ipv6=off;@g"  /usr/local/apioak/conf/nginx.conf

#init_db
if [[ -z $(mysql -u$DB_USER -p$DB_PASSWORD -h$DB_HOST -P$DB_PORT $DB_NAME -e "show tables;" |grep "oak_users") ]];then
    mysql -u$DB_USER -p$DB_PASSWORD -h$DB_HOST -P$DB_PORT $DB_NAME < /usr/local/apioak/conf/apioak.sql
fi


/usr/bin/apioak start