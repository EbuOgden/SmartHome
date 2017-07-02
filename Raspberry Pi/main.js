const app = require('express')();
const bodyParser = require('body-parser');
const server = require('http').createServer(app);

const controller = require('./controller')

const port = 3000;

app.use(bodyParser.urlencoded({extended: false}));
app.use(bodyParser.json());

app.post('/', controller.controller.light);


server.listen(port, () => {
  console.log("Running on port " + port);
})
