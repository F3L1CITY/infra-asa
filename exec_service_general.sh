#!/bin/bash

if [ -z $1 ];then
	echo "No IP setting for primary dns"
else
	docker build -t ubuntu .
	cd primary
        sed -i "s/primary/$1/" db.prova.asa.br
	wrk=$(pwd)
        if [ -z $2 ];then
		echo "--------------------------------"
                echo "IP Secondary DNS is => 127.0.0.1"
                echo "--------------------------------"
                sed -i "s/secondary/127.0.0.1/" db.prova.asa.br
                sed -i "s/secondary/127.0.0.1/" named.conf.default-zones
                docker run -d -p $1:53:53/udp -p $1:53:53/tcp --name s1 --hostname dns-s1 -v "$wrk"/:/etc/bind --dns $1 ubuntu
        	echo "Name container to dns primary => s1"
	else
                sed -i "s/secondary/$2/" db.prova.asa.br
                sed -i "s/secondary/$2/" named.conf.default-zones
                docker run -d -p $1:53:53/udp -p $1:53:53/tcp --name s1 --hostname dns-s1 -v "$wrk"/:/etc/bind --dns $1 ubuntu
		echo "Name container to dns primary => s1"
	fi
fi

if [ -z $1 ];then
	echo "No primary dns so don't upgrade secondary"
else
	cd ..
	cd secondary
	wrk2=$(pwd)
       	sed -i "s/primary/$1/" named.conf.default-zones
	if [ -z $2 ];then
		docker run -d --name s2 --hostname dns-s2 -p 127.0.0.1:53:53/udp -p 127.0.0.1:53:53/tcp -v "$wrk2"/:/etc/bind --dns 127.0.0.1 ubuntu
		echo "Name container to dns secondary => s2"
	else
		docker run -d --name s2 --hostname dns-s2 -p $2:53:53/udp -p $2:53:53/tcp -v "$wrk2"/:/etc/bind --dns $2 ubuntu
		echo "Name container to dns secondary => s2"
	fi
fi
