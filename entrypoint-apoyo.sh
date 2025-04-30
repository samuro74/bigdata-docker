#!/bin/bash

# Set environment variables
export USERNAME=bigdata
export HADOOP_HOME=/opt/hadoop
export SPARK_HOME=/opt/spark
export KAFKA_HOME=/opt/kafka
export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$SPARK_HOME/bin:$SPARK_HOME/sbin:$KAFKA_HOME/bin

# Copy configurations to their final locations
mkdir -p $HADOOP_HOME/etc/hadoop
cp /home/$USERNAME/config/hadoop/* $HADOOP_HOME/etc/hadoop/

if [ "$SERVICE_TYPE" = "worker" ]; then
    echo "Configuring as worker/datanode"
    
    # Configure Hadoop to point to namenode
    sed -i "s/namenode/${NAMENODE_HOST}/" $HADOOP_HOME/etc/hadoop/core-site.xml
    echo "datanode" > $HADOOP_HOME/etc/hadoop/workers
    
    # Start SSH
    sudo service ssh start
    
    # Start DataNode
    hdfs --config $HADOOP_HOME/etc/hadoop datanode &
    
    # Start NodeManager
    yarn --config $HADOOP_HOME/etc/hadoop nodemanager &
    
    # Keep container running
    tail -f /dev/null
else
    echo "Running base image with no services started"
    tail -f /dev/null
fi