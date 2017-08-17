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
rm -f netflix_ratings.tar.gz
rm -f netflix_ratings.csv
rm -f movie_ids.csv
rm -f movielens_ratings.csv
rm -f movielens_ratings.tar.gz