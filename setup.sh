#!/bin/bash

#MONGODB1=`ping -c 1 mongo1 | head -1  | cut -d "(" -f 2 | cut -d ")" -f 1`
#MONGODB2=`ping -c 1 mongo2 | head -1  | cut -d "(" -f 2 | cut -d ")" -f 1`
#MONGODB3=`ping -c 1 mongo3 | head -1  | cut -d "(" -f 2 | cut -d ")" -f 1`

MONGODB1=mongodb1
MONGODB2=mongodb2
MONGODB3=mongodb3

echo "**********************************************" ${MONGODB1}
echo "Waiting for startup.."
until curl http://${MONGODB1}:27017/serverStatus\?text\=1 2>&1 | grep uptime | head -1; do
  printf '.'
  sleep 1
done

# echo curl http://${MONGODB1}:27017/serverStatus\?text\=1 2>&1 | grep uptime | head -1
echo ${MONGODB1} " Started.."
echo "**************Replica Set configuration Begin*********"

sleep 20
echo SETUP.sh time now: `date +"%T" `
mongo --host ${MONGODB1}:27017 <<EOF
var cfg = {
    "_id": "rs0",
    "protocolVersion": 1,
    "version": 1,
    "members": [
        {
            "_id": 0,
            "host": "${MONGODB1}:27017",
            "priority": 2
        },
        {
            "_id": 1,
            "host": "${MONGODB2}:27017",
            "priority": 0
        },
        {
            "_id": 2,
            "host": "${MONGODB3}:27017",
            "priority": 0
        }
    ],settings: {chainingAllowed: true}
};

rs.initiate(cfg, { force: true });
rs.reconfig(cfg, { force: true });

rs.slaveOk();
db.getMongo().setReadPref('secondary');
db.getMongo().setSlaveOk();

echo "**************Replica Set configuration Complete*********"

EOF


until mongo --host ${MONGODB1}:27017 --eval 'db.isMaster().primary' | tail -1 | grep ${MONGODB1}; do
  printf 'Waiting for Replica Set to Intialize Primary.....'
  sleep 1
done

echo "Primary intialized...."
#echo "**************Index Creation Begin*********"

#mongo --host ${MONGODB1}:27017 <<EOF

#use orion;
#db.createCollection("entities");
#db.entities.createIndex({"_id.servicePath": 1, "_id.id": 1, "_id.type": 1}, {unique: true});
#db.entities.createIndex({"_id.type": 1}); db.entities.createIndex({"_id.id": 1});
#use orion-iotteststand;
#db.createCollection("entities");
#db.entities.createIndex({"_id.servicePath": 1, "_id.id": 1, "_id.type": 1}, {unique: true});
#db.entities.createIndex({"_id.type": 1}); db.entities.createIndex({"_id.id": 1});
#use iotagentul;
#db.createCollection("devices");
#db.devices.createIndex({"_id.service": 1, "_id.id": 1, "_id.type": 1});

#echo "**************Index Creation Complete*********"

#EOF


