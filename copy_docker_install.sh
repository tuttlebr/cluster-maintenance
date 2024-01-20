#!/bin/bash
REMOTE_HOSTS="daedalus-02 daedalus-03"
clear
for REMOTE_HOST in ${REMOTE_HOSTS};
do 
    echo ${REMOTE_HOST}
    scp install-docker.sh ${REMOTE_HOST}:/home/brandon
    ssh ${REMOTE_HOST} /home/brandon/install-docker.sh
done
