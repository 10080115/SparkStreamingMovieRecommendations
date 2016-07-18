#!/bin/bash

#$KAFKA_HOME/bin/kafka-topics.sh --zookeeper localhost:2181 --delete --topic ratings
rm -r /tmp/kafka-logs/movie-ratings-*
rm -r /tmp/zookeeper
$KAFKA_HOME/bin/kafka-server-stop.sh 
$KAFKA_HOME/bin/zookeeper-server-stop.sh
jps -l | grep zookeeper | awk '{print $1}' | xargs kill -9