#!/bin/bash

msg=$(curl --connect-timeout 1 -s http://$1:8001/_imgix/vars | awk '{print $3}' | tr -d '[",]')
echo "$1 $msg"
