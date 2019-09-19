FROM spark-base:2.4.4

ENV SPARK_HOME /opt/spark
ENV SPARK_WORKER_WEBUI_PORT 8081
ENV SPARK_WORKER_LOG /var/log/spark
ENV SPARK_MASTER "spark://spark-master:7077"

ADD entrypoint.sh /opt/
RUN chmod +x /opt/entrypoint.sh

# Put Spark under supervision
RUN mkdir -p ${SPARK_WORKER_LOG}
ADD supervisor/spark-worker.conf /etc/supervisor/conf.d/

# Expose ports for each application 
EXPOSE 2181 9092 9010 9000 6379 8086 8083 8088 8080 8042 4040 7077 9091

# Launch all components using Supervisor
#ENTRYPOINT ["/opt/entrypoint.sh"]
CMD ["supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]
