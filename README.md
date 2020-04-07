# FIWARE-Stack Setup

Welcome to the quick setup of the FIWARE core on a Unix OS! 
Nevertheless, with some minor changes in the docker-compose files it might also work on a Windows OS but this is not tested so far! 
Anyway, you cannot make use of the Makefiles directly using a Windows OS and need to type in the docker commands directly!

**Note:** We mostly link, sum up and also copy official documentation written and published by the FIWARE (Future Internet Software) foundation for that we do not claim ownership.

## Introduction

This repository contains example docker-stack.yamls and for the easy deployment of core elements aka *Generic Enablers* of the the FIWARE plattform in a docker swarm setup.
"FIWARE is a curated framework of open source platform components to
 accelerate the development of Smart Solutions." 
 Beside the fact that FIWARE is freely distributed, it comes along with the benefits of a large community and offers a set of advanced components including a high performance database engine and a sophisticated set of Representational State Transfer (REST) application programming interfaces (API) using the standardized Next Generation Service Interface (NGSI) format, which is also the formal standard for context information management systems in smart cities.
 For more general information about FIWARE, why to use it and its core concept please check https://www.fiware.org/developers/ <br>

At the moment, the FIWARE catalogue contains about 30 interoperable software modules, so-called Generic Enablers (GE) for developing and providing customized IoT platform solutions.
The core of the FIWARE plattform that provides the functionality suited for most IoT-Applications consists of the GEs depict in image below. 
 
![Overview of the core generic enablers of fiware](docs/figures/Overview.png)

***Figure 1:*** *Overview of FIWARE platform and its components (_source_: https://fiware-tutorials.readthedocs.io/en/latest/iot-over-mqtt/index.html)*

The Orion context broker is the central component of the FIWARE stack that provides update, query, registration and subscription functionality via its API for managing the context information in the platform.
The data itself is stored in an underlying [MongoDB](https://www.mongodb.com/) database.
Orion only provides information of the current data content.
Hence, for storing time series data persistently, we deploy QuantumLeap, which subscribes a specified content and automatically stores updated data persistently in the connected high-performance [CrateDB](https://crate.io/) database.
Similar to Orion, QuantumLeap provides an API for managing the historic data stored in the database and, thus, adds time series functionality to the platform. 
Via the two APIs, data can be provided to any external service such as visualization, analysis or control algorithms.
For seamlessly connecting, managing and gathering data of IoT devices, FIWARE offers a set of IoT Agents that translate IoT specific protocols and message formats, such as Ultralight 2.0, JSON, etc. into the platform-internal NGSI format.
Devices located in the building energy system send and receive the data either directly via HTTP or via an additional Message Queueing and Telemetry Transport (MQTT) Broker.
Particularly, in this paper, we use the open source broker implementation of [Eclipse Mosquitto](https://mosquitto.org/).
The latter also provides authentication and Transport Layer Security (TLS) encryption mechanisms.
Whenever a device is registered at an IoT Agent via its API, the agent automatically connects the device and the corresponding data with a specified content in Orion and stores the configuration in the MongoDB.
Hence, each time the device measurement is updated, the data of the corresponding content in Orion is instantaneously updated; conversely, if a command in a content is updated, it is directly sent to the device.

This Git gives only a short overview of the functionality it also provides a postman-collection that contains the basic CRUD queries for accessing the individual functionality. 
 For a closer look on FIWARE you will find a comprehensive tutorial here:
 https://fiware-tutorials.readthedocs.io/en/latest/index.html

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

## Structure of this repository

We grouped and structured the repository by means of functionality of the introduced GEs.
- For setting up the core component, the Orion context broker, the underlying mongodb and mongo-express you will the a complete stack-file as well as individual files in [ocb](ocb)
- Everything for connecting IoT-Devices to the platform is collected in [iota](iota) (_short for_: IoT-Architecture).
- For storing and retrieving time series data you will find stack-files for quantumleap, cratedb,
and grafana on [timeseries](timeseries)
- Additionally you will find the NGSI-Proxy for retrieving data from foreign APIs

## How to start

0. Start with a fresh Ubuntu Linux 18.04 instance. While an used machine might work, there often are remnants that cause our setup to fail.

1. Install Docker-Swarm from https://www.docker.com. Usually we use the docker community edition for our purposes! Start a swarm with at least one worker. You may add additional workers as well, but in this GIT we do not show how to make fiware ready for high availability (HA). This will follow later.

  **Note:** In case you are not familiar with docker and docker-swarm we highly recommend to start here: https://docs.docker.com/. The get-started tutorial explains the basic functionalities in a very good way. Also, in case of issues with docker the page contains docker's full guidebook and documentation.

2. Create a docker overlay network named **fiware_backend** and **fiware_service** which allows the attachment of additional containers following this tutorial from [Docker](https://docs.docker.com/network/network-tutorial-overlay/).
This first network will be used for all FIWARE backend components.
The second one is meant for additional services you may want to add to your platform.

3. Clone this repository

        git clone https://git.rwth-aachen.de/EBC/Team_BA/fiware/fiware-example-setup.git

4. Go into each subdirectory and copy the docker-compose.yaml.EXAMPLE and possibly further configuration files

        cp <ServiceName>.conf.EXAMPLE <ServiceName>.conf

        cp docker-compose.yaml.EXAMPLE docker-compose.yaml

5. You may adjust the docker-compose.yaml or *.conf to your preferences. But the
functionality will then be left to you. **_Please_** do not use the latest version of
the available services because these may be still under development and
eventually not be stable. Simply check the latest release for the last stable version [Link](https://github.com/FIWARE/catalogue/releases)!

**Note:** Some changes (such as renaming services) may require the modification of the Makefile that comes along or other depending services!

6. Start each service either using the commands provided in the Makefile or with the command
        "make deploy".
Note, that this is only a shortcut for executing
        docker stack deploy -c docker-compose.yaml fiware

  **Note:** There are dependencies among the enablers. Within the startup procedure always start with the **mongoDB** first followed by the **Context-Broker**. These two act as the brain of the platform and manage all context.

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

Storek, T., Lohmöller, J., Kümpel, A., Baranski, M. & Müller, D. (2019). Application of the open-source cloud platform FIWARE for future building energy management systems. Journal of Physics: Conference Series, 1343, 12063. 


