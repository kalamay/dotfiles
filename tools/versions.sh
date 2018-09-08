#!/bin/bash

if [ "$1" == "" ]; then
	mdb get painter | xargs -I '{}' ./_ver.sh '{}'
else
	mdb get painter | grep $1 | xargs -I '{}' ./_ver.sh '{}'
fi
