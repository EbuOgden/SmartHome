//	
//	ebubekirogden@gmail.com
//  
//	Created by Ebubekir Ogden on 8/15/17.
//  Copyright © 2017 Ebubekir. All rights reserved.
//	



var app = require('express')();
var logger = require('morgan');
var http = require('http').Server(app);
var bodyParser = require('body-parser');
var io = require('socket.io')(http);

var PythonShell = require('python-shell');

var pyshell_temp = new PythonShell('Temperature.py');
var pyshell_flame = new PythonShell('Flame.py');
var pyshell_gas = new PythonShell('Gas.py');
var pyshell_ultrasonic = new PythonShell('Ultrasonic.py');
var pyshell_water = new PythonShell('Rain.py');

var electric_on = true;
var buzzer_on = false;
var led_light_on = false;

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended: false}));

app.use(logger('dev'));

app.set('port', process.env.PORT || 3000);

io.on('connection', function(socket){
    
    socket.on('disconnect', function(){
		console.log("A Socket Connection is Closed!");
    })
	
	PythonShell.run('ElectricOn.py', function(err, results){
	
		if(err) throw err;
	
    });

    pyshell_temp.on('message', function(temp_message) {

        var temp_split = temp_message.split();
        temp_split[0] = parseInt(temp_split[0], 10);
		socket.emit('Temperature', temp_split[0]);
    })

    pyshell_flame.on('message', function(flame_message){

        var flame_split = flame_message.split();
		flame_split[0] = parseInt(flame_split[0], 10);
	
		if(flame_split[0] == 0){
			socket.emit('Fire', "");

			if(!led_light_on){
				PythonShell.run('LED_Light_On.py', function(err, results){
					if(err){
						throw err;
					}
				});
		
				led_light_on = true
				socket.emit('LedCurrent', true)
			}

			if(electric_on){
				PythonShell('ElectricOff.py')
				electric_on = false;
				socket.emit('ElectricCurrent', false)
			}
		}
	
    })

    pyshell_gas.on('message', function(gas_message){

        var gas_split = gas_message.split();
		gas_split[0] = parseInt(gas_split[0], 10);

		if(gas_split[0] == 1){ // 0 is safe
			socket.emit('Gas', "");

			if(!led_light_on){
				PythonShell.run('LED_Light_On.py', function(err, results){
					if(err){
						throw err;
					}
				});
		
				led_light_on = true
					socket.emit('LedCurrent', true)
			}

			if(electric_on){
				PythonShell.run('ElectricOff.py', function(err, results){
					if(err){
						throw err;
					}
				})

				electric_on = false;
				socket.emit('ElectricCurrent', false)
			}
		}
	
    })

    pyshell_water.on('message', function(water_message){
	
		var water_split = water_message.split();
		water_split[0] = parseInt(water_split[0], 10);
		
		if(water_split[0] == 0){ // 1 is safe
			socket.emit('Water', "");

			if(!led_light_on){
				PythonShell.run('LED_Light_On.py', function(err, results){
					if(err){
						throw err;
					}
				});
		
				led_light_on = true
				socket.emit('LedCurrent', true)
			}

			if(electric_on){
				PythonShell.run('ElectricOff.py', function(err, results){
					if(err){
						throw err;
					}
				})

				electric_on = false;
				socket.emit('ElectricCurrent', false)
			}

			if(!buzzer_on){
				PythonShell.run('BuzzerOn.py', function(err, results){
					if(err) throw err;
				})
		
				buzzer_on = true;
				socket.emit('BuzzerCurrent', true);
			}
		}
    })

    pyshell_ultrasonic.on('message', function(ultrasonic_message){

        var ultrasonic_split = ultrasonic_message.split();
        ultrasonic_split[0] = parseInt(ultrasonic_split[0], 10);
	
		if(ultrasonic_split[0] < 25){
			if(!led_light_on){
				PythonShell.run('LED_Light_On.py', function(err, results){
					if(err){
						throw err;
					}
				});

				led_light_on = true
				socket.emit('LedCurrent', true);
			}

			if(!buzzer_on){
				PythonShell.run('BuzzerOn.py', function(err, results){
					if(err) throw err;
				})

				buzzer_on = true;
				socket.emit('BuzzerCurrent', true);
			}

			socket.emit('Intruder', true);
		
		}
 
    })

    socket.on('BuzzerSet', function(message){
	
		if(buzzer_on){
			PythonShell.run('BuzzerOff.py', function(err, results){
				if(err) throw err;
			})

			buzzer_on = false;
			socket.emit('BuzzerCurrent', false);
		}
		else{
			PythonShell.run('BuzzerOn.py', function(err, results){
				if(err) throw err;
			})

			buzzer_on = true;
			socket.emit('BuzzerCurrent', true);
		}
        
    })

    socket.on('LedSet', function(message){
	
		if(led_light_on){
			PythonShell.run('LED_Light_Off.py', function(err, results){
				if(err) throw err;
			});

			led_light_on = false;
			socket.emit('LedCurrent', false);
		}
		else{
			PythonShell.run('LED_Light_On.py', function(err, results){
				if(err) throw err;
			});

			led_light_on = true;
			socket.emit('LedCurrent', true);
		}

    });

    socket.on('ElectricSet', function(message){
	
		if(electric_on){
			PythonShell.run('ElectricOff.py', function(err, results){
				if(err){
					throw err;
				}
			});
		
			electric_on = false;
			socket.emit('ElectricCurrent', false)
		}
		else{
			PythonShell.run('ElectricOn.py', function(err, results){
				if(err){
					throw err;
				}
			});
		
			electric_on = true;
			socket.emit('ElectricCurrent', true)
		}
    });
})

http.listen(app.get('port'), function(){
  	console.log("App is listening on " + app.get('port'));
})
