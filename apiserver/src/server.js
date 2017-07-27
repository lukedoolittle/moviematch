const bodyParser = require('body-parser');
const { exec } = require('child_process');
const express = require('express');
var client = require('mongodb').MongoClient;
const app = express();

const port = process.env.port || 8081;
const hostname = 'localhost';
const mongoUrl = "mongodb://localhost:27017/moviematch";

app.use(bodyParser.json());

app.post('/api/predict', function (req, res) {
  const command = 'spark-submit ../ml/predict.py "' 
    + JSON.stringify(req.body).replace(/\x22/g, '\\\x22') 
    + '"';
  console.log('got api/predict request');
  exec(command, (err, stdout, stderr) => {
    if (err) {
      console.log('error processing spark request');
      console.log(`stdout: ${stdout}`);
      return;
    }
    res.send(stdout)
  });
});

app.get('/api/movies/ids/:ids', function (req, res) {
  console.log('got api/movies/ids request');
  client.connect(mongoUrl, function(err, db) {
    if (err) {
      console.log('error connecting to database');
      throw err;
    }
    query = { $or:[] };
    for (const x of req.params['ids'].split(',')) {
      query.$or.push({movielens_id: x});
    }

    db.collection('movies').find(query).toArray(function(err, result) {
      if (err) {
        console.log('error processing query results');
        throw err;
      }
      res.send(result);
      db.close();
    });
  });
});

app.get('/api/movies/random/:count', function (req, res) {
  console.log('got api/movies/random request')
  client.connect(mongoUrl, function(err, db) {
    if (err) {
      console.log('error connecting to database')
      throw err;
    }
    //console.log('connected to database')
    size = parseInt(req.params['count'])
    db.collection('movies').aggregate([{ $sample: { size: size } }]).toArray(function(err, result) {
      if (err) {
        console.log('error processing query results')
        throw err;
      }
      //console.log('query complete');
      res.send(result)
      db.close();
    });
  });
});

app.listen(port, hostname, function () {
  console.log(`Server running at http://${hostname}:${port}/`);
});