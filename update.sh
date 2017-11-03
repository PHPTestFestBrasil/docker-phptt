#!/usr/bin/env bash

for image in $(for i in $(ls); do test -d $i && echo $i ; done); do 
    # build
    docker build -t phptestfestbrasil/phptt:$image $image

    # push
    docker push phptestfestbrasil/phptt:$image
done