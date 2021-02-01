#!/usr/bin/env bash
set -o errexit
set -o pipefail
set -o nounset
ENVIRONMENT_PREFIX=$1
docker network disconnect ${ENVIRONMENT_PREFIX}_default nginx || true
docker-compose -p $ENVIRONMENT_PREFIX down -v

docker run --rm -v node-app_service-discovery-volume:/data busybox rm -fv  /data/${ENVIRONMENT_PREFIX}.html || true
#docker cp ${ENVIRONMENT_PREFIX}.html service-discovery:/web/

