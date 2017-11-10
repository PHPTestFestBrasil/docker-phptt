#!/usr/bin/env bash

image="PHP_HEAD";

# build
docker build -t phptestfestbrasil/phptt:$image $image

# push
docker push phptestfestbrasil/phptt:$image
