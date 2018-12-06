# Orion Context-Broker

**Note:** Before you start with the context-broker make sure that the mongoDB is up and running!

## Introduction and general information

![Overview of the core generic enablers of fiware](../docs/figures/orion.png)

Together with the mongodb the context-broker also known as Orion is the main core of the fiware plattform. It handles all data wihtin the plattform and is required for all activities in and around fiware. To retrieve data from this database, users can query API of the context-broker.

"Orion is a C++ implementation of the [NGSIv2 REST API](https://swagger.lab.fiware.org/?url=https://raw.githubusercontent.com/Fiware/specifications/master/OpenAPI/ngsiv2/ngsiv2-openapi.json#/)(Swagger Documentation) binding developed as a part of the FIWARE platform.

Orion Context-Broker allows you to manage the entire lifecycle of context information including updates, queries, registrations and subscriptions. It is an NGSIv2 server implementation to manage context information and its availability. Using the Orion Context Broker, you are able to create context elements and manage them through updates and queries. In addition, you can subscribe to context information so when some condition occurs (e.g. the context elements have changed) you receive a notification. These usage scenarios and the Orion Context Broker features are described in this documentation."

The detailed documentation and the user manual can be found [here](https://fiware-orion.readthedocs.io/en/latest/index.html). It provides all necessary information about the API and the whole functionality of the context-broker. Here especially the understanding of the ability for multi-tenancy is very important for large destributed IoT-Applications.

Furthermore, if you are interested in the code itself you'll find it on GitHub:
https://github.com/telefonicaid/fiware-orion

## Newest developments of the API:
Currently, the developers extent the orion API by NGSI-LD defined by the ETSO ISG CIM group. "This Cross-domain Context Information Management API allows to provide, consume and subscribe to context information in multiple scenarios and involving multiple stakeholders."

For quick overview about the API we recommend the check: https://app.swaggerhub.com/apis/jmcanterafonseca/NGSI-LD_Full/0.1.
Neverthelesse, the concept of linked-data should be fully understood beforehand because it is the main idea how to efficiently network multiple devices and add context information to them please check the additional information provided below. From our perspective within in the energy sector the concept of networking should follow the Smart Appliances REFerence (SAREF) ontology and its domoan specific extensions. The specification can be found [here](https://www.etsi.org/standards-search#page=1&search=SAREF&title=1&etsiNumber=1&content=1&version=0&onApproval=1&published=1&historical=1&startDate=1988-01-15&endDate=2018-12-06&harmonized=0&keyword=&TB=&stdType=&frequency=&mandate=&collection=&sort=3).

#### Additional background information:
- Find out more about ETSI - European Telecommunications Standards Institute: http://www.etsi.org/
- Find out more about Context Information Management: https://portal.etsi.org/tb.aspx?tbid=854&SubTB=854
- Find out more about specifications of NGSI-LD API - API defined by the ETSI ISG CIM [PDF](https://www.etsi.org/deliver/etsi_gs/CIM/001_099/004/01.01.01_60/gs_CIM004v010101p.pdf)
- Find out more about the concept of JSON-LD visit: https://json-ld.org/

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
        'http://<yourHostAddress>:1026/version'

the response should lokk similar to the this:

        {
            "orion": {
                "version": "1.12.0-next",
                "uptime": "0 d, 0 h, 3 m, 21 s",
                "git_hash": "e2ff1a8d9515ade24cf8d4b90d27af7a616c7725",
                "compile_time": "Wed Apr 4 19:08:02 UTC 2018",
                "compiled_by": "root",
                "compiled_in": "2f4a69bdc191",
                "release_date": "Wed Apr 4 19:08:02 UTC 2018",
                "doc": "https://fiware-orion.readthedocs.org/en/master/"
            }
        }

5. For creating your first context-data we recommend the Step-by-Step Tutorial:
    https://fiware-tutorials.readthedocs.io/en/latest/getting-started/index.html.
    However, for the building domain you might includ the information provived above. A small example will follow shortly.
