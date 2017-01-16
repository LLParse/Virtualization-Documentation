#!/bin/bash

REPO=${REPO:-llparse}
VERS=${VERS:-latest}
NAME=asp-net-blog

rm -f dist/images
for x in $(ls); do
  if [ -d $x ] && [ -f $x/Dockerfile ]; then
    IMAGE="$REPO/$NAME-$x:$VERS"
    echo "Building $IMAGE"

    pushd $x &> /dev/null
    docker build -t $IMAGE .
    popd &> /dev/null

    mkdir -p dist
    echo $IMAGE >> dist/images
    popd &> /dev/null
  fi
done

