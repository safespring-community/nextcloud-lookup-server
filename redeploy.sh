#!/bin/bash
set -eu

POSITIONAL=()
ERASE_S3='0'
PRUNE_VOLUMES='0'
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -p|--prune)
    PRUNE_VOLUMES='1'
    shift # past argument
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

echo "Redeploying Nextcloud Lookup Server"

docker rm -f nextcloud-lookup-server_app_1 nextcloud-lookup-server_db_1 nextcloud-lookup-server_proxy_1 || true

if [ ${PRUNE_VOLUMES} == '1' ]
then
  echo "Pruning docker volumes with label com.docker.compose.project=nextcloud-lookup-server"
  docker volume prune --force --filter label=com.docker.compose.project=nextcloud-lookup-server
fi

docker build --no-cache -t jakubkrzywda/lookup:apache .
docker-compose up -d

echo "Nextcloud Lookup Server redeployed"
