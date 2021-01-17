#!/usr/bin/env bash
set -o errexit
set -o pipefail
set -o nounset
echo "##############################################"
echo "#     bootstrap.sh   BASH scipt              #"
echo "##############################################"
sed -n '/MainConfigBegins/,/MainConfigEnds/p' .env > bootstrap.env
source bootstrap.env

ENVIRONMENT_PREFIX=$1
echo "argument-ENVIRONMENT_PREFIX---->$ENVIRONMENT_PREFIX"
echo "argument-MONGO_USERNAME-------->$MONGO_USERNAME"
echo "argument-MONGO_USERNAME-------->$MONGO_PASSWORD"
echo "argument-MONGO_PORT------------>$MONGO_PORT"
echo "argument-MONGO_DB-------------->$MONGO_DB"

APP_CONTAINER_NAME=$ENVIRONMENT_PREFIX"_app_1"
DB_CONTAINER_NAME=$ENVIRONMENT_PREFIX"_db_1"


docker-compose --compatibility -p $ENVIRONMENT_PREFIX up --force-recreate --no-deps --detach 

./wait-for-healthy-container.sh $TER_DB_CONTAINER_NAME 10
docker exec ${ENVIRONMENT_PREFIX}_app_1 sh -c "node -version"
docker network connect ${ENVIRONMENT_PREFIX}_default nginx || true


DATABASE_PORT=$(docker port ${ENVIRONMENT_PREFIX}_db_1 | cut -d ':' -f 2)
( echo "cat <<EOF" ; cat services.html ; echo EOF ) | sh > ${ENVIRONMENT_PREFIX}.html     
docker cp ${ENVIRONMENT_PREFIX}.html service-discovery:/web
( echo "cat <<EOF" ; cat nginx-template.conf ; echo EOF ) | sh > ${ENVIRONMENT_PREFIX}.conf
docker cp ${ENVIRONMENT_PREFIX}.conf nginx:/etc/nginx/conf.d
docker exec nginx sh -c "nginx -t && nginx -s reload"
docker logs ${ENVIRONMENT_PREFIX}_app_1

docker-compose -p $ENVIRONMENT_PREFIX restart
