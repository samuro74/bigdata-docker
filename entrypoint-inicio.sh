#!/bin/bash

# Set environment variables
export USERNAME=bigdata
export HADOOP_HOME=/opt/hadoop
export SPARK_HOME=/opt/spark
export KAFKA_HOME=/opt/kafka
export HIVE_HOME=/opt/hive
export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$SPARK_HOME/bin:$SPARK_HOME/sbin:$KAFKA_HOME/bin:$HIVE_HOME/bin
export HADOOP_OPTS="--add-exports=java.base/jdk.internal.ref=ALL-UNNAMED \
                   --add-opens=java.base/java.lang=ALL-UNNAMED \
                   --add-opens=java.base/java.net=ALL-UNNAMED"

# Copy configurations to their final locations
mkdir -p $HADOOP_HOME/etc/hadoop
cp /home/$USERNAME/config/hadoop/* $HADOOP_HOME/etc/hadoop/
mkdir -p $SPARK_HOME/conf
cp /home/$USERNAME/config/spark/* $SPARK_HOME/conf/
mkdir -p $HIVE_HOME/conf
cp /home/$USERNAME/config/hive/* $HIVE_HOME/conf/

if [ "$SERVICE_TYPE" = "master" ]; then
    echo "Configuring as master node"
    
    # Configure Hadoop
    echo "namenode" > $HADOOP_HOME/etc/hadoop/workers
    hdfs namenode -format $CLUSTER_NAME -force
    
    # Start Hadoop services
	hdfs --daemon start namenode
	hdfs --daemon start datanode
	yarn --daemon start resourcemanager
	yarn --daemon start nodemanager
    
    # Start Spark History Server
    start-history-server.sh
    
    # Start Kafka Zookeeper
    $KAFKA_HOME/bin/zookeeper-server-start.sh -daemon $KAFKA_HOME/config/zookeeper.properties
    
    # Start Kafka Server
    $KAFKA_HOME/bin/kafka-server-start.sh -daemon $KAFKA_HOME/config/server.properties
    
    # Initialize Hive Metastore
    schematool -initSchema -dbType derby
    
    # Start Hive Metastore
    hive --service metastore &
    
    # Start Jupyter Lab in virtual environment
    . /home/$USERNAME/venv/bin/activate
    jupyter lab --ip=0.0.0.0 --no-browser --allow-root --NotebookApp.token='' --NotebookApp.password='' &
    
    # Keep container running
    tail -f /dev/null
else
    # If not master, run the base image entrypoint
    exec /home/$USERNAME/entrypoint.sh
fi
