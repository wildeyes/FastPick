#!/usr/bin/env node
var fs = require('fs')
   ,rocketstring = ''
   ,rocketjson   = {}
fs.readFile('assets/rocket.json', {"encoding":'utf-8'}, function (err, rocketstring) {
    if (err) throw err;
    rocketjson = JSON.parse(rocketstring)
    rocketstring = JSON.stringify(rocketjson)

    fs.writeFile('data/rocket.min.json', rocketstring, function (err) {
        if (err) throw err;
        console.log('Rocket takeoff!');
    });
});