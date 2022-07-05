#!/bin/bash

op=8
while test $op != 0; do
	echo "------------------------------------------------------"
	echo "-------------------- Admin Docker --------------------"
	echo "------------------------------------------------------"
	echo "0 - Stop script"
	echo "1 - List Containers in execution"
	echo "2 - List All Containers"
	echo "3 - Stop, Restart, Start bind9 in s1 and/or s2 with <exec>"
	echo "4 - Delete container s1 and/or s2"
	echo "5 - View Logs s1 or s2"
	echo "6 - Inspect Container"
	echo "7 - Delete image"
	echo "8 - Delete volumes not in use"
	echo "9 - Delete other container"
	echo "Option> " ; read op
	echo
	case $op in
	0)
		echo "Stopedd";;
	1)
		docker ps;;
	2)
		docker ps -a;;
	3)
		echo "1 - s1 | 2 - s2 | 3 - all"
		read ns
		echo "1 - stop | 2 - restart | 3 - start"
		read func
		case $ns in
		1)
			case $func in
			1)
				docker exec s1 /etc/init.d/named stop;;
			2)
				docker exec s1 /etc/init.d/named restart;;
			3)
                                docker exec ns1 /etc/init.d/named start;;
			*)
				echo "Invalid Option"
			esac;;
		2)
			case $func in
			1)
                                docker exec s2 /etc/init.d/named stop;;
                        2)
                                docker exec s2 /etc/init.d/named restart;;
                        3)
                                docker exec s2 /etc/init.d/named start;;
                        *)
                	        echo "Invlaid option"
			esac;;
		3)
			case $func in
			1)
                        	docker exec s1 /etc/init.d/named stop
				docker exec s2 /etc/init.d/named stop;;
                        2)
                                docker exec s1 /etc/init.d/named restart
				docker exec s2 /etc/init.d/named restart;;
                        3)
                                docker exec s1 /etc/init.d/named start
				docker exec s2 /etc/init.d/named start;;
                        *)
                                echo "Invlaid option"
			esac;;
		*)
			echo "Invalid Option..."
		esac;;
	4)
		echo "1 - s1 | 2 - s2 | 3 - all" ; read nss
		case $nss in
		1)
			docker rm -f s1;;
		2)
			docker rm -f s2;;
		3)
			docker rm -f s1
			docker rm -f s2;;
		*)
			echo "Invalid Option"
		esac;;
	5)
		echo "Name dns>" ; read ns
		docker exec $ns named -g;;

	6)
		echo "Name of container> " ; read name
		docker inspect $name;;
	7)
		echo "Name of image> " ; read named
		docker rmi -f $named;;
	8)
		docker volume prune -f;;

	9)
		echo "Name of container> " ; read name
                docker rm -f $name;;
	*)
		echo "Invalid option"
	esac
done
