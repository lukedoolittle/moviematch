DROP TABLE movie_ratings;
CREATE TABLE movie_ratings AS SELECT 
CAST(user_id AS INT) user_id,
CAST(movie_id AS INT) movie_id,
CAST(rating AS DECIMAL(2,1)) rating
FROM movielens_ratings_raw
where user_id <> 'userId';