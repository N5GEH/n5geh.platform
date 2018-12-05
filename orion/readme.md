# Orion Context-Broker

**Note:** Before you start with the context-broker make sure that the mongoDB is up and running!

## Introduction and general information

Together with the mongodb the context-broker also known as Orion is the main core of the fiware plattform. It handles all data wihtin the plattform and is required for all activities in and around fiware. To retrieve data from this database, users can query API of the context-broker.

"Orion is a C++ implementation of the [NGSIv2 REST API](https://swagger.lab.fiware.org/?url=https://raw.githubusercontent.com/Fiware/specifications/master/OpenAPI/ngsiv2/ngsiv2-openapi.json#/)(Swagger Documentation) binding developed as a part of the FIWARE platform.

Orion Context Broker allows you to manage the entire lifecycle of context information including updates, queries, registrations and subscriptions. It is an NGSIv2 server implementation to manage context information and its availability. Using the Orion Context Broker, you are able to create context elements and manage them through updates and queries. In addition, you can subscribe to context information so when some condition occurs (e.g. the context elements have changed) you receive a notification. These usage scenarios and the Orion Context Broker features are described in this documentation."

The detailed documentation and the user manual can be found [here](https://fiware-orion.readthedocs.io/en/latest/index.html). It provides all necessary information about the API and the whole functionality of the context-broker. Here especially the understanding of the ability for multi-tenancy is very important for large destributed IoT-Applications.

Furthermore, if you are interested in the code itself you'll find it on GitHub:
https://github.com/telefonicaid/fiware-orion

## Current developments in the API:



## How to start:

1. Go into the mongodb subdirectory of your cloned version of the git and copy the docker-compose.yaml.EXAMPLE and possibly further configuration files

        cp docker-compose.yaml.EXAMPLE docker-compose.yaml

3. You may the docker-compose.yaml to you preferences e.g. you need to
adjust the placement of the container. Because of the mapped local volume of the
docker container where the data is stored we always need to place the database container on the same host of our docker-swarm. Hence, you need to adjust that line. In case you want to use a NFS-server or some other kind of shared volumes you need to change this line and in addition to that the volume mapping line.

      **Note:** Some changes may require the modification of Makefile that comes
      along or other depending services!

4. Start the service either using the commands provided in the Makefile
        make deploy

      or directly with docker command

        docker stack deploy -c docker-compose.yaml fiware
