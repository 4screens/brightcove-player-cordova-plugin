#import "BrightcovePlugin.h"

@implementation BrightcovePlayerPlugin

NSString* token = nil;
NSString* lang = nil;
BrightcovePluginViewController *brightcoveView = nil;
UIStoryboard *storyboard = nil;

- (void)initBrightcoveView
{
    if (self.brightcoveView == nil) {
        UIStoryboard *storyboardTemp = [UIStoryboard storyboardWithName:@"BrightcovePlugin"
                                                  bundle:nil];
        self.storyboard = storyboardTemp;

        self.brightcoveView = [self.storyboard instantiateInitialViewController];
        self.brightcoveView.delegate = self;
        self.brightcoveView.kViewControllerIMALanguage = self.lang;
        self.brightcoveView.kViewControllerCatalogToken = self.token;
    } else {
        self.brightcoveView.kViewControllerIMALanguage = self.lang;
        self.brightcoveView.kViewControllerCatalogToken = self.token;
        [self.brightcoveView setup];
    }
    [self playerShown];
}

#pragma mark - Cordova Events

- (void) playerHidden:(NSString *)currentTime
{
  if ([currentTime isEqualToString:@"-inf"]){
    currentTime = @"0";
  }
    NSLog(@"CurrentTime: %@", currentTime);
  [self.commandDelegate evalJs:[NSString stringWithFormat:@"cordova.fireWindowEvent('brightcovePlayer.hide', {'currentTime': %@})", currentTime]];
  self.brightcoveView = nil;
}

- (void) playerShown
{
  [self.commandDelegate evalJs:[NSString stringWithFormat:@"cordova.fireWindowEvent('brightcovePlayer.show')"]];
}

- (void) playVideo:(NSString *)currentTime withDuration:(NSString *)duration
{
  if ([currentTime isEqualToString:@"-inf"]){
    currentTime = @"0";
  }
  if ([duration isEqualToString:@"-inf"]){
    currentTime = @"0";
  }
  [self.commandDelegate evalJs:[NSString stringWithFormat:@"cordova.fireWindowEvent('brightcovePlayer.play', {'duration': %@, 'currentTime': %@})", duration, currentTime]];
}

- (void) pauseVideo:(NSString *)currentTime
{
  if ([currentTime isEqualToString:@"-inf"]){
    currentTime = @"0";
  }
  [self.commandDelegate evalJs:[NSString stringWithFormat:@"cordova.fireWindowEvent('brightcovePlayer.pause', {'currentTime': %@})", currentTime]];
}

- (void) bufferingVideo
{
    [self.commandDelegate evalJs:[NSString stringWithFormat:@"cordova.fireWindowEvent('brightcovePlayer.buffering')"]];
}

- (void)seekingVideo
{}

- (void)seekedVideo
{}

- (void)endedVideo
{
    [self.commandDelegate evalJs:[NSString stringWithFormat:@"cordova.fireWindowEvent('brightcovePlayer.ended')"]];
}

- (void)adStarted
{
    [self.commandDelegate evalJs:[NSString stringWithFormat:@"cordova.fireWindowEvent('brightcovePlayer.adStarted')"]];
}

- (void)adCompleted
{
    [self.commandDelegate evalJs:[NSString stringWithFormat:@"cordova.fireWindowEvent('brightcovePlayer.adCompleted')"]];
}

- (void)allAdsCompleted
{

}

#pragma mark - Cordova Methods

- (void)init:(CDVInvokedUrlCommand*)command
{
  CDVPluginResult* pluginResult = nil;
  self.token = [command argumentAtIndex:0 withDefault:@"" andClass:[NSString class]];

  if (self.token != nil && [self.token length]) {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Inited"];
  } else{
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Empty Brightcove token!"];
  }

  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)setLanguage:(CDVInvokedUrlCommand*)command
{
  CDVPluginResult* pluginResult = nil;
  self.lang = [command argumentAtIndex:0 withDefault:@"" andClass:[NSString class]];

  if (self.lang != nil && [self.lang length]) {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Language inited"];
  } else {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Please set language!"];
  }

  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)playByUrl:(CDVInvokedUrlCommand*)command
{
  CDVPluginResult* pluginResult = nil;

  NSString* url = [command argumentAtIndex:0 withDefault:@"" andClass:[NSString class]];
  NSString* vastLink = [command argumentAtIndex:1 withDefault:@"" andClass:[NSString class]];

  if (url != nil && [url length] && [self validateUrl:url]) {
    [self initBrightcoveView];
    [self setVideoUrl:url];
    if (vastLink != nil && [vastLink length]){
      [self setVast:vastLink];
    }
    [self.viewController presentViewController:self.brightcoveView animated:YES completion:nil];
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[NSString stringWithFormat:@"Playing now with URL: %@", url]];
  } else {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"URL is not valid or empty!"];
  }

  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)playById:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;

    if (self.token == nil && ![self.token length]) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Please init the brightcove with token!"];
    } else {
      NSString* videoId = [command argumentAtIndex:0 withDefault:@"" andClass:[NSString class]];
      NSString* vastLink = [command argumentAtIndex:1 withDefault:@"" andClass:[NSString class]];
      if (videoId != nil && [videoId length]) {
        [self initBrightcoveView];
        [self setVideoId:videoId];
        if (vastLink != nil && [vastLink length]){
          [self setVast:vastLink];
        }
        [self.viewController presentViewController:self.brightcoveView animated:YES completion:nil];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[NSString stringWithFormat:@"Playing now with Brightcove ID: %@", videoId]];
      } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Empty video ID!"];
      }
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

#pragma mark - Helper_Methods

- (BOOL)validateUrl:(NSString *)url {
  NSURL *testURL = [NSURL URLWithString:url];
  if (testURL == nil) {
    return NO;
  }
  else {
    return YES;
  }
}

- (void)setVideoId:(NSString *)videoId
{
    self.brightcoveView.kViewControllerPlaylistID = videoId;
}

- (void)setVideoUrl:(NSString *)videoUrl
{
    self.brightcoveView.kViewControllerVideoURL = videoUrl;
}

- (void)setVast:(NSString *)vastLink
{
    self.brightcoveView.kViewControllerIMAVMAPResponseAdTag = vastLink;
}

@end