#!/bin/bash

# Wraps the mgmt_power script with a few changes:
#  - only the hard_cycle subcommand is used
#  - the force option is always enabled
#  - the host name may omit the 'sjc1-' prefix
#  - the host name is echoed if it fails to cycle
#  - it always exit 0
#
# By only printint failed hosts and exiting 0, this can simplify bulk
# power cycling:
#
#   mdb get basquiat | xargs -I X ./pwr X > failed.log
#   cat failed.log | xargs -I X ./pwr X > failed.log
#   ...

set -eo pipefail

HOST=$1

if [[ "$HOST" == "" ]]; then
	echo "host missing"
	exit
fi

if [[ $HOST != sjc1-* ]]; then
	HOST=sjc1-$HOST
fi

if ! mgmt_power hard_cycle $HOST force > /dev/null; then
	echo $HOST
fi
