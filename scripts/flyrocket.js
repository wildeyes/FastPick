#!/usr/bin/env node
var fs = require('fs')
  , lm = 'last-modified-rocket.tmp'
  , lmd = null
  , rocketfile = '../assets/rocket.js'
  , hasntchanged = false
// fs.existsSync(lm, function (exists) {
//   if(exists) fs.readSync(lm, {encoding:"String"}, lmd)
// })
// fs.statSync(rocketfile,function(err,stats) {
//   console.log(stats)
//   if(err) throw err;
//   if(lmd !== null) {
//     if( lmd == stats.mtime)
//       console.log("Rocket hasn't changed.")
//       hasntchanged = true
//   } else
//       fs.writeFileSync(lm,stats.mtime)
// });

if(hasntchanged)
  return;

console.log('Compiling FlyingRocket!')

rocket = require(rocketfile).rocket
//For testing!
rocket = (typeof(rocket) !== 'undefined') ? rocket : {
    "1": /asd/
   ,"2": "hey2"
   ,"3": "hey3"
   ,"4": "hey4"
   ,"5": "hey5"
   ,"6": "hey6"
   ,"7": "hey7"
}

rocket = clone(rocket)
rocketstring = JSON.stringify(rocket)

// console.log(rocket)

console.log('Testing validity of FlyingRocket...')
rockettest = JSON.parse(rocketstring)

fs.writeFile('../data/rocket.min.json', rocketstring, function (err) {
    if (err) throw err;
    console.log('Rocket takeoff!');
});

//Fucking SO! Would have given up if not you! so helpful! http://stackoverflow.com/questions/728360/most-elegant-way-to-clone-a-javascript-object
function clone(obj) {
    // Handle the 3 simple types, and null or undefined
    if (null == obj || "object" != typeof obj) return obj;

    // Handle Date
    if (obj instanceof RegExp) {
        var copy = obj.toString();
        return copy;
    }

    // Handle string
    if (obj instanceof String) {
        return obj;
    }

    // Handle Array
    if (obj instanceof Array) {
        var copy = [];
        for (var i = 0, len = obj.length; i < len; i++) {
            copy[i] = clone(obj[i]);
        }
        return copy;
    }

    // Handle Object
    if (obj instanceof Object) {
        var copy = {};
        for (var attr in obj) {
            if (obj.hasOwnProperty(attr)) copy[attr] = clone(obj[attr]);
        }
        return copy;
    }

    throw new Error("Unable to copy obj! Its type isn't supported.");
}