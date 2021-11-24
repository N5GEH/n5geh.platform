https://fiware-iotagent-ul.readthedocs.io/en/latest/installationguide/index.html#installation-administration-guide


## How to start:

1. Go into the orion subdirectory of your cloned version of the git and copy the docker-compose.yaml.EXAMPLE and possibly further configuration files

        cp docker-stack.yaml.EXAMPLE docker-stack.yaml

2. You may the docker-stack.yaml to your preferences e.g. you need to
adjust the placement of the container.

      **Note:** Some changes may require the modification of the Makefile that comes
      along or other depending services!

3. Start the service either using the commands provided in the Makefile

        make deploy

      or directly with docker command

        docker stack deploy -c docker-stack.yaml fiware
4. Check if the service is up and running by making an HTTP request to the exposed port:

        curl -X GET \
        'http://<yourHostAddress>:4061/iot/about'

   The response should look similar to the this:

        {"libVersion":"2.8.0-next","port":"4061","baseRoot":"/","version":"1.8.0-next"}

5. For creating your first context-data we recommend following the Step-by-Step Tutorial:
    https://fiware-tutorials.readthedocs.io/en/latest/getting-started/index.html.
    However, for the building domain you might include the information provided above. 

