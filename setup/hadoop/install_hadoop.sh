#!/bin/bash


#download and decompress kafka

sudo apt-get -y install ssh rsync openssh-client openssh-server

ssh-keygen -t dsa -P '' -f ~/.ssh/id_dsa
sudo cat ~/.ssh/id_dsa.pub >> ~/.ssh/authorized_keys


wget http://mirrors.sonic.net/apache/hadoop/common/hadoop-2.6.0/hadoop-2.6.0.tar.gz
tar -xvzf hadoop-2.6.0.tar.gz
rm hadoop-2.6.0.tar.gz


echo "export JAVA_HOME=\"/usr/lib/jvm/java-7-openjdk-amd64/jre/\"" >> /home/vagrant/hadoop-2.6.0/etc/hadoop/hadoop-env.sh

echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" > /home/vagrant/hadoop-2.6.0/etc/hadoop/core-site.xml
echo "<?xml-stylesheet type=\"text/xsl\" href=\"configuration.xsl\"?>" >> /home/vagrant/hadoop-2.6.0/etc/hadoop/core-site.xml
echo "<configuration>" >> /home/vagrant/hadoop-2.6.0/etc/hadoop/core-site.xml
echo -e "\t<property>" >> /home/vagrant/hadoop-2.6.0/etc/hadoop/core-site.xml
echo -e "\t\t<name>fs.defaultFS</name>" >> /home/vagrant/hadoop-2.6.0/etc/hadoop/core-site.xml
echo -e "\t\t<value>hdfs://0.0.0.0:9000</value>" >> /home/vagrant/hadoop-2.6.0/etc/hadoop/core-site.xml
echo -e "\t</property>" >> /home/vagrant/hadoop-2.6.0/etc/hadoop/core-site.xml
echo "</configuration>" >> /home/vagrant/hadoop-2.6.0/etc/hadoop/core-site.xml

echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" > /home/vagrant/hadoop-2.6.0/etc/hadoop/hdfs-site.xml
echo "<?xml-stylesheet type=\"text/xsl\" href=\"configuration.xsl\"?>" >> /home/vagrant/hadoop-2.6.0/etc/hadoop/hdfs-site.xml
echo "<configuration>" >> /home/vagrant/hadoop-2.6.0/etc/hadoop/hdfs-site.xml

echo -e "\t<property>" >> /home/vagrant/hadoop-2.6.0/etc/hadoop/hdfs-site.xml
echo -e "\t\t<name>dfs.replication</name>" >> /home/vagrant/hadoop-2.6.0/etc/hadoop/hdfs-site.xml
echo -e "\t\t<value>1</value>" >> /home/vagrant/hadoop-2.6.0/etc/hadoop/hdfs-site.xml
echo -e "\t</property>" >> /home/vagrant/hadoop-2.6.0/etc/hadoop/hdfs-site.xml

echo -e "\t<property>" >> /home/vagrant/hadoop-2.6.0/etc/hadoop/hdfs-site.xml
echo -e "\t\t<name>dfs.datanode.data.dir</name>" >> /home/vagrant/hadoop-2.6.0/etc/hadoop/hdfs-site.xml
echo -e "\t\t<value>file:///home/vagrant/hadoop-2.6.0/hdfs/datanode</value>" >> /home/vagrant/hadoop-2.6.0/etc/hadoop/hdfs-site.xml
echo -e "\t</property>" >> /home/vagrant/hadoop-2.6.0/etc/hadoop/hdfs-site.xml

echo -e "\t<property>" >> /home/vagrant/hadoop-2.6.0/etc/hadoop/hdfs-site.xml
echo -e "\t\t<name>dfs.namenode.name.dir</name>" >> /home/vagrant/hadoop-2.6.0/etc/hadoop/hdfs-site.xml
echo -e "\t\t<value>file:///home/vagrant/hadoop-2.6.0/hdfs/namenode</value>" >> /home/vagrant/hadoop-2.6.0/etc/hadoop/hdfs-site.xml
echo -e "\t</property>" >> /home/vagrant/hadoop-2.6.0/etc/hadoop/hdfs-site.xml

echo "</configuration>" >> /home/vagrant/hadoop-2.6.0/etc/hadoop/hdfs-site.xml

echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" > /home/vagrant/hadoop-2.6.0/etc/hadoop/mapred-site.xml
echo "<?xml-stylesheet type=\"text/xsl\" href=\"configuration.xsl\"?>" >> /home/vagrant/hadoop-2.6.0/etc/hadoop/mapred-site.xml
echo "<configuration>" >> /home/vagrant/hadoop-2.6.0/etc/hadoop/mapred-site.xml
echo -e "\t<property>" >> /home/vagrant/hadoop-2.6.0/etc/hadoop/mapred-site.xml
echo -e "\t\t<name>mapreduce.framework.name</name>" >> /home/vagrant/hadoop-2.6.0/etc/hadoop/mapred-site.xml
echo -e "\t\t<value>yarn</value>" >> /home/vagrant/hadoop-2.6.0/etc/hadoop/mapred-site.xml
echo -e "\t</property>" >> /home/vagrant/hadoop-2.6.0/etc/hadoop/mapred-site.xml
echo "</configuration>" >> /home/vagrant/hadoop-2.6.0/etc/hadoop/mapred-site.xml

echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" > /home/vagrant/hadoop-2.6.0/etc/hadoop/yarn-site.xml
echo "<?xml-stylesheet type=\"text/xsl\" href=\"configuration.xsl\"?>" >> /home/vagrant/hadoop-2.6.0/etc/hadoop/yarn-site.xml
echo "<configuration>" >> /home/vagrant/hadoop-2.6.0/etc/hadoop/yarn-site.xml
echo -e "\t<property>" >> /home/vagrant/hadoop-2.6.0/etc/hadoop/yarn-site.xml
echo -e "\t\t<name>yarn.nodemanager.aux-services</name>" >> /home/vagrant/hadoop-2.6.0/etc/hadoop/yarn-site.xml
echo -e "\t\t<value>mapreduce_shuffle</value>" >> /home/vagrant/hadoop-2.6.0/etc/hadoop/yarn-site.xml
echo -e "\t</property>" >> /home/vagrant/hadoop-2.6.0/etc/hadoop/yarn-site.xml
echo "</configuration>" >> /home/vagrant/hadoop-2.6.0/etc/hadoop/yarn-site.xml


chmod vagrant /etc/ssh/ssh_config
echo -e "    StrictHostKeyChecking no" >> /etc/ssh/ssh_config
echo -e "    UserKnownHostFile=/dev/null" >> /etc/ssh/ssh_config

ssh-keygen -t dsa -P '' -f >> ~/.ssh/id_dsa
sudo cat ~/.ssh/id_dsa.pub >> ~/.ssh/authorized_keys

echo "Y" | hdfs namenode -format
/home/vagrant/hadoop-2.6.0/sbin/start-dfs.sh
hdfs dfs -mkdir /user
hdfs dfs -mkdir /user/vagrant
hdfs dfs -mkdir /user/hive
hdfs dfs -chmod g+w /user/hive/
hdfs dfs -mkdir /tmp
hdfs dfs -chmod g+w /tmp
hdfs dfs -mkdir /user/hive/warehouse
hdfs dfs -chmod g+w /user/hive/warehouse
hdfs dfs -mkdir /data/
hdfs dfs -mkdir /data/movielens
hdfs dfs -chmod g+w /data
hdfs dfs -chmod g+w /data/movielens