

$SPARK_HOME/bin/spark-submit   --class com.bryantravissmith.spark.stream.SparkBatchALSRecommendations   /vagrant/scripts/scala/sparkstreaming/target/scala-2.10/SparkStream-assembly-1.0.jar  /data/hive/parquet/movieratings


$SPARK_HOME/bin/spark-submit   --class com.bryantravissmith.spark.stream.SparkStreamMovieRatings   /vagrant/scripts/scala/sparkstreaming/target/scala-2.10/SparkStream-assembly-1.0.jar  /data/hive/parquet/movieratings