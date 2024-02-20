# FIWARE Platform Setup

Welcome to the quick setup of the FIWARE core on a Unix OS using docker! 
With some minor changes to the according files it might also work on a Windows OS but this is not tested so far! There are possibilities to run a sandbox with a Unix OS for Windows OS.

**Note:** We mostly sum up parts from the official documentation written and published by FIWARE for that we do not claim ownership. 
Based on our experiences from project phase 1, we provide useful information and configuration files for a basic platform setup that runs out of the box. 
Furthermore, you might have a look at the SmartSDK project (https://www.smartsdk.eu/) which can be found on github:
https://github.com/smartsdk/smartsdk-recipes

## Introduction

This repository contains example docker yml files for the easy deployment of a FIWARE-based plattform on a single computer setup via docker-compose and a multi node setup via docker stack (also referred to as docker swarm). The single node setup via docker-compose is supposed to function as a quick development setup only. It does not contain any security features! The multi node setup via docker stack is meant to be deployed on multiple nodes (but can be deployed on a single node as well) and pre-configured as a pure development setup as well. Nevertheless, we provide additional configuration suggestions and information about how a production-ready setup could look like.

### What is FIWARE

"FIWARE is a curated framework of open source platform components to
 accelerate the development of Smart Solutions." 
 Beside the fact that FIWARE is freely distributed, it comes along with the benefits of a large community and makes use of advanced components including high performance databases and a sophisticated set of Representational State Transfer (REST) application programming interfaces (API) using the standardized Next Generation Service Interface (NGSI) format. Latter is also the formal standard for context information management systems in smart cities.
 For more general information about FIWARE, why to use it and its core concept please check https://www.fiware.org/developers/ <br>

At the moment, the FIWARE catalogue contains about 30 interoperable software modules, so-called Generic Enablers (GE) for developing and providing customized IoT platform solutions.

The core of the FIWARE platform used in the N5GEH project provides functionalities suited for most IoT-Applications. An overview of the platform components and their communication is depicted in the image below. Since FIWARE uses standardized interfaces, components can be exchanged according to your needs. 

 
![Overview of the core generic enablers of fiware](/docs/figures/Fiware.png)

***Figure 1:*** *Overview of the FIWARE platform and its components. Blue components are FIWARE GEs, grey components are other open source non-FIWARE components and the yellow components are not part of the platform and thus not part of the yml files. The communication between the applications and the corresponding default ports are indicated by by the :"port number" and the arrows.*


The Orion context broker is the central component of our platform that provides update, query, registration and subscription functionalities via its API for managing the context information (entities and attributes) stored in the platform.
Orion is stateless and thus does not ofer any storage itself. 
It stores the data in an underlying [MongoDB](https://www.mongodb.com/) database.
MongoDB only stores the context information as well as the current values of the attributes.

In order to store time series data persistently, the GE QuantumLeap is deployed. 
Via the subscription mechanism, Orion can notify QuantumLeap whenever it receives updates on certain content. QuantumLeap then stores the data in the high-performance database [CrateDB](https://crate.io/).
Similar to Orion, QuantumLeap provides an API for querying and managing the historic data stored in the database.
Via the two APIs of Orion and QuantumLeap, data can be provided to any external service such as visualization, analysis or control algorithms.

Since most devices do not support the platform internal NGSI format, FIWARE offers a set of IoT Agents that translate IoT specific protocols and message formats, such as Ultralight 2.0, JSON, etc. into NGSI format.
For example, devices located in a building energy system can send and receive data either directly via HTTP or via an additional Message Queueing and Telemetry Transport (MQTT) Broker.
Particularly, in this work, we use the open source broker implementation of [Eclipse Mosquitto](https://mosquitto.org/). 
Mosquitto supports Transport Layer Security (TLS) and basic authentication and authorization features.
In this work, we used an adapted version of mosquitto in order to realize communication between the MQTT broker and a central Identity and Access Management (IDAM) using openID-connect and OAUth 2.0. 

To exploit the potentials of cloud technology, we deploy the platform via the virtualization technology docker. 
All images are open source and available on docker hub.
Using the virtualization technology docker, the setup is not bound to the host operating system since each container comes with its own running environment. Furthermore, the setup and configuration procedures are simplified by using pre-configured yml files. Last, docker swarm allows the distribution of platform components on multiple hardware nodes.

 For a closer look on FIWARE, please, find comprehensive tutorials here:
 https://fiware-tutorials.readthedocs.io/en/latest/index.html and the corresponding Git-Repositories: https://github.com/fiware/tutorials.Step-by-Step/ 
 These Git-Repos also provide a postman-collection that contain the basic CRUD queries for accessing the individual functionality. 

**Note:** We strongly encourage to work yourself through the tutorials since they provide sufficient knowledge for the proper use of platform components. For further informatoin, please, refer to:
https://github.com/Fiware/catalogue/releases

<br>

**Try it out!<br>
Thanks for any comments on it!**

# Let's start setting up the platform
## Prerequisites 

### The Host System

We recommend to start with a fresh Ubuntu Linux 20.04 instance. Used machines might work as well but there could be remnants that cause our setup to fail. 

In case you're already working on a Linux based OS, continue with the section "Further configuration for CrateDB". In case you want the platform to run on your Windows OS, we recommend using a Linux subsystem, WSL. The installation is described in the following section.

***
### WSL installation
There are two ways to accomplish the installation of the subsystem in Windows. 

1.  Open Control Panel -> Programs -> Turn Windows features on or off and activate the checkbox for Windows subsystem for Linux. Then restart your computer.

2. Run PowerShell as an administrator and enter the following command:

        dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
        
   Afterwards, the default version has to be set to wsl 2. Run PowerShell as administrator and type in the following command to enable virtual machine platform before rebooting your system: 

        dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
        
   Download and install the update package for the Linux kernel at https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi for an x64 computer or search for the correct update version in other cases. Set wsl 2 as the default version by entering the command below in PowerShell:

        wsl --set-default-version 2
        
   Now you can download the latest Ubuntu application from Microsoft Store and register with UNIX. 
   
   For further information about installation/update of WSL please refer to the [documentation of Microsoft](https://docs.microsoft.com/en-us/windows/wsl/install)
***


### Further configuration for CrateDB
CrateDB requires a higher number of memory map areas.

- If you use a **Linux based OS** type 
        
        sudo sysctl -w vm.max_map_count=262144

  Confirm the changes by calling
        
        sysctl vm.max_map_count 

- If you installed **WSL on your Windows computer** you can use the same command in your Linux environment. Unfortunately, this command has to be executed after every reboot of windows system, which is a known issue #4232. We provide one possible workaround:

   Create a `.wslconfig` file under “C:\Users\\<Username>”* with following contents:

        [wsl2]
        kernelCommandLine = "sysctl.vm.max_map_count=262144"

  \* For those who use docker desktop to manage their FIWARE platform, they may have to create the `.wslconfig` file under "C:\Users\\<Username>\AppData\Local\Docker\wsl"

   **Note:** an easy way to create such file is to execute 
        
        New-Item -path .wslconfig

   in Powershell, and then write the contents into it.
  Reboot your windows system and confirm the changes by calling
        
        sysctl vm.max_map_count 
  in your Linux subsystem.

***

### Setup adjustments to your needs:
We provide a general development setup and try to keep most of the information generic. Most of the configuration parameters of the setup can be changed either in the `.yml` files directly, which we do not recommend. We gathered most of the configuration parameters in `.env` files so the information is well-arranged and can be changed in one place. 
When using the single computer setup, the `.env` files can be read using a specifig flag. Unfortunately, this does not work for the multi node setup. Portainer is a tool that can help managing your cluster, see following section. When using portainer,  the `.env` files can be used even in a multi node setup. 

In general, we suggest using portainer in any case due to its nice graphical interface that assists to manage your containerized environments. 

**Note:** Since portainer has full access to your whole cluster, make sure it it only accessible by authorized people and secured with all necessary means, e. g. encryption, encapsuled networks & vpn, IP-whitelisting.

In the following, "yourIP" should be replaced with the IP address of your VM or "localhost" if you use WSL. If you use the multi node setup you can use either (accessible) IP of any node in your cluster. 

***
### Portainer setup:
Portainer is a tool that helps you to manage your container environment. It comes with a graphical, web-based user interface and - depending on how you deploy it - a interface to the docker daemon so you can start, restart and stop containers, read container logs and even start completely new stacks.
Further information can be found [here](https://docs.portainer.io). Make sure you fullfil the [system requirements](https://docs.portainer.io/start/install-ce). 

***
## Single computer setup:


For the single computer use, we currently provide setups for NGSI-v2 and NGSI-LD. For the next steps, please, refer to the corresponding setup.
Further information on the different data models and the different APIs can be found in the corresponding tutorials for [NGSI-v2](https://github.com/FIWARE/tutorials.NGSI-v2) and [NGSI-LD](https://github.com/FIWARE/tutorials.NGSI-LD).

- [NGSI-v2 setup](/v2/README.md#single-computer-setup)
- [NGSI-LD setup](/ld/README.md)


## Multi node setup:

For a multi computer use, we currently provide a setup for NGSI-v2.

- [NGSI-v2 setup](/v2/README.md#multi-node-setup)
  

## Get Grafana running (for all setups)

After successfully launching the platform, CrateDB needs to be linked to Grafana for using its time series analytics tool/for data visualisation. Since Grafana is listening on port 3000, it can be accessed at http://yourIP:3000/login. In order to use the application, a login is required first. You can do this using your personal account or a standard Grafana administrator user who has full permissions. The default login details are:

        username: admin
        passwort: admin

After logging in, visit: http://yourIP:3000/datasources to connect to your database and select the type PostgreSQL. For further configuration, the following data should be taken over.

**Note:** Currently, there might be no data in your CrateDB yet. In order to put data into your database, either follow our tutorial [from sensor to application](https://github.com/N5GEH/n5geh.tutorials.from_sensor_to_application) or FIWARE's [time series tutorial](https://github.com/FIWARE/tutorials.Time-Series-Data/):

        name: CrateDB
        host: crate:5432
        database: mtopeniot
        user: crate
        TLS/SSL mode: disable

The remaining parameters can be adopted. <br /> To verify that the connection was successful, just press "save & test".

Create a new dashboard in order to visualize time series data. Grafana uses SQL syntax, so the following statements should be familiar to you if you know a little bit about SQL.
In the following picture, the example configuration to retrieve temperature data from a temperature sensor is shown. 

![Overview of the core generic enablers of fiware](/docs/figures/Grafana.png)

In this example, the data is stored under the fiware-service "test" and the device was created with the entity type "sensor". This leads to the table name *"mttest"."etsensor"*. The timestamp is saved in the variable *time_index* and the temperature in the variable *temperature*. Adapt your settings according to your data and enjoy.

***
## Security

This tutorial does not cover authentication for databases, fiware services or Grafana. 
This setup should run behind a firewall and no ports on your host system should be exposed to the outside world before you apply security measures.
A suggestion of latter are shown in other tutorials, like [how to route and secure your applications](https://github.com/N5GEH/n5geh.tutorials.route_and_secure_applications) and [api protection](https://github.com/N5GEH/n5geh.tutorials.api-protection).
***

## References

We used this platform setup in the following publications:

S. Blechmann, I. Sowa, M. H. Schraven, R. Streblow, D. Müller & A. Monti. Open source platform application for smart building and smart grid controls. Automation in Construction 145 (2023), 104622. ISSN: 0926-5805. 
https://doi.org/10.1016/j.autcon.2022.104622

T. Storek, J. Lohmöller, A. Kümpel, M. Baranski & D. Müller (2019). Application of the open-source cloud platform FIWARE for future building energy management systems. Journal of Physics: Conference Series, 1343, 12063. https://doi.org/10.1088/1742-6596/1343/1/012063 

A. Kümpel, T. Storek, M. Barnski, M. Schumacher & D. Müller (2019) A cloud-based operation optimization of building energy systems using a hierarchical multi-agent control. Journal of Physics: Conference Series, 1343, 12053. https://doi.org/10.1088/1742-6596/1343/1/012053 


## License

This project is licensed under the MIT License - read the [LICENSE](LICENSE) file for details.

## Further project information

<a href="https://n5geh.de/"> <img alt="National 5G Energy Hub" 
src="https://raw.githubusercontent.com/N5GEH/n5geh.platform/master/docs/logos/n5geh-logo.png" height="100"></a>

## Acknowledgments

We gratefully acknowledge the financial support of the Federal Ministry <br /> 
for Economic Affairs and Climate Action (BMWK), promotional references 
03EN1030B and 03ET1561B.

<a href="https://www.bmwi.de/Navigation/EN/Home/home.html"> <img alt="BMWK" 
src="https://raw.githubusercontent.com/N5GEH/n5geh.platform/master/docs/logos/BMWK-logo_en.png" height="100"> </a>
