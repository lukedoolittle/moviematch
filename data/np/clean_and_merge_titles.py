import re
import pandas

# requirements
# -add the movie_titles.csv file from the netflix dataset to this directory
# -add the movies.csv file from the netflix dataset to this directory

netflix_titles = []
with open('movie_titles.csv', 'r') as file:
    for line in file:
        match = re.match(r'(\d*),(\d*|NULL),(.*)',
                         line)
        if match is None:
            raise ValueError()
        else:
            netflix_titles.append([match.group(1),
                                   match.group(3),
                                   match.group(2)])

netflix = pandas.DataFrame(data=netflix_titles,
                           columns=['netflix_id',
                                    'title',
                                    'year'])

movielens_titles = []
with open('movies.csv', 'r', encoding='utf-8') as file:
    for line in file:
        if line == 'movieId,title,genres\n':
            continue
        match = re.match(r'(\d*),(.*),(.*)',
                         line)
        if match is None:
            raise ValueError()
        else:
            title_match = re.match(r'([^(]*) (\([^(]*\) )*(\(\d*\))',
                                   match.group(2).strip('"'))
            if title_match is None:
                print('Movielens miss: {0}'.format(line))
            else:
                movielens_titles.append([match.group(1),
                                         title_match.group(1),
                                         title_match.group(3).strip('(').strip(')')])

movielens = pandas.DataFrame(data=movielens_titles, 
                             columns=['movielens_id',
                                      'title',
                                      'year'])
join = pandas.merge(netflix,
                    movielens,
                    on=['title', 'year'],
                    how='inner')

pandas.DataFrame.to_csv(join[['movielens_id', 'netflix_id',]],
                        'movie_ids.csv',
                        index=False)
