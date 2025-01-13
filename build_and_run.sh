#!/bin/sh

sudo docker build . -t urpagin-dot-net

sudo docker run --name urpagin-dot-net -d -p 35037:3000 urpagin-dot-net
