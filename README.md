Brightcove Player Cordova Plugin 
======

The `net.nopattern.cordova.brightcoveplayer` object provides functions to make interacting with the native player provided by Brightcove for Cordova. Player works with Brightcove Video Cloud hosting (so you can play video by Brigthcove ID) and also you can play any video by providing the video URL. Ability to work with IMA Ad also implemented.

    cordova plugin add https://github.com/4screens/brightcove-player-cordova-plugin.git

Methods
-------

- cordova.plugins.BrightcovePlayerPlugin.init
- cordova.plugins.BrightcovePlayerPlugin.setLanguage
- cordova.plugins.BrightcovePlayerPlugin.playByUrl
- cordova.plugins.BrightcovePlayerPlugin.playById

Properties
--------



Events
--------



BrightcovePlayerPlugin.init
=================

This method make accessable the ability to get video by brightcove ID. You must provide your Brigthcove Token as parameter.

    cordova.plugins.Keyboard.BrightcovePlayerPlugin.init(brightcoveToken);

Supported Platforms
-------------------

- Android

BrightcovePlayerPlugin.setLanguge
=================

Sets the preferred language for the ad UI. This must be a 2-letter ISO 639-1 language code. If invalid or unsupported, the language will default to "en" for English.

    cordova.plugins.Keyboard.BrightcovePlayerPlugin.setLanguage(lang);

ISO 639-1 list: 
http://www.loc.gov/standards/iso639-2/php/English_list.php

Supported Platforms
-------------------

- Android

BrightcovePlayerPlugin.playById
=================

Play video by Brightcove Video ID. You must init the brightcove before using with BrightcovePlayerPlugin.init!

    cordova.plugins.Keyboard.BrightcovePlayerPlugin.playById(brigthcoveVideoId);

Also if you want to preroll Ad before your video just provide Vast link as the second parameter.

    cordova.plugins.Keyboard.BrightcovePlayerPlugin.playById(brigthcoveVideoId, vastLink);

Supported Platforms
-------------------

- Android

BrightcovePlayerPlugin.playByUrl
=================

Play video by URL. There is no need in init.

    cordova.plugins.Keyboard.BrightcovePlayerPlugin.playByUrl(videoUrl);

Also if you want to preroll Ad before your video like in playById just provide Vast link as the second parameter.

    cordova.plugins.Keyboard.BrightcovePlayerPlugin.playByUrl(videoUrl, vastLink);

Supported Platforms
-------------------

- Android



