import os
import csv
import re

# Navigate to the directory that contains the netflix prize data
# Also store some other locations for later
data_dir = '/data/npdata'
os.chdir(data_dir)

training_dir = 'training_data/'
titles_csv_path = 'titles/titles.csv'

''' Define the schema:
Titles
Primary key:
MOVIE_ID

Attributes:
TITLE
YEAR


RATINGS
Primary key:
MOVIE_ID, USER_ID

Attributes:
MOVIE_ID
RATING
RATING_DATE
'''

# Compile a list of file names
file_list = os.listdir(training_dir + '.')


# Append the content of each file to a csv file

with open('ratings/ratings.csv', 'w') as csv_file:
    for file_path in file_list:
        with open(training_dir + file_path, 'r') as f:
            # Store the first line as the movie_id, only including numbers
            movie_id = re.match('[0-9]+', next(f)).group()
            for line in f:
                # Each line is written as movie_id, user_id, rating, date
                csv_file.write(movie_id + ',' + line)

with open(titles_csv_path, 'w') as titles_csv:
    with open('movie_titles.txt', 'r') as f:
        # Remove commas in titles
        for line in f:
            revised_line = ''
            comma_counter = 0
            for c in line:
                if c == ',':
                    comma_counter += 1
                    if comma_counter > 2:
                        revised_line += ''
                    else:
                        revised_line += c
                else:
                    revised_line += c
            # Write each line as movie_id, year, title
            titles_csv.write(revised_line)
