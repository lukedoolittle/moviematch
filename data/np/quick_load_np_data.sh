echo 'downloading: netflix dataset'
wget https://s3.amazonaws.com/moviematch/netflix_ratings.tar.gz
tar -xzf netflix_ratings.tar.gz

# Load the csv files into hdfs
echo 'loading: netflix prize csv files into hdfs'
hdfs dfs -put netflix_ratings.csv /user/w205/moviematch/netflix_ratings

echo 'downloading: movie_id mappings'
wget https://s3.amazonaws.com/moviematch/movie_ids.csv

echo 'moving: movie_id mappings into hdfs'
hdfs dfs -put movie_ids.csv /user/w205/moviematch/movie_id_map

# Remove the storage-heavy files that were just put into hdfs
echo 'cleaning: netflix prize dataset'
rm netflix_ratings.tar.gz
rm netflix_ratings.csv
rm movie_ids.csv