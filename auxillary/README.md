### Validate Instance

* Test the Node installation

      node moviematch/test/simpleServer.js
      curl http://localhost:8080/

* Test that there are some movies in the database and they have ratings

      hive -f test/raw_ratings.sql
      spark-sql -f test/ratings.sql