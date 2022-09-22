#!/bin/sh
# For building the 'dev' image
set -x
docker build -t srl295/dock-warrior:dev .
