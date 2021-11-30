# FIWARE-Stack Setup

Welcome to the quick setup of the FIWARE core on a Unix OS! 
With some minor changes to the docker stack files it might also work on a Windows OS but this is not tested so far! 

**Note:** We mostly link, sum up and also copy official documentation written and published by the FIWARE (Future Internet Software) foundation for that we do not claim ownership. Furthermore, we used the the recipes created as part of the SmartSDK project (https://www.smartsdk.eu/) which can be found on github:
https://github.com/smartsdk/smartsdk-recipes

## Introduction

This repository contains example docker-stack.yamls and for the easy deployment of core elements aka *Generic Enablers* of the the FIWARE plattform in a docker swarm setup.
"FIWARE is a curated framework of open source platform components to
 accelerate the development of Smart Solutions." 
 Beside the fact that FIWARE is freely distributed, it comes along with the benefits of a large community and offers a set of advanced components including a high performance database engine and a sophisticated set of Representational State Transfer (REST) application programming interfaces (API) using the standardized Next Generation Service Interface (NGSI) format, which is also the formal standard for context information management systems in smart cities.
 For more general information about FIWARE, why to use it and its core concept please check https://www.fiware.org/developers/ <br>

At the moment, the FIWARE catalogue contains about 30 interoperable software modules, so-called Generic Enablers (GE) for developing and providing customized IoT platform solutions.
The core of the FIWARE plattform that provides the functionality suited for most IoT-Applications consists of the GEs depict in image below. 
 
![Overview of the core generic enablers of fiware](docs/figures/Overview.png)

***Figure 1:*** *Overview of the FIWARE platform and its components (_source_: https://fiware-tutorials.readthedocs.io/en/latest/iot-over-mqtt/index.html)*


***Figure 2:*** *Overview of FIWARE platform and its components in the context of energy systems and deployed within a Docker-Swarm(_source_: https://fiware-tutorials.readthedocs.io/en/latest/iot-over-mqtt/index.html). (We are currently waiting for license agreements before publishing this image)*

The Orion context broker is the central component of the FIWARE stack that provides update, query, registration and subscription functionality via its API for managing the context information in the platform.
The data itself is stored in an underlying [MongoDB](https://www.mongodb.com/) database.
Orion only provides information of the current data content.
Hence, for storing time series data persistently, we deploy QuantumLeap, which subscribes a specified content and automatically stores updated data persistently in the connected high-performance [CrateDB](https://crate.io/) database.
Similar to Orion, QuantumLeap provides an API for managing the historic data stored in the database and, thus, adds time series functionality to the platform. 
Via the two APIs, data can be provided to any external service such as visualization, analysis or control algorithms.
For seamlessly connecting, managing and gathering data of IoT devices, FIWARE offers a set of IoT Agents that translate IoT specific protocols and message formats, such as Ultralight 2.0, JSON, etc. into the platform-internal NGSI format.
Devices located in the building energy system send and receive the data either directly via HTTP or via an additional Message Queueing and Telemetry Transport (MQTT) Broker.
Particularly, in this work, we use the open source broker implementation of [Eclipse Mosquitto](https://mosquitto.org/).
The latter also provides authentication and Transport Layer Security (TLS) encryption mechanisms.
Whenever a device is registered at an IoT Agent via its API, the agent automatically connects the device and the corresponding data with a specified content in Orion and stores the configuration in the MongoDB.
Hence, each time the device measurement is updated, the data of the corresponding content in Orion is instantaneously updated; conversely, if a command in a content is updated, it is directly sent to the device.
To exploit the hardware potential of cloud technology, we embed the platform into a container virtualization using images provided by FIWARE. 
Not only does this enable an easy setup and configuration procedure, but also the distribution on multiple hardware nodes via Docker-Swarm.

 For a closer look on FIWARE you will find a comprehensive tutorial here:
 https://fiware-tutorials.readthedocs.io/en/latest/index.html and the corresponding Git-Repositories: https://github.com/fiware/tutorials.Step-by-Step/ 
 These Git-Repos also provide a postman-collection that contain the basic CRUD queries for accessing the individual functionality. 

**Note:** The tutoial does not cover all the aspects, but it is a good
 starting point to get to know FIWARE a little better. 
 We will reference the detailed description where needed.
 Otherwise please check the FIWARE tour which also links to a deep dive documentation:
https://github.com/Fiware/catalogue/releases

Before you ask many many questions please try to read the docs first. 
We try to keep the collection of links up-to-date as long as we are actively working with the plattform.
<br>

**Try it out!<br>
Thanks for any comments on it!**

## Services in the stack file 
* Orion Context Broker (OCB)
* MongoDB
* Mongo-Express
* QuantumLeap
* CrateDB-Cluster (3 nodes) and necessary proxies
* IOT-Agent-Json
* MQTT-Broker (Mosquitto)

## How to start

1. Start with a fresh Ubuntu Linux 18.04 instance. While an used machine might work, there often are remnants that cause our setup to fail.

2. Install Docker-Swarm from https://www.docker.com. Usually we use the docker community edition for our purposes! Start a swarm with at least one worker. You may add additional workers as well, but in this GIT we do not show how to make fiware ready for high availability (HA). This will follow later.

      **Note:** In case you are not familiar with docker and docker-swarm we highly recommend to start here: https://docs.docker.com/. The get-started tutorial explains the basic functionalities in a very good way. Also, in case of issues with docker the page contains docker's full guidebook and documentation.

3. Create a docker overlay network named **fiware_backend** and **fiware_service** which allows the attachment of additional containers following this tutorial from [Docker](https://docs.docker.com/network/network-tutorial-overlay/).
This first network will be used for all FIWARE backend components.
The second one is meant for additional services you may want to add to your platform.

4. Clone this repository

        git clone https://github.com/N5GEH/n5geh.platform.git

5. You may adjust the docker-stack.yaml or *.conf to your preferences. But the
functionality will then be left to you. 
**_Please_** do not use the latest version of the available services because these may be still under development and possibly not be stable. 
Simply check the latest release for the last stable version [Link](https://github.com/FIWARE/catalogue/releases)!

    **Note:** Some changes (such as renaming services) may require the modification of the Makefile that comes along or other depending services!

6. Start the stack using:

        docker swarm init
        docker-compose up

    e.g    docker stack deploy -c docker-stack.yaml fiware

  **Note:** There are dependencies among the enablers. Within the startup procedure always start with the **MongoDB** and **Orion-Context-Broker (OCB)** in OCB. 
  These two act as the brain of the platform and manage all context.
  
7. Check if the stack and all corresponding service are up and running with:
    
        docker stack ls
        docker stack ps <nameOfStack>  

## Security

This tutorial does not cover authentication for fiware-services or Grafana.
Thus, a firewall is required to restrict access to fiware.
Within the RWTH and EBC networks, access from other networks is usually restricted and no further actions are needed.
However, if the Docker host is publicly accessible, make sure to
  1. use a firewall such as [UFW](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-with-ufw-on-ubuntu-18-04) and drop new incomming connections by default, and
  2. do not expose any ports from docker containers in a compose file or via `-p 1234:1234`. Without further modifications, these forwardings __bypass the local firewall__. Note, that in Swarm Mode, even ports exposed as `127.0.0.1:80:80` are [globally accessible](https://github.com/moby/moby/issues/32299#issuecomment-290978794).

Have a look at [Keyrock](https://fiware-idm.readthedocs.io/en/latest/) for securing fiware services.

## How to cite

We also used this platform setup in the following publications:

T. Storek, J. Lohmöller, A. Kümpel, M. Baranski & D. Müller (2019). Application of the open-source cloud platform FIWARE for future building energy management systems. Journal of Physics: Conference Series, 1343, 12063. https://doi.org/10.1088/1742-6596/1343/1/012063
