#!/bin/bash

wget http://files.grouplens.org/datasets/movielens/ml-1m.zip
unzip ml-1m.zip

hdfs dfs -put ~/ml-1m/* /data/movielens/