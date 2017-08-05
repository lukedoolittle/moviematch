echo 'downloading: netflix dataset'
wget https://s3.amazonaws.com/moviematch/netflix_ratings.tar.gz
tar -xzf netflix_ratings.tar.gz

echo 'downloading: movie_id mappings'
wget https://s3.amazonaws.com/moviematch/movie_ids.csv

echo 'downloading: movielens dataset'
wget https://s3.amazonaws.com/moviematch/movielens_ratings.tar.gz
tar -xzf movielens_ratings.tar.gz

spark-submit create_tables.py

# Remove the storage-heavy files that were just put into hdfs
echo 'cleaning: netflix prize dataset'
rm netflix_ratings.tar.gz
rm netflix_ratings.csv
rm movie_ids.csv
rm movielens_ratings.csv
rm movielens_ratings.tar.gz