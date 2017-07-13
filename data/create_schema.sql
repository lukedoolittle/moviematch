CREATE EXTERNAL TABLE IF NOT EXISTS movie_ratings_raw
(user_id string,
movie_id string,
rating string,
timestamp string)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/user/w205/moviematch/ratings'
tblproperties("skip.header.line.count"="1");