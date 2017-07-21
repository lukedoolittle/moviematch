SELECT movie_id, count(*) AS movie_count FROM movie_ratings_raw
GROUP BY movie_id
ORDER BY movie_count DESC
LIMIT 50;