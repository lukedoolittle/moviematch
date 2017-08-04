CREATE EXTERNAL TABLE IF NOT EXISTS NP_RATINGS_RAW(MOVIE_ID INT, USER_ID INT, RATING SMALLINT, RDATE DATE)
ROW FORMAT SERDE'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES(
"separatorChar" = ",",
"quoteChar" = '"',
"escapeChar" = '\\'
)
STORED AS TEXTFILE
LOCATION '/user/w205/moviematch/netflix_ratings';


CREATE EXTERNAL TABLE IF NOT EXISTS NP_TITLES_RAW(MOVIE_ID INT, YEAR INT, TITLE STRING)
ROW FORMAT SERDE'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES(
"separatorChar" = ",",
"quoteChar" = '"',
"escapeChar" = '\\'
)
STORED AS TEXTFILE
LOCATION '/user/w205/moviematch/netflix_titles';


CREATE EXTERNAL TABLE IF NOT EXISTS movie_id_mapping
(movielens_id string,
netflix_id string)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/user/w205/moviematch/movie_id_map'
tblproperties("skip.header.line.count"="1");
