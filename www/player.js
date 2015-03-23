var argscheck = require('cordova/argscheck'),
    utils = require('cordova/utils'),
    exec = require('cordova/exec');


var BrightcovePlayerPlugin = function() {
};

BrightcovePlayerPlugin.playByUrl = function(url, vastLink) {
  exec(
    successHandler, 
    errorHandler, 
    "BrightcovePlayerPlugin", 
    "playByUrl", 
    [url, vastLink || null]
  );
};

BrightcovePlayerPlugin.playById = function(id, vastLink) {
  exec(
    successHandler, 
    errorHandler, 
    "BrightcovePlayerPlugin", 
    "playById", 
    [String(id), vastLink || null]
  );
};

BrightcovePlayerPlugin.init = function(token) {
  exec(
    successHandler, 
    errorHandler, 
    "BrightcovePlayerPlugin", 
    "init", 
    [token || null]
  );
};

BrightcovePlayerPlugin.setLanguage = function(lang) {
  exec(
    successHandler, 
    errorHandler, 
    "BrightcovePlayerPlugin", 
    "setLanguage", 
    [lang || null]
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