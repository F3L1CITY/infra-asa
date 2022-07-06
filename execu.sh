#!/bin/bash

if [ -z $1 ];then
	docker stop s1
	docker stop web1
	docker stop web2
else
	cd dns
	docker build -t ubuntu .
	cd etc
    sed -i "s/primary/$1/" db.prova.asa.br
	wrk=$(pwd)
    docker run -d -p $1:53:53/udp -p $1:53:53/tcp --name s1 --hostname dns-s1 -v "$wrk"/:/etc/bind --dns $1 ubuntu
	echo "Name container to dns primary => s1"
	cd ..
	cd ..
	cd web1
	docker build -t nginx .
	docker run -d --name web1 -p 8080:80 nginx
	cd ..
	cd web2
	docker build -t apache .
	docker run -d --name web2 -p 8000:80 apache
fi
