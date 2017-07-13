# Data Loading

### Load Initial Data

      ./initial_data_load.sh

### Validate

* Test that there are some movies in the database and they have ratings

      hive -f test/raw_ratings.sql
      spark-sql -f test/ratings.sql