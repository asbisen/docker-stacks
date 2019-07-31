#!/bin/sh

set -e

SRV="srv.apnet.local:5000"
NAME="minimal-notebook"
TAG="latest"
DT=`date +%y-%m-%d`

docker build . -t ${SRV}/${NAME}:${TAG}
docker tag ${SRV}/${NAME}:${TAG} ${SRV}/${NAME}:${DT}
docker push ${SRV}/${NAME}:${TAG}
docker push ${SRV}/${NAME}:${DT}
