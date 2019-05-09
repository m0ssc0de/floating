#!/bin/sh

mkdir /dev/net
mknod /dev/net/tun c 10 200
/nebula -config /etc/nebula/config.yml
