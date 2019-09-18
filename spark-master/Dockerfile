FROM spark-base:2.3.4

ENV SPARK_HOME /opt/spark
ENV SPARK_LOG /var/log/spark
ENV SPARK_MASTER_PORT 7077
ENV SPARK_MASTER_WEBUI_PORT 8080

ADD entrypoint.sh /opt/
RUN chmod +x /opt/entrypoint.sh

# Put Spark under supervision
RUN mkdir -p /var/log/spark
ADD supervisor/spark-master.conf /etc/supervisor/conf.d/

# Expose ports for each application 
EXPOSE 2181 9092 9010 9000 6379 8086 8083 8088 8080 8042 4040 7077 9091

# Launch all components using Supervisor
#ENTRYPOINT ["/opt/entrypoint.sh"]
CMD ["supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]
