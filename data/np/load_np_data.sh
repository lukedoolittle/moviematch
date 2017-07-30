# Download the dataset
wget --directory-prefix /data/ https://s3.amazonaws.com/moviematchbeta/nf_prize_dataset.tar.gz

# Unzip and tar the dataset
tar -zxvf /data/nf_prize_dataset.tar.gz --directory /data/
echo 'Sleeping for 40 seconds'
sleep 40
# Remove the tar file
rm /data/nf_prize_dataset.tar.gz
# Rename the download
mv /data/download /data/npdata
# Tar the training data, delete the tar file and rename it
tar -xf /data/npdata/training_set.tar --directory /data/npdata/
echo 'Sleeping for 40 more seconds'
sleep 40
rm /data/npdata/training_set.tar
mv /data/npdata/training_set /data/npdata/training_data
# Make a separate directory for the ratings and the movie titles
mkdir /data/npdata/titles
mkdir /data/npdata/ratings

# Transform the text files to csv files and delete the text files
echo 'transforming text files to csv files'
python /home/w205/moviematch/data/np/text_to_csv.py
rm -r /data/npdata/training_data
rm /data/npdata/movie_titles.txt

# Load the csv files into hdfs
echo 'loading netflix prize csv files into hdfs'
bash /home/w205/moviematch/data/np/load_data_lake.sh
