var exec = require('child_process').exec;

var controller = {
  light: (req, res) => {

    var body = req.body;
    var query = body.query;

    var split = query.split(" ");

    split = split.filter((str) => {
      return /\S/.test(str);
    })

    if((split[0] == "light" || split[0] == "lights") && (split[1] == "on")){
        console.log("Light On!" + split)
	setTimeout(() => {
            exec('idle -r lightOn.py', (err, stdout, stderr) => {});
        }, 500);

    }

    if((split[0] == "light" || split[0] == "lights") && (split[1] == "off" || split[1] == "of")){
      console.log("Light Off!" + split)
	setTimeout(() => {
          exec('sudo python lightOff.py', (err, stdout, stderr) => {});
      }, 500);
    }
  }
}

exports.controller = controller
