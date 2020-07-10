#!/bin/sh

mkdir /dev/net
mknod /dev/net/tun c 10 200
/tunnels 0.0.0.0:$PORT 172.17.0.1:$PORT