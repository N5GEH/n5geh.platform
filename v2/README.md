# FIWARE Platform Setup for NGSI-v2


## Single computer setup:


**Note:** Steps 1, 2 and the crate preparation setup are conventiently put into a shell script under /scripts/installation_setup.sh. To run this, execute the following:

```shell
sudo git clone https://github.com/N5GEH/n5geh.platform.git
sudo chmod +x n5geh.platform/scripts/installation_setup.sh
sudo ./n5geh.platform/scripts/installation_setup.sh
```
If the script ran successfully, reboot your system with

    sudo reboot
and continue with step 3 afterwards. 

**Note**: If you use the WSL setup the max map count will still be reset after a Windows reboot. So the workaround from the section above is still needed.

1. Install docker and docker compose from https://www.docker.com. Usually, the docker community edition is sufficient for our purposes. 


      **Note:** In case you are not familiar with docker and docker compose we highly recommend to start here: https://docs.docker.com/. The get-started tutorial explains the basic functionalities in a very good way. In case of issues with docker the page contains docker's full guidebook and documentation.

2. Clone this repository:

       git clone https://github.com/N5GEH/n5geh.platform.git

3. You may adjust the [compose file](docker-compose.yml), [environment file](.env) or [mosquitto configuration file](/general/mosquitto.conf) according to your preferences. Our provided file already provides a simple setup with all functionalities.


4. Change the working directory and start the platform using the [environment file](.env) file for configuration:

        cd n5geh.platform/v2
        docker compose --env-file .env up -d
    
    For docker compose V1 use 
    
        docker-compose up -d --env-file=.env


5. After a while, the platform should be up and running. You can check this by typing:

        docker ps

6. After a few minutes, portainer should be accessible via http://yourIP:9000. Enter a valid admin password and confirm you just want to use your local environment. Click on your local environment and get an overview about your containers by clicking on "Stack" or "Stacks".

7. Enjoy testing and leave your comments.

   **Note:** In case are done using the platform or simply want to start all over again, all containers can be stopped and non-persistent volumes will be removed by typing:
        
        docker compose down
		


## Multi node setup:

Deploying your services on a multi node setup makes sense if you, e. g., want to increase the availability of, or increase the available ressources for your services. Here, we give a quick tutorial on how to deploy the setup on a three node setup with distributed services, including the databases, on a docker swarm cluster for development purposes - **no security features are applied**, so make sure your system is not exposed to unauthorized people.

As **prerequisite**, you need to have three nodes (that can be virtual machines or different instances of your WSL2) that can communicate with each other. In our setup the nodes are named "test-1", "test-2", and "test-3". If your nodes have different names, you need to change the [stack file](docker-stack.yml) or [environment file](.env) (lines 3-5 & 121) accordingly (we highly recommend the deployment via portainer using the environment file. Directly deploying via docker stack won't read the values from the environment file but take the defaults from the stack file!). The same applies whether you want to store your data in docker volumes or on a designated path on your nodes.

* Steps 1-3 are equal for both ways and need to be executed. Either jump to step 4 or step 6 depending if you wish or wish not to use portainer.

* Steps 4-5 show the use without portainer if you apply changes directly within the [stack file](docker-stack.yml).

* Steps 6-12 show the use with portainer if you make changes within the [environment file](.env).

1. Install docker on each of the three nodes following steps 1 & 2 or use the provided [installation script](/scripts/installation_setup.sh) both from the single computer setup.

2. Next, you need to create a docker swarm and add all three nodes to it. On one of your nodes, e. g. test-1, you need to initiate your swarm by typing:

        docker swarm init
   Afterwards, the other two nodes, e. g. test-2 and test-3, need to join this swarm. On the node where the swarm was initiated, a command should be printed in the console with that other nodes can join this particular swarm as worker nodes. It should look similar to:
   
        docker swarm join --token <SomeToken> <IP:Port>
   In case you want the other nodes to join as manager nodes, which usually makes sense for smaller setups, type:

        docker stack join-token manager
   and the corresponding command will be printed in the console. Simply copy the preferred command and execute it on the two remaining nodes. In case the IP is not propagated correctly, you might need to use *docker swarm init --advertise-addr*. For further information about the different types of swarm nodes, we kindly refer to the [docker documentation](https://docs.docker.com/engine/swarm/manage-nodes/). 
   Once the nodes are part of one cluster, you can check their availability using:

        docker node ls
3. If the connection between the nodes failed we recommend to check your firewall and network settings. Once the swarm is successfully formed you can create an overlay network in which all containers will be put in: 
        
        docker network create fiware_backend -d overlay

4. After that, run the following command on the manager node to start your stack:

        docker stack deploy -c docker-stack.yml <NameOfYourStack>
   where the NameOfYourStack is a custom name you can give your stack, e. g. "fiware". You can start different stacks using different names in order to be able to manage your stacks individually.

5. In case you want to terminate your swarm, simply type:
   
        docker stack rm <NameOfYourStack>
   
6. Start portainer using:
        
        docker stack deploy -c ../general/portainer.yml portainer

    After a few minutes, portainer should be accessible via http://yourIP:9000. Enter a valid admin password and click on the environment that is automatically created, it should be called "primary". You will see an overview of your current cluster including all deployed stacks and services, created volumes and downloaded images. 
    Remember: The version of portainer can only be adjusted in the stack file itself since deploying via docker stack does not support environment files.

7. Create the configs using the portainer GUI - they can still be created using docker via CLI though. Click on "Configs" (1) and then "Add config" (2):

    ![Create config](/docs/figures/Portainer_configs_add.png)

8. Add a config called "mongo-setup" (1), copy the content of the [setup.sh](/scripts/setup.sh) (2) and save it (3). Repeat this with the [mosquitto.conf](/general/mosquitto.conf). 
   
    ![Enter config information](/docs/figures/Portainer_configs_enter_data.png)

9.  You should see two configs now:

    ![Finished configs](/docs/figures/Portainer_configs_finished.png)

10. Create the stack by clicking on "Stacks" (1) and then "Add Stack" (2):

    ![Create stack](/docs/figures/Portainer_stack_add.png)

11. Enter the stack name "fiware" (1), copy the content of the [docker-stack.yml](docker-stack.yml) in the Web editor and comment / uncomment the portainer sections for the configs (2). This is necessay because the configs are created outside of the stack creation itself. Click on "Advanced mode" (3) to fill in the environment information.

    ![Enter stack information](/docs/figures/Portainer_stack_enter_data.png)

12. Copy the content of the [.env](.env) in the editor that has just expanded. Finally, scroll to the bottom and deploy the stack.

    ![Enter env information](/docs/figures/Portainer_env_enter_data.png)


    After a few minutes, the stack should be deployed. You can check the status of your stack by clicking on "Stacks" in the sidebar and click on the stack named "fiware".

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
