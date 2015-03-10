var argscheck = require('cordova/argscheck'),
    utils = require('cordova/utils'),
    exec = require('cordova/exec');


var BrightcovePlayerPlugin = function() {
};

BrightcovePlayerPlugin.play = function(url) {
  exec(null, null, "BrightcovePlayerPlugin", "play", [url]);
};

BrightcovePlayerPlugin.playing = false;

module.exports = BrightcovePlayerPlugin;