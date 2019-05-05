https://fiware-iotagent-ul.readthedocs.io/en/latest/installationguide/index.html#installation-administration-guide


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
        'http://<yourHostAddress>:4061/version'

the response should look similar to the this:

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
    However, for the building domain you might include the information provived above. A small example will follow shortly.
