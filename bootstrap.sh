#!/usr/bin/env bash
set -o errexit
set -o pipefail
set -o nounset
echo "##############################################"
echo "#     bootstrap.sh   BASH scipt              #"
echo "##############################################"
sed -n '/MainConfigBegins/,/MainConfigEnds/p' .env > bootstrap.env
source bootstrap.env

export ENVIRONMENT_PREFIX=$1
export DOMAIN=$2

export POSTGRES_USER=$POSTGRES_USER
export POSTGRES_PASSWORD=$POSTGRES_PASSWORD
export POSTGRES_DB=$POSTGRES_DB




docker-compose --compatibility -p ${ENVIRONMENT_PREFIX} up --build --force-recreate --no-deps --detach
docker exec ${ENVIRONMENT_PREFIX}_n8n_1 sh -c "node --version"
docker network connect ${ENVIRONMENT_PREFIX}_default nginx || true

DATABASE_PORT=$(docker port ${ENVIRONMENT_PREFIX}_postgres_1 | cut -d ':' -f 2)
( echo "cat <<EOF" ; cat services.html ; echo EOF ) | sh > ${ENVIRONMENT_PREFIX}.html     
docker cp ${ENVIRONMENT_PREFIX}.html service-discovery:/web/
( echo "cat <<EOF" ; cat nginx-template.conf ; echo EOF ) | sh > ${ENVIRONMENT_PREFIX}.conf
docker cp ${ENVIRONMENT_PREFIX}.conf nginx:/etc/nginx/conf.d
docker exec nginx sh -c "nginx -t && nginx -s reload"
docker logs ${ENVIRONMENT_PREFIX}_n8n_1

docker-compose -p $ENVIRONMENT_PREFIX restart
docker-compose -p $ENVIRONMENT_PREFIX ps

