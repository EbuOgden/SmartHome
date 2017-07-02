var request = require('request');

var controller = {
  light: (req, res) => {
    var body = req.body;
    var query = body.query;

    var options = {
      url: "http://192.168.2.2:3000",
      method: 'POST',
      form: {
        query : query
      }
    }

    console.log(options)
    request(options, (error, response, body) => {
      if(error) { console.log(error); }
      console.log(body);
    })


  }
}

exports.controller = controller
