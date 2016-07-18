package com.bryantravissmith.spark.stream

import java.sql.Timestamp
import kafka.serializer.StringDecoder
import org.apache.spark.{SparkContext, SparkConf}
import org.apache.spark.sql._
import org.apache.spark.sql.types.{StructType,StructField,StringType,IntegerType,DoubleType,LongType}
import org.apache.spark.sql.SaveMode
import org.apache.spark.streaming._
import org.apache.spark.streaming.kafka._
import org.apache.spark.rdd.RDD
import org.apache.spark.mllib.recommendation.ALS
import org.apache.spark.mllib.recommendation.MatrixFactorizationModel
import org.apache.spark.mllib.recommendation.Rating
import java.util.Properties

case class MovieRating(userId:Int,movieId:Int,rating:Int,time:Timestamp)
case class ALSFeature(id:Int,features:String)

object SparkStreamMovieRatings {
  def main(args: Array[String]) {
    val conf = new SparkConf().setAppName("SparkStreamingTest")
    val sc = new SparkContext(conf)
    val sqlContext = new SQLContext(sc)
    import sqlContext.implicits._


    val fileName = args(0)

    val parquetFile = sqlContext.read.parquet(fileName)
	
	parquetFile.registerTempTable("ratings")

	sqlContext.sql("SELECT COUNT(*) FROM ratings").show()

    val ssc = new StreamingContext(sc, Seconds(10))

	val topicsSet = Array("movie-ratings").toSet
	val kafkaParams = Map[String, String]("metadata.broker.list" -> "localhost:9092","auto.offset.reset" -> "largest","group.id"->"spark-streaming-consumer-1")
	val messages = KafkaUtils.createDirectStream[String, String, StringDecoder, StringDecoder](ssc, kafkaParams, topicsSet)
	messages.map(_._2).foreachRDD { (rdd: RDD[String], time: Time) =>

			rdd.cache()
			rdd.map(row => row.split("::"))
					.map({case row => 
						val ts:Timestamp = new Timestamp(row(3).toString.trim.toLong*1000L)
						MovieRating(row(0).toInt,row(1).toInt,row(2).toInt,ts)
					})
					.toDF
					.write
					.mode(SaveMode.Append)
					.saveAsTable("ratings")
			val tempDf = sqlContext.sql("SELECT COUNT(*) FROM ratings")

			println(s"========= $time =========")
			tempDf.show()
			rdd.unpersist()
	}
	ssc.start
	ssc.awaitTermination
  }
}

object SparkBatchALSRecommendations {

	def main(args: Array[String]){

		val conf = new SparkConf().setAppName("SparkStreamingTest")//.setMaster("local[*]")
	    val sc = new SparkContext(conf)
	    val sqlContext = new SQLContext(sc)
	    import sqlContext.implicits._
		
		val fileName = args(0)
    	val parquetFile = sqlContext.read.parquet(fileName)
		val ratings = parquetFile.rdd.map(row => Rating(row(0).toString.toInt,row(1).toString.toInt,row(2).toString.toDouble))

		val rank = 5
		val numIterations = 10
		val model = ALS.train(ratings, rank, numIterations, 0.01)

		val dbProperties = new Properties
		dbProperties.setProperty("user","postgres")
		dbProperties.setProperty("password","password")
		dbProperties.setProperty("driver","org.postgresql.Driver")
		dbProperties.setProperty("ssl","true")
		dbProperties.setProperty("sslfactory","org.postgresql.ssl.NonValidatingFactory")

		def mapALSFeatures(id:Int,array:Array[Double]):ALSFeature = {
		    var jsonString:String = "{"
		    for ( i <- 0 to (array.length - 1)) {
		        var temp = "\""+i.toString+"\""
		        temp = temp + ":"
		        temp = temp + "\"" + array(i).toString + "\""
		        jsonString = jsonString + temp
		        if (i < (array.length-1)) jsonString = jsonString + ","
		    }
		    jsonString = jsonString + "}"
		    ALSFeature(id,jsonString)
		}

		var jsonDF = model.productFeatures.map({case (id,array) => mapALSFeatures(id,array)}).toDF()
		jsonDF.write.mode(SaveMode.Overwrite).jdbc("jdbc:postgresql://localhost:5432/","public.movie_vectors",dbProperties)
		jsonDF = model.userFeatures.map({case (id,array) => mapALSFeatures(id,array)}).toDF()
		jsonDF.write.mode(SaveMode.Overwrite).jdbc("jdbc:postgresql://localhost:5432/","public.user_vectors",dbProperties)

	}
}