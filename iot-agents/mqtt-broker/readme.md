# MQTT with FIWARE IoT Agents

MQTT(Message Queuing Telemetry Transport) is a widely used message protocol in IoT applications for realizing a machine-to-machine (M2M) communication. It has its origins in SCADA systems and therefore from the designed point a good starting point for most IoT purposes. Further instruction would go beyond of this tutorial.

Within the context of FIWARE MQTT changes the communication structure of devices according to the overview below:

![Comparism between transport over HTTP and MQTT (_source_: https://fiware-tutorials.readthedocs.io/en/latest/iot-over-mqtt/index.html)](../../docs/figures/HTTP-MQTT.JPG)
***Figure 1:*** *Comparism between transport over HTTP and MQTT (_source_: https://fiware-tutorials.readthedocs.io/en/latest/iot-over-mqtt/index.html)*

Consequently, the overall architecture changes to the following:

![Comparism between transport over HTTP and MQTT (_source_: https://fiware-tutorials.readthedocs.io/en/latest/iot-over-mqtt/index.html)](../../docs/figures/mqtt.png)
***Figure 2:*** *FIWARE platform with connected MQTT-Broker (_source_: https://fiware-tutorials.readthedocs.io/en/latest/iot-over-mqtt/index.html)*

## How to start

WARNING: Please be aware of the fact that we do not cover security aspects here.

1. Go into the mqtt-broker subdirectory of your cloned version of the git and copy the docker-compose.yaml.EXAMPLE and the mosquitto configuration file and rename them to:

        cp docker-compose.yaml.EXAMPLE docker-compose.yaml

        cp mosquitto.conf.EXAMPLE to mosquitto.conf

2. You may adjust the docker-compose.yaml to your preferences e.g. you need to adjust the placement of the container to your gateway machine.

      **Note:** Some changes may require the modification of Makefile that comes along or other depending services!

3. Start the service either using the commands provided in the Makefile
        make deploy

      Note, that this is just a shortcut for

        docker stack deploy -c docker-compose.yaml fiware

4. For a quick overview for how to use the broker we recommend to check: https://fiware-tutorials.readthedocs.io/en/latest/iot-over-mqtt/index.html
