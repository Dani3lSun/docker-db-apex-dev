# Oracle Database & APEX Developer Docker Image

## Content

This Docker Image contains the following:

* Oracle Linux 7.3
* Oracle Database 12.2.0.1 Enterprise Edition with non-CDB architecture
* Oracle APEX 5.1.1
* Oracle ORDS 3.0.9
* Oracle SQLCL 4.2.0.17.073.1038
* Apache Tomcat 8.0.42
* Java JDK 8u121

## Installation

### Using Default Settings (recommended)

Complete the following steps to create a new container:

1. **Clone or Download the Github Repository to you local Machine**

```bash
git clone https://github.com/Dani3lSun/docker-db-apex-dev.git
```

2. **Download missing Software Components**

Thus you have to agree the License Agreement of Oracle for parts of this Docker Image you have to download the Install Files by your own.
You can take the direct Downlink Links from [download_urls.txt](https://github.com/Dani3lSun/docker-db-apex-dev/blob/master/files/download_urls.txt) in [files](https://github.com/Dani3lSun/docker-db-apex-dev/tree/master/files) directory.

3. **Customize some settings to reflect your needs (optional)**

You can change some Environment Variables directly in the dockerfile:

```bash
INSTALL_APEX=true # Whether install Oracle APEX (Oracle ORDS / Apache Tomcat) or Not
INSTALL_SQLCL=true # Whether install Oracle SQLCL or Not
DBCA_TOTAL_MEMORY=2048 # Memeory Size of Database
ORACLE_SID=db12c # SID of Oracle Database
SERVICE_NAME=db12c.docker # SERVICE_NAME of Oracle Database
ORACLE_BASE=/u01/app/oracle # Path to ORACLE_BASE Directory
ORACLE_HOME=/u01/app/oracle/product/12.2.0.1/dbhome # Path to ORACLE_HOME Directory
ORACLE_INVENTORY=/u01/app/oraInventory # Path to ORACLE_INVENTORY Directory
PASS=oracle # Password of all Database Users (like SYS, APEX_PUBLIC_USER ...) and SSH
ORDS_HOME=/u01/ords # Path to ORDS_HOME Directory
JAVA_HOME=/opt/java # Path to JAVA_HOME Directory
TOMCAT_HOME=/opt/tomcat # Path to TOMCAT_HOME Directory
APEX_PASS=OrclAPEX12c! # Admin Password of Oracle APEX Web Login
APEX_ADDITIONAL_LANG= # Additional Language of APEX, blank to only install English (e.g de, es, fr, it, ja, ko, pt-br, zh-cn, zh-tw)
APEX_ADDITIONAL_LANG_NLS= # Additional Language of APEX (NLS Setting), blank to only install English (e.g GERMAN_GERMANY, SPANISH_SPAIN, FRENCH_FRANCE, ...)
TIME_ZONE=UTC # Timezone of you favorite Location (Europe/Berlin, UTC, US/Eastern, ...) --> Only Linux zoneinfo supported
```

4. **Build the Docker Image**

```bash
cd /path/to/docker-db-apex-dev
docker build -t <your-docker-image-name> .
# e.g
docker build -t docker-db-apex-dev-image .
```

5. **Run the Docker Container**

```bash
docker run -d --name <your-docker-container-name> -p <local-ssh-port>:22 -p <local-http-port>:8080 -p <local-db-listener-port>:1521 <your-docker-image-name>
# e.g
docker run -d --name docker-db-apex-dev-container -p 2222:22 -p 8080:8080 -p 1521:1521 docker-db-apex-dev-image
```

6. **Start/Stop of Docker Container**

```bash
docker start <your-docker-container-name>
docker stop <your-docker-container-name>
# e.g
docker start docker-db-apex-dev-container
docker stop docker-db-apex-dev-container
```

## Access To Services

For this Docker Run Example and the Default Environment Variables (Step 3):

**docker run -d --name docker-db-apex-dev-container -p 2222:22 -p 8080:8080 -p 1521:1521 docker-db-apex-dev-image**

### Oracle APEX

[http://localhost:8080/ords/](http://localhost:8080/ords/)

Property | Value
-------- | -----
Workspace | INTERNAL
User | ADMIN
Password | OrclAPEX12c!

### Database Connections

To access the database e.g. from SQL Developer you configure the following properties:

Property | Value
-------- | -----
Hostname | localhost
Port | 1521
SID | db12c
Service | db12c.docker

The configured user with their credentials are:

User | Password
-------- | -----
system | oracle
sys | oracle
apex_listener | oracle
apex\_rest\_public\_user | oracle
apex\_public\_user | oracle

Use the following connect string to connect as SYSTEM via SQL*Plus or SQLcl: ```system/oracle@localhost/db12c.docker```

### SSH

To access the Docker Container via SSH: ```ssh root@localhost -p 2222```

User | Password
-------- | -----
root | oracle

If you want to use SSH without a Password but rather with PubKey Authentication you have the place a **authorized_keys** file in the [files](https://github.com/Dani3lSun/docker-db-apex-dev/tree/master/files) directory.

## Credits
This Dockerfile is based on the following work:

- Philipp Salvisberg's GitHub Project [PhilippSalvisberg/docker-oracle12ee](https://github.com/PhilippSalvisberg/docker-oracle12ee)
- Andrzej Raczkowski's GitHub Project [araczkowski/docker-oracle-apex-ords](https://github.com/araczkowski/docker-oracle-apex-ords)

## License

MIT

See [Oracle Database Licensing Information User Manual](https://docs.oracle.com/database/122/DBLIC/Licensing-Information.htm#DBLIC-GUID-B6113390-9586-46D7-9008-DCC9EDA45AB4) regarding Oracle Database licenses.
