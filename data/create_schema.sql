CREATE EXTERNAL TABLE IF NOT EXISTS movie_ratings_raw
(user_id string,
movie_id string,
rating string,
timestamp string)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/user/w205/moviematch/ratings'
tblproperties("skip.header.line.count"="1");


CREATE EXTERNAL TABLE IF NOT EXISTS NP_RATINGS_RAW(MOVIE_ID INT, USER_ID INT, RATING SMALLINT, RDATE DATE)
ROW FORMAT SERDE'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES(
"separatorChar" = ",",
"quoteChar" = '"',
"escapeChar" = '\\'
)
STORED AS TEXTFILE
LOCATION '/user/w205/netflix_prize/ratings';


CREATE EXTERNAL TABLE IF NOT EXISTS NP_TITLES_RAW(MOVIE_ID INT, YEAR INT, TITLE STRING)
ROW FORMAT SERDE'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES(
"separatorChar" = ",",
"quoteChar" = '"',
"escapeChar" = '\\'
)
STORED AS TEXTFILE
LOCATION '/user/w205/netlix_prize/titles';
