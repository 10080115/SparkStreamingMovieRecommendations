
"CREATE DATABASE IF NOT EXISTS moviestream;"
"USE moviestream;"
"CREATE EXTERNAL TABLE movieratings (userId INT, movieId INT, rating INT, time TIMESTAMP) STORED AS PARQUET LOCATION '/data/hive/parquet/movieratings';"