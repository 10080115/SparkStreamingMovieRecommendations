#!/bin/bash


#download and decompress kafka
wget http://apache.claz.org/kafka/0.8.2.1/kafka_2.10-0.8.2.1.tgz 
tar -xvzf kafka_2.10-0.8.2.1.tgz
rm kafka_2.10-0.8.2.1.tgz
#echo "delete.topic.enable=true" >> kafka_2.10-0.8.2.1/config/server.properties