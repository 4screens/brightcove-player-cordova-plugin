#import "BrightcovePlayer.h"
#import <Cordova/CDV.h>

@implementation BrightcovePlayerPlugin

NSString* token = nil;
NSString* lang = nil;

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
    
  if (lang != nil && [self.lang length]) {
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
    
  if (url != nil && [url length] && [self validateUrl:url]) {
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
    
      if (videoId != nil && [videoId length]) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[NSString stringWithFormat:@"Playing now with Brightcove ID: %@", videoId]];
      } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Empty video ID!"];
      }
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (BOOL)validateUrl:(NSString *)url {
  NSURL *testURL = [NSURL URLWithString:url];
  if (testURL == nil) {
    return NO;
  }
  else {
    return YES;
  }
}

@end