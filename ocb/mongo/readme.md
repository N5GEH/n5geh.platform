# MongoDB as storage for the context data within FIWARE

**Note:** Within the total setup procedure always start with the mongoDB first.

## Introduction and general information

Within the fiware core mongodb is used for persisting context data across restarts. It is a requirement to the context-broker aka Orion, which itself is the main core of fiware.
To retrieve data from this database, you should always use the query API of the context-broker.
It is recommended to use the context-broker instead of the direct database access for both reasons: Security and data consistency.

"MongoDB is a document database with the scalability and flexibility that you want with the querying and indexing that you need"

- MongoDB stores data in flexible, JSON-like documents, meaning fields can vary from document to document and data structure can be changed over time

- The document model maps to the objects in your application code, making data easy to work with

- Ad hoc queries, indexing, and real time aggregation provide powerful ways to access and analyze your data (not recommended in our scenario)

- MongoDB is a distributed database at its core, so high availability, horizontal scaling, and geographic distribution are built in and easy to use

- MongoDB is free and open-source. Versions released prior to October 16, 2018 are published under the AGPL. All versions released after October 16, 2018, including patch fixes for prior versions, are published under the [Server Side Public License (SSPL) v1](https://www.mongodb.com/licensing/server-side-public-license).

For detailed information please visit https://www.mongodb.com.

**Note:** For our purposes the community edition should be sufficient.

Beside from mongo-db there are also many other DB-engines our there. The developers of fiware decided to choose this engine. For a comparative overview of diffenrent database engines, also the underlying of fiware click
 [here](https://db-engines.com/en/system/CrateDB%3BInfluxDB%3BMongoDB).

## How to start:

1. Go into the mongodb subdirectory of your cloned version of the git and copy the docker-compose.yaml.EXAMPLE and possibly further configuration files

        cp docker-compose.yaml.EXAMPLE docker-compose.yaml

2. You may adjust the docker-compose.yaml to your preferences e.g. you need to
adjust the placement of the container. Because of the mapped local volume of the
docker container where the data is stored we always need to place the database container on the same host of our docker-swarm. Hence, you need to adjust that line. In case you want to use a NFS-server or some other kind of shared volumes you need to change this line and in addition to that the volume mapping line.

      **Note:** Some changes may require the modification of Makefile that comes
      along or other depending services!

3. Start the service either using the commands provided in the Makefile

        make deploy

      Note, that this is just a shortcut for

        docker stack deploy -c docker-compose.yaml fiware

4. For watching what is happening in the database you can use a GUI tool such  as MongoDB Compass ([Link](https://www.mongodb.com/download-center/compass))

    **Note:** For using an external GUI you need to expose the port mongoDB. Which should be **always** handeled with care in the security settings. For docker network internal operation this is not necessary.
