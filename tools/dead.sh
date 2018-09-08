#!/bin/bash

# Checks basic reachability of a host

set -eo pipefail

HOST=$1

if [[ "$HOST" == "" ]]; then
	echo "host missing"
	exit
fi

if [[ $HOST != sjc1-* ]]; then
	HOST=sjc1-$HOST
fi

# start with a basic ping check
if ! ping -c 1 $HOST > /dev/null; then
	echo $HOST
fi

# check if TCP is available on port 22 
if ! (exec 3<>/dev/tcp/$HOST/22) 2> /dev/null; then
	echo $HOST
fi

# check if SSH actuall works (this can be a bit slow at the moment)
if ! ssh $HOST 'hostname' > /dev/null; then
	echo $HOST
fi

