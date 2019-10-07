# platform-ds

Datascience environment managed by Docker and Docker-compose. This platform can be used for testing and exploration by any datascience team. Easy to deploy on a linux serveur. 

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
You can access namenode container by running the following command:

```sh
`$ docker exec -it namenode bash
```
You can access jupyter container to obtain the token key by running the following command:

```sh
$ docker exec -it jupyter bash
$ jupyter notebook list
```

### Spark and Hadoop in jupyter

You can connect to the spark cluster in the jupyter notebook by running the following code:

```py
from pyspark import SparkConf, SparkContext

conf = SparkConf().setAppName('test').setMaster('spark://spark-master:7077')
sc = SparkContext(conf=conf)
```

And read files from HDFS system as follow:

```py
lines = sc.textFile("hdfs://namenode:9000/<your_path_to_the_file>")
```

### Connect to the platform

- go to the url http://<ip_or_hostname_server>:10000 to open a jupyterlab session
- Hadoop nanemode: http://<ip_or_hostname_server>:9870
- Hadoop datanode: http://<ip_or_hostname_server>:9864
- Ressource Manager: http://<ip_or_hostname_server>:8088
- Spark master: http://<ip_or_hostname_server>:8585 (webui) or http://<ip_or_hostname_server>:7077 (jobs)
- Spark worker-[x]: http://<ip_or_hostname_server>:808[x]

### TODO LIST

- Add option to enable password authentication for the jupyter notebook
- Add linked folder between jupyter container and host machine (handle permission issues)
