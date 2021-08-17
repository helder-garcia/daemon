#!/bin/sh

set -e

# binary daemon
/usr/bin/q1v-node --data-dir /quan --enable-blockchain-indexes --restricted-rpc --log-file /quan/daemon.log --p2p-bind-ip 0.0.0.0 --rpc-bind-ip 0.0.0.0

exec "$@"
