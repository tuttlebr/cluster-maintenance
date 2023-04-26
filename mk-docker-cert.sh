#!/bin/bash
USERNAME=admin
PASSWORD=admin
NAME=discovery
CERTS_DEST=/volume1/brandon/docker-registry/certs
AUTH_PATH=/volume1/brandon/docker-registry/auth
REMOTE_HOSTS="daedalus-02 daedalus-03"
clear 

rm -f ${NAME}.* htpasswd

sudo openssl genrsa 1024 > ${NAME}.key
chmod 400 ${NAME}.key
sudo openssl req -new -x509 -nodes -sha1 -days 365 -key ${NAME}.key -out ${NAME}.crt -config san.cnf
docker run --rm --entrypoint htpasswd registry:2.7.0 -Bbn ${USERNAME} ${PASSWORD} > htpasswd

rsync --rsync-path="sudo rsync" -apv htpasswd ${AUTH_PATH}
sudo mkdir -p /etc/docker/certs.d/${NAME}.local:31500
rsync --rsync-path="sudo rsync" -apv ${NAME}.crt /etc/docker/certs.d/${NAME}.local:31500/ca.crt
rsync --rsync-path="sudo rsync" -apv ${NAME}.* ${CERTS_DEST}

for REMOTE_HOST in ${REMOTE_HOSTS};
do 
    echo "Setting up ${REMOTE_HOST}"
    ssh ${REMOTE_HOST} sudo mkdir -p /etc/docker/certs.d/${NAME}.local:31500
    rsync --rsync-path="sudo rsync" -apv ${NAME}.crt ${REMOTE_HOST}:/etc/docker/certs.d/${NAME}.local:31500/ca.crt
done

echo "Docker cert creation completed."
echo "Restart the docker registry server to pick up new credentials."