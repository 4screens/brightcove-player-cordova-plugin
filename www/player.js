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

BrightcovePlayerPlugin.playById = function(id) {
  exec(
    successHandler, 
    errorHandler, 
    "BrightcovePlayerPlugin", 
    "playById", 
    [id.toString()]
  );
};

BrightcovePlayerPlugin.init = function(token) {
  exec(
    successHandler, 
    errorHandler, 
    "BrightcovePlayerPlugin", 
    "init", 
    [token]
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