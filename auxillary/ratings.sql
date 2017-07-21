SELECT movie_id, avg(rating) AS average_rating, count(rating) AS rating_count FROM movie_ratings
GROUP BY movie_id
ORDER BY rating_count DESC
LIMIT 50;