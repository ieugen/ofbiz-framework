# Example: Running Apache OFBiz and PostgreSQL using docker-compose

This directory contains the example files for launching Apache OFBiz with a PostgreSQL DBMS.

To successfully launch this example please address the following:
* Ensure of base ofbiz container image has been built.
* Build the docker-compose application.
* Launch the database
* Load ofbiz seed and example data.
* Launch OFBiz
* Shutdown OFBiz

## Build the OFBiz container image
The sources of OFBiz include a multi-stage Dockerfile used to build an image containing
the ofbiz runtime.

To build the container image, run the following from the ofbiz-framework sources directory:
```shell
docker build -t ofbiz .
```

The above command will build a container image tagged as ofbiz:latest. That image will be
used by this docker-compose application.


## Build the docker-compose application
The base container image created in the previous step doesn't include any database
drivers. This example docker-compose application will use PostgreSQL, therefore
we need to create a new version of the ofbiz container image with the PostgreSQL
driver included.

This is handled by the Dockerfile in the ofbiz subdirectory of this docker-compose
application.

To build the new container image run the following command from this docker-compose
application's directory:
```shell
docker-compose build
```

The above command will create a new container image, bespoke to this docker-compose application.


## Launch the database
Although we can control the order that services are started in a docker-compose application
we cannot delay starting of a service until another service is 'ready'. 
See https://docs.docker.com/compose/compose-file/compose-file-v3/#depends_on.
This means we have no programmatic way of ensuring the database is fully initialised before 
allowing the ofbiz service to run.

Therefore it is advised that you launch the database separately and observe it is fully initialised
before launching other services.

To launch the database execute the following command from this docker-compose application's
directory:
```shell
docker-compose up -d db
```

Then monitor the database service's progress by tailing logs with:
```shell
docker-compose logs -f
```

On first run, PostgreSQL will execute the .sql file config/initdb/01-ofbiz-init.sql which will
create the ofbiz user and databases needed by ofbiz. You can update the ofbiz user's credentials
in this file if needed.

In the logs you should see some lines similar to the following which correspond to the script execution:
```
db_1             | /usr/local/bin/docker-entrypoint.sh: running /docker-entrypoint-initdb.d/01-ofbiz-init.sql
db_1             | CREATE ROLE
db_1             | CREATE DATABASE
db_1             | CREATE DATABASE
db_1             | CREATE DATABASE
```

After running the above script, PostgreSQL will restart itself.

If you need to delete all databases so that you can re-initialise the database service run the
following to clear all containers and volumes belonging to this docker-compose application:
```shell
docker-compose down -v
```


## Load OFBiz seed and example data
With the database already running, it is time to load seed and example data. Run the following command:
```shell
docker-compose run load-all-data
```

The load-all-data service has been assigned a profile, seed, in the docker-compose.yml file. This will
prevent the service from launching during normal operation.


## Launch OFBiz
To launch OFBiz run the following command:
```shell
docker-compose up -d
```

This will launch the database, if not already running, and the OFBiz container in detached mode.

To observe stdout/stderr logging use:
```shell
docker-compose up load-all-data
```

OFBiz should be accessible at your localhost. Visit https://localhost:8443/partymgr in your web browser.

The default username/password is admin/ofbiz


## Shutdown OFBiz
To shutdown OFBiz running the following command:
```shell
docker-compose stop
```
