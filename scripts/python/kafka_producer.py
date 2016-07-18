from kafka import KafkaConsumer, KafkaProducer
import time

producer = KafkaProducer(bootstrap_servers='localhost:9092')

f = open("/home/vagrant/ml-1m/ratings.dat",'r')

for line in f:
	producer.send('movie-ratings', str(line))
	time.sleep(0.1)
