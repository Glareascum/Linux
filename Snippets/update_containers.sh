#!/bin/bash

echo "----UPGRADING IMAGES----"

list=$(docker ps --format "{{.Image}}\t{{.Names}}")
while read -r line
do
	lineStr=$line

	# Get the image name
	image=$(echo $lineStr | awk '{print $1}')
	# Get the container name
	container=$(echo $lineStr | awk '{print $2}')

	echo "Processing container $container..."

	echo "Upgrading image"
	docker pull $image

	echo "Removing container"
	docker container stop $container
	docker container rm  $container

 	printf "******************************\n\n"
done <<< "$list"	

echo "-----RESTARTING CONTAINERS-----"

while read -r line
do
	lineStr=$line

	# Get the container name
	container=$(echo $lineStr | awk '{print $2}')

	composePath=/opt/$container/docker-compose.yaml
	echo "Checking file $composePath"

	if [ -f "$composePath" ]; then
		echo "Recreating container"
		docker-compose -f $composePath up -d
	else
		echo "File not found, skipping compose..."
	fi

	printf "\n\n"

done <<< "$list"

echo "DONE!"

