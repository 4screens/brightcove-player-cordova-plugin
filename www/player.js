var argscheck = require('cordova/argscheck'),
    utils = require('cordova/utils'),
    exec = require('cordova/exec');


var BrightcovePlayerPlugin = function() {
};

BrightcovePlayerPlugin.playByUrl = function(url) {
  exec(
    successHandler, 
    errorHandler, 
    "BrightcovePlayerPlugin", 
    "playByUrl", 
    [url]
  );
};

BrightcovePlayerPlugin.playById = function(url) {
  exec(
    successHandler, 
    errorHandler, 
    "BrightcovePlayerPlugin", 
    "playById", 
    [url]
  );
};

function successHandler(success) {
  console.log(success);
}

function errorHandler(error) {
  console.log(error);
}

BrightcovePlayerPlugin.playing = false;

module.exports = BrightcovePlayerPlugin;