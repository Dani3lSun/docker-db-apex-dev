# Oracle Database & APEX Developer Docker Image

[![APEX Community](https://cdn.rawgit.com/Dani3lSun/apex-github-badges/78c5adbe/badges/apex-community-badge.svg)](https://github.com/Dani3lSun/apex-github-badges) [![APEX Tool](https://cdn.rawgit.com/Dani3lSun/apex-github-badges/b7e95341/badges/apex-tool-badge.svg)](https://github.com/Dani3lSun/apex-github-badges)
[![APEX Built with Love](https://cdn.rawgit.com/Dani3lSun/apex-github-badges/7919f913/badges/apex-love-badge.svg)](https://github.com/Dani3lSun/apex-github-badges)

## Content

This Docker Image contains the following:

* Oracle Linux 7.5
* Oracle Database 12.2.0.1 or 18.3 Enterprise Edition with non-CDB architecture
* Oracle APEX 18.1.0
* Oracle ORDS 18.2
* Oracle SQLcl 18.2
* Apache Tomcat 8.0.53
* Java JDK 8u171
* OraOpenSource Logger 3.1.1
* OraOpenSource OOS Utils 1.0.1
* APEX Office Print 3.x (Cloud Package)
* Swagger-UI 3.x

## Installation

### Using Default Settings (recommended)

Complete the following steps to create a new container:

1. **Clone or Download the Github Repository to your local Machine**

```bash
git clone https://github.com/Dani3lSun/docker-db-apex-dev.git
```

2. **Download missing Software Components**

Thus you have to agree to the License Agreement of Oracle for parts of this Docker Image, you have to download the Install Files by your own.
You can take the direct Download Links from [download_urls.txt](https://github.com/Dani3lSun/docker-db-apex-dev/blob/master/files/download_urls.txt) in [files](https://github.com/Dani3lSun/docker-db-apex-dev/tree/master/files) directory.

**Direct Links:**

* [Oracle Database 12.2.0.1 EE](http://download.oracle.com/otn/linux/oracle12c/122010/linuxx64_12201_database.zip)
* [Oracle Database 18.3 EE](https://download.oracle.com/otn/linux/oracle18c/180000/LINUX.X64_180000_db_home.zip)
* [Oracle APEX 18.2](http://download.oracle.com/otn/java/appexpress/apex_18.2.zip)
* [Oracle ORDS 18.3](http://download.oracle.com/otn/java/ords/ords-18.3.0.270.1456.zip)
* [Oracle SQLcl 18.3](http://download.oracle.com/otn/java/sqldeveloper/sqlcl-18.3.0.259.2029.zip)
* [Apache Tomcat 8.0.53](http://www-eu.apache.org/dist/tomcat/tomcat-8/v8.0.53/bin/apache-tomcat-8.0.53.tar.gz)
* [Java JDK 8u181 - Linux x64 tar.gz](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)
* [OraOpenSource Logger 3.1.1](https://github.com/OraOpenSource/Logger/raw/master/releases/logger_3.1.1.zip)
* [OraOpenSource OOS Utils 1.0.1](https://observant-message.glitch.me/oos-utils/latest/oos-utils-latest.zip)
* [APEX Office Print 3.x (Login and download Cloud Package)](https://www.apexofficeprint.com)
* [Swagger-UI v3.x](https://github.com/swagger-api/swagger-ui/archive/v3.19.2.zip)
* [GOSU - Docker SU Fix](https://github.com/tianon/gosu/releases/download/1.10/gosu-amd64)

**Place all downloaded files in the** [files](https://github.com/Dani3lSun/docker-db-apex-dev/tree/master/files) **directory!**

3. **Customize some settings to reflect your needs (optional)**

You can change some Environment Variables directly in the [Dockerfile](https://github.com/Dani3lSun/docker-db-apex-dev/blob/master/Dockerfile):

```bash
INSTALL_APEX=true # Whether install Oracle APEX (Oracle ORDS / Apache Tomcat) or Not
INSTALL_SQLCL=true # Whether install Oracle SQLCL or Not
INSTALL_LOGGER=true # Whether install OraOpenSource Logger or Not
INSTALL_OOSUTILS=true # Whether install OraOpenSource OOS Utils or Not
INSTALL_AOP=true # Whether install APEX Office Print (AOP) or Not (Cloud Package)
INSTALL_SWAGGER=true # Whether install Swagger-UI for REST docs or Not
DBCA_TOTAL_MEMORY=2048 # Memory Size of Database
ORACLE_SID=orcl # SID of Oracle Database
SERVICE_NAME=orcl # SERVICE_NAME of Oracle Database
DB_INSTALL_VERSION=18 # Database version to install, 12 or 18
ORACLE_BASE=/u01/app/oracle # Path to ORACLE_BASE Directory
ORACLE_HOME12=/u01/app/oracle/product/12.2.0.1/dbhome # Path to ORACLE_HOME Directory of 12.2 database
ORACLE_HOME18=/u01/app/oracle/product/18.0.0/dbhome # Path to ORACLE_HOME Directory of 18.3 database
ORACLE_INVENTORY=/u01/app/oraInventory # Path to ORACLE_INVENTORY Directory
PASS=oracle # Password of all Database Users (like SYS, APEX_PUBLIC_USER ...), Tomcat Admin and SSH
ORDS_HOME=/u01/ords # Path to ORDS_HOME Directory
JAVA_HOME=/opt/java # Path to JAVA_HOME Directory
TOMCAT_HOME=/opt/tomcat # Path to TOMCAT_HOME Directory
APEX_PASS=OrclAPEX1999! # Admin Password of Oracle APEX Web Login (Caution: Oracle APEX Password Policy)
APEX_ADDITIONAL_LANG= # Additional Language of APEX, blank to only install English (e.g de, es, fr, it, ja, ko, pt-br, zh-cn, zh-tw)
TIME_ZONE=UTC # Timezone of your favorite Location (Europe/Berlin, UTC, US/Eastern, ...) --> Only Linux zoneinfo supported
```

4. **Build the Docker Image**

```bash
cd /path/to/docker-db-apex-dev
docker build -t <your-docker-image-name> .
# e.g
docker build -t db-apex-dev-image .
```

*Note: Please be sure to have enough disk space left. Building this image needs around 40-50GB of free space. The successfully built image has a size of 15-16GB*

5. **Run the Docker Container**

```bash
docker run -d --name <your-docker-container-name> -p <local-ssh-port>:22 -p <local-http-port>:8080 -p <local-db-listener-port>:1521 -v /dev/shm --tmpfs /dev/shm:rw,nosuid,nodev,exec,size=2g <your-docker-image-name>
# e.g
docker run -d --name db-apex-dev-container -p 2222:22 -p 8080:8080 -p 1521:1521 -v /dev/shm --tmpfs /dev/shm:rw,nosuid,nodev,exec,size=2g db-apex-dev-image
```

*Note: /dev/shm should be equal the size of allocated Memory to the Database. /dev/shm must also be mounted as tmpfs.*

6. **Start/Stop of Docker Container**

```bash
docker start <your-docker-container-name>
docker stop <your-docker-container-name>
# e.g
docker start db-apex-dev-container
docker stop db-apex-dev-container
```

## Access To Services

For this Docker Run Example and the **Default Environment Variables (Step 3)**:

**docker run -d --name db-apex-dev-container -p 2222:22 -p 8080:8080 -p 1521:1521 -v /dev/shm --tmpfs /dev/shm:rw,nosuid,nodev,exec,size=2g db-apex-dev-image**

### Oracle APEX

[http://localhost:8080/ords/](http://localhost:8080/ords/)

Property | Value
-------- | -----
Workspace | INTERNAL
User | ADMIN
Password | OrclAPEX1999!

*If APEX Office Print is installed*

Property | Value
-------- | -----
Workspace | AOP
User | ADMIN
Password | OrclAPEX1999!

### Database Connections

To access the database e.g. from SQL Developer you configure the following properties:

Property | Value
-------- | -----
Hostname | localhost
Port | 1521
SID | orcl
Service | orcl

The configured user with their credentials are:

User | Password
-------- | -----
system | oracle
sys | oracle
apex_listener | oracle
apex\_rest\_public\_user | oracle
apex\_public\_user | oracle
logger\_user | oracle
oosutils\_user | oracle
aop | oracle

Use the following connect string to connect as SYSTEM via SQL*Plus or SQLcl: ```system/oracle@localhost/orcl```

### SSH

To access the Docker Container via SSH: ```ssh root@localhost -p 2222```

User | Password
-------- | -----
root | oracle
oracle | oracle

If you want to use SSH without a Password but rather with PubKey Authentication you have the place a **authorized_keys** file in the [files](https://github.com/Dani3lSun/docker-db-apex-dev/tree/master/files) directory before build.


## Credits
This Dockerfile is based on the following work:

- Philipp Salvisberg's GitHub Project [PhilippSalvisberg/docker-oracle12ee](https://github.com/PhilippSalvisberg/docker-oracle12ee)
- Andrzej Raczkowski's GitHub Project [araczkowski/docker-oracle-apex-ords](https://github.com/araczkowski/docker-oracle-apex-ords)

## License

MIT

See [Oracle Database Licensing Information User Manual](https://docs.oracle.com/database/122/DBLIC/Licensing-Information.htm#DBLIC-GUID-B6113390-9586-46D7-9008-DCC9EDA45AB4) regarding Oracle Database licenses.
