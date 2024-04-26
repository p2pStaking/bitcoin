#!/bin/bash 

[[ "$1" == "" ]] && echo "Usage: $0 git_tag [docker_repo/image]" && exit 1 

cd "$( dirname "${BASH_SOURCE[0]}" )"
BDIR=$(pwd)


REPO=${2:-p2pstaking/fulcrum}

DIR=$(mktemp -d)
trap "rm -Rf $DIR" EXIT

cd $DIR 
git clone https://github.com/cculianu/Fulcrum.git
cd Fulcrum

DOCKER_VERSION=$( echo $1 |  egrep  -o '[0-9\.]{1,}')

./contrib/build/build.sh linux $1

FULCRUM_FILE=$PWD/dist/linux/Fulcrum
cd $BDIR

mv $FULCRUM_FILE . 
docker build .  -t $REPO:$DOCKER_VERSION
rm Fulcrum
docker push $REPO:$DOCKER_VERSION

echo "Fulcrum image $REPO:$DOCKER_VERSION pushed. "
echo ; echo 
echo "if it is the latest version, RUN the following commands: "
echo "docker tag $REPO:$DOCKER_VERSION $REPO:latest"
echo "docker push $REPO:latest"
