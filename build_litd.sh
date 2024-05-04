#!/bin/bash 

[[ "$1" == "" ]] && echo "Usage: $0 release_version" && exit 1

DOCKERFILE=$(mktemp) 
trap "rm $DOCKERFILE " EXIT


wget https://raw.githubusercontent.com/lightninglabs/lightning-terminal/master/Dockerfile -O $DOCKERFILE

docker build -f $DOCKERFILE  -t localhost/lightning-terminal --build-arg checkout=$1 . 
