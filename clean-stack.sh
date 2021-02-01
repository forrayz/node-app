
#!/usr/bin/env bash
set -o errexit
set -o pipefail
set -o nounset
echo "#########################################################################"
echo "#          cleanup.sh   BASH scipt                                      #"
echo "usage      ./cleanupr.sh StackName                                      #"
echo "example:   ./cleanup.sh   development                                   #"
echp "above example wil remove development stack containers images and volumes#"
echo "#########################################################################"
NVIRONMENT_PREFIX=$1
docker-compose -p $ENVIRONMENT_PREFIX down -v
