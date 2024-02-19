# FIWARE Platform Setup for NGSI-LD


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

        cd n5geh.platform/ld
        docker compose --env-file .env up -d
    
    For docker compose V1 use 
    
        docker-compose up -d --env-file=.env


5. After a while, the platform should be up and running. You can check this by typing:

        docker ps

6. After a few minutes, portainer should be accessible via http://yourIP:9000. Enter a valid admin password and confirm you just want to use your local environment. Click on your local environment and get an overview about your containers by clicking on "Stack" or "Stacks".

7. All LD context brokers come with the NGSI-LD core context that holds all the NGSI-LD base information to make the context brokers work. You can add your own context files to your setup by adding them to the folder [context-files](../general/context-files/). A sample context file for mapping context information from the Brick Schema to our data models is already provided and loaded in the IoT Agent. Upon creation of context information to orion, you have to provide a context file, as referred to in the [LD tutorials](https://github.com/FIWARE/tutorials.NGSI-LD). The provided links to the context file need to be accessible for the context broker. Therefore, in our case, you can use "http://context-server:8050/context.jsonld" for creating entities, refer to your own context files located somewhere else or refer to the [smart data models from FIWARE](https://smartdatamodels.org/).

8. Enjoy testing and leave your comments.

   **Note:** In case are done using the platform or simply want to start all over again, all containers can be stopped and non-persistent volumes will be removed by typing:
        
        docker compose down
		

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
