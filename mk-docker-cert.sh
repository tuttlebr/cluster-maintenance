#!/bin/bash
USERNAME=admin
PASSWORD=admin
NAME=discovery
CERTS_DEST=/volume1/brandon/docker-registry/certs
AUTH_PATH=/volume1/brandon/docker-registry/auth
clear 

rm -f ${NAME}.* htpasswd

sudo openssl genrsa 1024 > ${NAME}.key
chmod 400 ${NAME}.key
sudo openssl req -new -x509 -nodes -sha1 -days 365 -key ${NAME}.key -out ${NAME}.crt -config san.cnf
docker run --rm --entrypoint htpasswd registry:2.7.0 -Bbn ${USERNAME} ${PASSWORD} > htpasswd

cp -p htpasswd ${AUTH_PATH}
sudo mkdir -p /etc/docker/certs.d/${NAME}.local:31500
sudo cp -p ${NAME}.crt /etc/docker/certs.d/${NAME}.local:31500/ca.crt
sudo cp -p ${NAME}.* ${CERTS_DEST}