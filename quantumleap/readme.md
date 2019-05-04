# QuantumLeap for handling timeseries data in FIWARE

**Note:** Before you start with the QuantumLeap make sure that the context-broker, mongoDB and crateDB are up and running!

## Introduction and general information

QuantumLeap is a generic enabler which is used to persist context data into a highperformance database as CrateDB. For the future it may also support e.g. InfluxDB. But it is still under incubation which is why we, for now, only recommend it together with CrateDB.

## How to start:

1. Go into the orion subdirectory of your cloned version of the git and copy the docker-compose.yaml.EXAMPLE and possibly further configuration files

        cp docker-compose.yaml.EXAMPLE docker-compose.yaml

2. You may the docker-compose.yaml to you preferences e.g. you need to
adjust the placement of the container.

      **Note:** Some changes may require the modification of Makefile that comes
      along or other depending services!

3. Start the service either using the commands provided in the Makefile
        make deploy

      or directly with docker command

        docker stack deploy -c docker-compose.yaml fiware
4. Check if the service is up and running by making an HTTP request to the exposed port:

        curl -X GET \
        'http://<yourHostAddress>:/v2/version'

the response should look similar to the this:

        {
          "quantumleap": {
            "version": "1.12.0-next",

          }
        }

5. For handling your first timeseries data we recommend the Step-by-Step Tutorial:
https://fiware-tutorials.readthedocs.io/en/latest/time-series-data/index.html.
