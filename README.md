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
These events are fired on the window.

- #### brightcovePlayer.show

  Fired on player shown

  ###### Supported Platforms

  - iOS
  - Android

- #### brightcovePlayer.hide

  Fired on player hide

  ###### Supported Platforms

  - iOS
  - Android

- #### brightcovePlayer.play

  Fired on player play.
  
  The duration of video value is passed as a parameter "duration" with the event.

  ###### Supported Platforms

  - iOS
  - Android

- #### brightcovePlayer.pause

  Fired on player pause

  ###### Supported Platforms

  - iOS
  - Android

- #### brightcovePlayer.ended

  Fired on video ended

  ###### Supported Platforms

  - iOS
  - Android

- #### brightcovePlayer.buffering

  Fired on video buffering

  ###### Supported Platforms

  - iOS
  - Android

- #### brightcovePlayer.adStarted

  Fired on Ad started

  ###### Supported Platforms

  - iOS
  - Android

- #### brightcovePlayer.adCompleted

  Fired on Ad completed

  ###### Supported Platforms

  - iOS
  - Android

- #### brightcovePlayer.seeked

  Fired after video seeked

  ###### Supported Platforms

  - Android

Methods description 
======

BrightcovePlayerPlugin.init
=================

This method make accessable the ability to get video by brightcove ID. You must provide your Brigthcove Token as parameter.

    cordova.plugins.BrightcovePlayerPlugin.init(brightcoveToken);

Supported Platforms
-------------------

- Android
- iOS

BrightcovePlayerPlugin.setLanguage
=================

Sets the preferred language for the ad UI. This must be a 2-letter ISO 639-1 language code. If invalid or unsupported, the language will default to "en" for English.

    cordova.plugins.BrightcovePlayerPlugin.setLanguage(lang);

ISO 639-1 list: 
http://www.loc.gov/standards/iso639-2/php/English_list.php

Supported Platforms
-------------------

- Android
- iOS

BrightcovePlayerPlugin.playById
=================

Play video by Brightcove Video ID. You must init the brightcove before using with BrightcovePlayerPlugin.init!

    cordova.plugins.BrightcovePlayerPlugin.playById(brigthcoveVideoId);

Also if you want to preroll Ad before your video just provide Vast link as the second parameter.

    cordova.plugins.BrightcovePlayerPlugin.playById(brigthcoveVideoId, vastLink);

Supported Platforms
-------------------

- Android
- iOS

BrightcovePlayerPlugin.playByUrl
=================

Play video by URL. There is no need in init.

    cordova.plugins.BrightcovePlayerPlugin.playByUrl(videoUrl);

Also if you want to preroll Ad before your video like in playById just provide Vast link as the second parameter.

    cordova.plugins.BrightcovePlayerPlugin.playByUrl(videoUrl, vastLink);

Supported Platforms
-------------------

- Android
- iOS

TO DO
===================

- Localization for "Done" button



