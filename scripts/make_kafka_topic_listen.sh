#!/bin/bash

$KAFKA_HOME/bin/kafka-topics.sh --zookeeper localhost:2181 --create --topic movie-ratings --replication-factor 1 --partitions 1
$KAFKA_HOME/bin/kafka-console-consumer.sh --zookeeper localhost:2181 --topic movie-ratings --from-beginning