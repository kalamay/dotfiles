#! /bin/bash

./versions.sh $2 | grep -v $1 | awk '{print $1'}
