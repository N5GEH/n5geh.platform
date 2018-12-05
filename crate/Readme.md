# Crate Database

In this scenario we will use CrateDB for storing timeseries data that we connect to
the context broker via quantum leap. To retrieve time-based aggregations of such data, users can either use QuantumLeap query API or connect directly to the CrateDB HTTP endpoint. The data then can be visualized in Grafana for instance. Nevertheless, for in production mode it is highly
recommended to not expose the http endpoint of the crateDB to the outside and only use
the timeseries query functionality of qunatumLeap. This ensures the full use of fiware's identity management and ability for multi-tenancy.

"CrateDB is a distributed SQL database built on top of a NoSQL foundation. It combines the familiarity of SQL with the scalability and data flexibility of NoSQL, enabling developers to:

- Use SQL to process any type of data, structured or unstructured
- Perform SQL queries at realtime speed, even JOINs and aggregates
- Scale simply"

For detailed information please visit https://crate.io.

**NOTE** For research purposes the community edition should be sufficient. If you
need more functionalities, please check
[Link](https://crate.io/docs/crate/reference/en/latest/enterprise/index.html).
For research purposes you might request an enterprise
edition for free.

Beside from CrateDB there are also many other DB-engines our there. The developers of
fiware timeseries API "QuantumLeap" started testing InfluxDB, RethinkDB and Crate. However, they have decided for now to focus the development on the translator for CrateDB because of the its advantages mentioned above. In future there might be also other  DB-engines supported. For
comparative overview of diffenrent engines, also the underlying of fiware click
 [here](https://db-engines.com/en/system/CrateDB%3BInfluxDB%3BMongoDB). Among other detailed comparisons in their a series of white paper [LINK](https://crate.io/cratedb-comparison/visit]
CrateDB offers a comparism between CrateDB and InfluxDB made in 2017 click [Link](http://go.cratedb.com/rs/832-QEZ-801/images/CrateDB-vs-Specialized-Time-Series-Databases.pdf?utm_medium=email&utm_source=mkto). For a performance evaluation of timeseries databases for monitoring purposes in general we recommend the master's thesis:
["Performance Evaluation of Low-Overhead Messaging Protocols and Time Series Databases
via a Common Middleware"](http://mitja.cc/master_thesis.pdf) by Mitja Schmakeit, 2017.


## Known Bugs

- To start the database, `vm.max_map_count` has to be increased:
```
sudo sysctl -w vm.max_map_count=262144
```
use `/etc/sysctl.conf` to set the value on every restart


1. Clone this repository

        git clone https://git.rwth-aachen.de/EBC/Team_BA/fiware/fiware-core.git fiware-core

2. Go into each subdirectory and copy the docker-compose.yaml.EXAMPLE and possibly further configuration files

        cp <ServiceName>.conf.EXAMPLE <ServiceName>.conf

        cp docker-compose.yaml.EXAMPLE docker-compose.yaml

3. You may the docker-compose.yaml or *.conf to you preferences. But the functionality will then left to you.

  **Note:** Some changes may require the modification of Makefile that comes along or other depending services!

4. Start each service either using the commands provided in the Makefile
        make deploy
or directly with docker command
        docker stack deploy -c docker-compose.yaml fiware
