#!/usr/bin/env node
var fs = require('fs')
    _  = require('underscore')
   ,rocketstring = ''
   ,rocketjson   = {}
fs.readFile('../assets/rocket.js', {"encoding":'utf-8'}, function (err, rocketstring) {
    if (err) throw err;
    rocketjson = JSON.parse(rocketstring)
    rocketstring = JSON.stringify(rocketjson)

    rocketjson = parseJSON(rocketjson)

    fs.writeFile('../data/rocket.min.json', rocketstring, function (err) {
        if (err) throw err;
        console.log('Rocket takeoff!');
    });
});
function parseJSON (json) {
    if(_.isArray(json))
        _.each(json,parseJSON)
    if(_.isObject(json))
        for (var prop in json)
            json[prop] = json[prop].toString()
}