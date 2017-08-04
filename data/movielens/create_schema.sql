CREATE EXTERNAL TABLE IF NOT EXISTS movielens_ratings_raw
(user_id string,
movie_id string,
rating string,
timestamp string)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/user/w205/moviematch/movielens_ratings'
tblproperties("skip.header.line.count"="1");