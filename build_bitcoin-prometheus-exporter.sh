#!/bin/bash 

[[ "$1" == "" ]] && echo "Usage: $0 release" && exit 1

TMP_DIR=$(mktemp) 
trap "rm -Rf $TMP_DIR" EXIT

cd $TMP_DIR
git clone https://github.com/jvstein/bitcoin-prometheus-exporter.git
cd bitcoin-prometheus-exporter

git checkout $1

docker build -t localhost/bitcoin-prometheus-exporter:$1 .
