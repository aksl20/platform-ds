# plateforme-ds

Datascience environment managed by Docker and Docker-compose. This plateform will be used for testing and exploration by datascientist from DCA's team. Easy to deploy on a linux serveur. 

### Prerequisites

- [Docker](https://www.docker.com)
- [Docker-compose](https://docs.docker.com/compose/)

### Launch the platform

```sh
$ git clone <repo_url>
$ cd plateforme-ds
$ make 
$ docker-compose up -d
```

### Connect to the platform

- go to the url https://<ip_or_hostname_server> to open a jupyterlab session
(you must first create a user on the host machine then add him to the file in plateform-ds/jupyterhub/userlist)
- Hadoop nanemode: http://<ip_or_hostname_server>:9870
- Hadoop datanode: http://<ip_or_hostname_server>:9864
- Spark master: http://<ip_or_hostname_server>:8585 (webui) or http://<ip_or_hostname_server>:7077 (jobs)
- Spark worker-[x]: http://<ip_or_hostname_server>:808[x]
