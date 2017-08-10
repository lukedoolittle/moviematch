const bodyParser = require('body-parser');
const { exec } = require('child_process');
const express = require('express');
const _ = require('underscore')
var client = require('mongodb').MongoClient;
const app = express();

const port = process.env.port || 8081;
const hostname = 'localhost';
const mongoUrl = "mongodb://localhost:27017/moviematch";

var mongo_get_multiple = function(ids, callback) {
  client.connect(mongoUrl, function(err, db) {
    if (err) {
      console.log('error connecting to database');
      throw err;
    }
    query = { $or:[] };
    for (const x of ids) {
      query.$or.push({ "movielens_id": x });
    }
    db.collection('movies').find(query).toArray(function(err, result) {
      if (err) {
        console.log('error processing query results');
        throw err;
      }
      callback(result.map(function(a) {
                           return {
                             movie_id: a.movielens_id,
                             path: a.poster_path,
                             title: a.title,
                             vote_count: a.vote_count
                           }
      }));
    });
  });
}

app.use(bodyParser.json());

app.post('/api/predict', function (req, res) {
  const payload = JSON.stringify(req.body).replace(/\x22/g, '\\\x22')
  const command = 'spark-submit ../ml/predict.py "' + payload + '"';
  console.log('request: ' + req.path);
  exec(command, (err, stdout, stderr) => {
    if (err) {
      console.log(`error: ${stdout}`);
      return;
    }
    result = JSON.parse(stdout);
    maximum_rating = result[0].rating;
    mongo_get_multiple(result.map(function(a) { return a.movie_id.toString() }), 
                       function(data) {
                         result.sort(function(a, b) {
                           return parseInt(b.vote_count) - parseInt(a.vote_count);
                         });
                         mergedData = data.slice(0,10).map(function(a) {
                           return {
                             movie_id: a.movie_id,
                             path: a.path,
                             title: a.title,
                             rating: Math.round(_.where(result, 
                                                        {movie_id: parseInt(a.movie_id)})[0]
                                                 .rating/maximum_rating*100)
                           }
                         });
                         res.send(mergedData);
                       });
  });
});

app.get('/api/movies/ids/:ids', function (req, res) {
  console.log('request: ' + req.path);
  mongo_get_multiple(req.params['ids'].split(','), 
                     (result) => { res.send(result) });
});

app.get('/api/movies/random/:count', function (req, res) {
  console.log('request: ' + req.path);
  client.connect(mongoUrl, function(err, db) {
    if (err) {
      console.log('error connecting to database')
      throw err;
    }

    size = parseInt(req.params['count'])
    //take 100 times the requested number, sort by vote_count to get the most popular
    //and then return only the requested number
    db.collection('movies').aggregate([{ $sample: { size: size*100 } }]).toArray(function(err, result) {
      if (err) {
        console.log('error processing query results')
        throw err;
      }

      result.sort(function(a, b) {
        return parseInt(b.vote_count) - parseInt(a.vote_count);
      });
      res.send(result.slice(0, size).map(function(a) {
                           return {
                             movie_id: a.movielens_id,
                             path: a.poster_path,
                             title: a.title
                           }
                         })
      );
      db.close();
    });
  });
});

app.listen(port, hostname, function () {
  console.log(`Server running at http://${hostname}:${port}/`);
});