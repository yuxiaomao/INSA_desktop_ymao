const express = require('express')
var app = express()
const bodyParser = require('body-parser');
const ejs = require('ejs');
var mariasql = require('mariasql');

var clientSQL = new mariasql({
  host: '127.0.0.1',
  user: 'user1',
  port: 3306,
  db: 'mytest'
  //si on specifie ici, apres pas besoin 'mytest.''
});

// express begin
console.log("Server Begin")
app.set('view engine', 'ejs');

//Note that in version 4 of express, express.bodyParser() was
//deprecated in favor of a separate 'body-parser' module.
app.use(bodyParser.urlencoded({ extended: true }));

app.get('/', function(req, res) {
    //res.sendFile(path.join(__dirname + '/index.html'));
    console.log("APP get")

    clientSQL.query('SELECT * FROM INFORMATION ',
            function(err, rows) {
      if (err)
        throw err;
      console.dir(rows);
      res.render('index', {intA:"??", intB:"??", intS:"??", table:JSON.stringify(rows)})
    });

})

app.post('/action_form', function(req, res) {
    console.log("APP Post")
    var va = req.body.intA;
    var vb = req.body.intB;
    var vs = Number(va)+Number(vb);

    clientSQL.query("INSERT INTO `INFORMATION` (`int_a`, `int_b`, `int_s`) VALUES (?, ?, ?) ",
                [va,vb,vs], function(err, rows) {
      if (err)
        throw err;
      console.log('Last Insert ID'+clientSQL.lastInsertId())
    });

    clientSQL.query('SELECT * FROM INFORMATION ',
            function(err, rows) {
      if (err)
        throw err;
      console.dir(rows);
      res.render('index', {intA:va, intB:vb, intS:vs, table:JSON.stringify(rows)})
    });
});

app.listen(8080, function(req,res) {
    console.log('Express listening on port 8080')
})

clientSQL.end();
