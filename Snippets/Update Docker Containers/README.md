# .UPDATE_CONTAINERS.SH

A simple script for small environments who take care of download the latest images from docker, remove and recreate every container that is running on your machine.

### NOTE
In order to work, the script supposes that you have all the docker-compose files (named **docker-compose.yaml**) into subfolders (the script will search in /opt folder but you can of course configure it) with the same name of the container's name (for example the folder for the navidrome container must be called navidrome). 

### To avoid problems with containers who depends on anothers that don't need to be created through docker-compose:

For example for a Nextcloud container that in docker-compose file depends on the db container: 
In this case there are 2 containers that are running:
- nextcloud-app
- nextcloud-db


In this case we need to recreate only the nextcloud-app container (nextcloud-db is specified inside the same docker-compose file). I've in my /opt/ folder only the nextcloud-app folder, that contains the docker-compose.yaml file. The script will update the image also for nextcloud-db, will stop and resume it but it will not launch the docker-compose file, because it will not find it into /opt/nextcloud-db (that doesn't exists).


## HOW IT WORKS
1. Get the list of all current docker containers that are running
2. Pull the latest images for ALL the containers
3. Stop, remove every container
4. Launch the docker compose file ONLY if found (see note above)
