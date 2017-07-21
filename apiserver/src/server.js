const bodyParser = require('body-parser');
const { exec } = require('child_process');
const express = require('express');
const app = express();

const port = process.env.port || 8081;
const hostname = 'localhost';

app.use(bodyParser.json());

app.post('/api/predict', function (req, res) {
  const command = 'spark-submit ../ml/predict.py "' + JSON.stringify(req.body).replace(/\x22/g, '\\\x22') + '"';
  console.log('got api/predict request');
  exec(command, (err, stdout, stderr) => {
    if (err) {
      console.log('error processing spark request');
      //console.log(`stdout: ${stdout}`);
      return;
    }
    //console.log(`stdout: ${stdout}`);
    //console.log(`stderr: ${stderr}`);
    res.send(stdout)
  });
});

app.get('/api/movies/ids', function (req, res) {
  console.log('got api/movies/ids request')
  //next parameter is list of ids
});

app.get('/api/movies/random', function (req, res) {
  console.log('got api/movies/random request')
  //next parameter is number of random movies
});

app.listen(port, hostname, function () {
  console.log(`Server running at http://${hostname}:${port}/`);
});