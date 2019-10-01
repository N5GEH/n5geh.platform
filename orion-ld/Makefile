SHELL = /bin/bash

deploy:
	docker stack deploy -c docker-compose.yaml fiware

rm:
	docker service rm fiware_orion

ps:
	docker stack ps fiware

logs:
	docker service logs fiware_orion -f

exec:
	docker exec -it $(shell docker ps -f 'name=fiware_orion.1' -q) bash

up:
	docker-compose -p fiware up -d

down:
	docker-compose -p fiware down

