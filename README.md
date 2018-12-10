# FIWARE-Core Setup

Welcome to the quick setup of the fiware core on a Unix OS! Nevertheless, with some minor changes in the docker-compose files it might also work on a Windows OS but this is not tested so far! Anyway, you can not make use of the Makefiles directly and need to type in the docker commands directly!

**Note:** We mostly link, sum up and also copy official documentaion written and published by the fiware foundation forthat we do not claim ownership.

## Introduction

This repository contains example docker-compose-files and for the easy
deployment of core elements aka *Generic Enablers* of the the fiware plattform in a docker swarm. "FIWARE is a curated framework of open source platform components to accelerate the development of Smart Solutions." For more general information about fiware please check https://www.fiware.org/ <br>

The core of the fiware plattform that provide the functionality suited for most
IoT-Applications consists of the elements aka *Generic Enablers* depict in image below. For each of the components you find an description of its setup and basic funtionality in the individual subdirectories.

![Overview of the core generic enablers of fiware](docs/figures/Overview.png)

This Git gives only a short overview of the functionalities it also provides
a postman-collection that contains the basic CRUD queries for accessing the individual functionalities. For a closer look on fiware you will find a comprehensive tutorial here:
https://fiware-tutorials.readthedocs.io/en/latest/index.html

**Note:** The tutoial does not cover all the aspects, but it is a good starting point to get to know fiware a little better. We will reference the detailed description and GITs.

Before you ask many many questions please try to read the docs first. We try to keep the collection of links up-to-date as long as we are actively working with the plattform.
<br>

**Try it out!<br>
Thanks for any comments on it!**

## How to start


1. Install Docker-Swarm from https://www.docker.com. Usually we use the docker community edition for our purposes! Start a swarm with at least one worker. You may add additional workers as well, but in this GIT we do not show how to make fiware ready for true high availability (HA). This will follow later.

  **Note:** In case you are not familiar with docker and docker-swarm we highly recommend to start here: https://docs.docker.com/. The get-started tutorial explains the basic functionalities in a very good way. Also, in case of issues with docker the page contains docker's full guidebook and documentation.

2. Clone this repository

        git clone https://git.rwth-aachen.de/EBC/Team_BA/fiware/fiware-core.git fiware-core

3. Go into each subdirectory and copy the docker-compose.yaml.EXAMPLE and possibly further configuration files

        cp <ServiceName>.conf.EXAMPLE <ServiceName>.conf

        cp docker-compose.yaml.EXAMPLE docker-compose.yaml

4. You may the docker-compose.yaml or *.conf to you preferences. But the functionality will then left to you.

  **Note:** Some changes may require the modification of Makefile that comes along or other depending services!

5. Start each service either using the commands provided in the Makefile
        make deploy
or directly with docker command
        docker stack deploy -c docker-compose.yaml fiware

  **Note:** There are dependencies among the enablers. Within the startup procedure always start with the **mongoDB** first followed by the **Context-Broker**. These two act as the brain of the plattform and manage all context.
